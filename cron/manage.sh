#!/usr/bin/env bash
#
# Syncs launchd agents with the shell scripts in this directory.
#
# Each script opts in with a cron-format schedule comment, e.g.:
#
#   # cron: */15 * * * *
#
# Scripts without that comment are ignored. Agents previously created from
# this directory whose script (or schedule comment) is gone are removed.

set -euo pipefail

CRON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABEL_PREFIX="com.rsefer.dotfiles.cron"
AGENTS_DIR="$HOME/Library/LaunchAgents"
LOG_DIR="$HOME/Library/Logs/dotfiles-cron"
DOMAIN="gui/$(id -u)"

mkdir -p "$AGENTS_DIR" "$LOG_DIR"

info() { printf '\033[0;34m[cron]\033[0m %s\n' "$1"; }
fail() { printf '\033[0;31m[cron]\033[0m %s\n' "$1" >&2; }

# expand_field <spec> <min> <max>
# Prints "*" for a wildcard, otherwise the expanded values one per line.
expand_field() {
	local spec="$1" min="$2" max="$3" part step range start end value

	if [[ "$spec" == "*" ]]; then
		echo "*"
		return 0
	fi

	local -a values=()
	local IFS=','
	for part in $spec; do
		step=1
		range="$part"
		if [[ "$part" == */* ]]; then
			step="${part##*/}"
			range="${part%%/*}"
			[[ "$step" =~ ^[0-9]+$ ]] && (( step > 0 )) || return 1
		fi

		if [[ "$range" == "*" ]]; then
			start="$min" end="$max"
		elif [[ "$range" == *-* ]]; then
			start="${range%%-*}" end="${range##*-}"
		else
			start="$range" end="$range"
		fi

		[[ "$start" =~ ^[0-9]+$ && "$end" =~ ^[0-9]+$ ]] || return 1
		(( start >= min && end <= max && start <= end )) || return 1

		for (( value = start; value <= end; value += step )); do
			values+=("$value")
		done
	done

	printf '%s\n' "${values[@]}" | sort -n -u
}

# schedule_xml <cron expression>
# Prints the launchd scheduling keys for the given five-field cron expression.
schedule_xml() {
	local expression="$1"
	local -a fields
	read -r -a fields <<< "$expression"
	(( ${#fields[@]} == 5 )) || return 1

	local minutes hours days months weekdays
	minutes="$(expand_field "${fields[0]}" 0 59)" || return 1
	hours="$(expand_field "${fields[1]}" 0 23)" || return 1
	days="$(expand_field "${fields[2]}" 1 31)" || return 1
	months="$(expand_field "${fields[3]}" 1 12)" || return 1
	weekdays="$(expand_field "${fields[4]}" 0 7)" || return 1

	# "*/N * * * *" maps cleanly onto a simple interval.
	if [[ "${fields[0]}" == \*/* && "${fields[0]#*/}" =~ ^[0-9]+$ ]] \
		&& [[ "$hours$days$months$weekdays" == "****" ]]; then
		printf '\t<key>StartInterval</key>\n\t<integer>%s</integer>\n' \
			$(( ${fields[0]#*/} * 60 ))
		return 0
	fi

	local minute hour day month weekday
	printf '\t<key>StartCalendarInterval</key>\n\t<array>\n'
	for minute in $minutes; do
		for hour in $hours; do
			for day in $days; do
				for month in $months; do
					for weekday in $weekdays; do
						printf '\t\t<dict>\n'
						[[ "$minute" != "*" ]] && printf '\t\t\t<key>Minute</key><integer>%s</integer>\n' "$minute"
						[[ "$hour" != "*" ]] && printf '\t\t\t<key>Hour</key><integer>%s</integer>\n' "$hour"
						[[ "$day" != "*" ]] && printf '\t\t\t<key>Day</key><integer>%s</integer>\n' "$day"
						[[ "$month" != "*" ]] && printf '\t\t\t<key>Month</key><integer>%s</integer>\n' "$month"
						[[ "$weekday" != "*" ]] && printf '\t\t\t<key>Weekday</key><integer>%s</integer>\n' "$weekday"
						printf '\t\t</dict>\n'
					done
				done
			done
		done
	done
	printf '\t</array>\n'
}

# plist_body <label> <script path> <cron expression>
plist_body() {
	local label="$1" script="$2" expression="$3" schedule
	schedule="$(schedule_xml "$expression")" || return 1

	cat <<-PLIST
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
		<plist version="1.0">
		<dict>
			<key>Label</key>
			<string>${label}</string>
			<key>ProgramArguments</key>
			<array>
				<string>/bin/bash</string>
				<string>${script}</string>
			</array>
			<key>StandardOutPath</key>
			<string>${LOG_DIR}/${label}.log</string>
			<key>StandardErrorPath</key>
			<string>${LOG_DIR}/${label}.log</string>
			<key>RunAtLoad</key>
			<false/>
			<key>Comment</key>
			<string>managed-by:${LABEL_PREFIX} schedule:${expression}</string>
		${schedule}</dict>
		</plist>
	PLIST
}

reload_agent() {
	local label="$1" plist="$2"
	launchctl bootout "$DOMAIN/$label" >/dev/null 2>&1 || true
	launchctl bootstrap "$DOMAIN" "$plist"
}

declare -a managed_labels=()

for script in "$CRON_DIR"/*.sh; do
	[[ -f "$script" ]] || continue
	[[ "$(basename "$script")" == "$(basename "${BASH_SOURCE[0]}")" ]] && continue

	expression="$(sed -n 's/^#[[:space:]]*cron:[[:space:]]*//p' "$script" | head -n 1)"
	[[ -n "$expression" ]] || continue

	name="$(basename "$script" .sh)"
	label="${LABEL_PREFIX}.${name}"
	plist="$AGENTS_DIR/${label}.plist"

	if ! body="$(plist_body "$label" "$script" "$expression")"; then
		fail "skipping $name: invalid cron expression '$expression'"
		continue
	fi

	managed_labels+=("$label")
	chmod +x "$script"

	if [[ -f "$plist" ]] && [[ "$(cat "$plist")" == "$body" ]]; then
		info "unchanged: $label ($expression)"
		continue
	fi

	action="created"
	[[ -f "$plist" ]] && action="updated"
	printf '%s\n' "$body" > "$plist"
	reload_agent "$label" "$plist"
	info "$action: $label ($expression)"
done

for plist in "$AGENTS_DIR/${LABEL_PREFIX}."*.plist; do
	[[ -f "$plist" ]] || continue
	label="$(basename "$plist" .plist)"

	for managed in ${managed_labels[@]+"${managed_labels[@]}"}; do
		[[ "$managed" == "$label" ]] && continue 2
	done

	launchctl bootout "$DOMAIN/$label" >/dev/null 2>&1 || true
	rm -f "$plist"
	info "removed: $label"
done
