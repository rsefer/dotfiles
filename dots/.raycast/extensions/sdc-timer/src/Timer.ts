import { LocalStorage, showHUD, Toast, showToast, getPreferenceValues } from "@raycast/api";
import { Timer, Preferences } from "./types";
import { promises as fs } from "fs";
import moment from "moment";

const storageKeys = {
	timer: "timer",
	notifications: "notifications"
}

export async function startTimer(id: number | string, name: string | null = null): Promise<Timer> {
	await stopTimer();
	const timer: Timer = {
		id: +id,
		name: name,
		start: new Date().getTime(),
		end: null,
		diff: 0,
		diffMinutes: 0,
		diffFormatted: {
			short: formatDuration(0, 'short'),
			long: formatDuration(0, 'long')
		}
	};
	await LocalStorage.setItem(storageKeys.timer, JSON.stringify(timer));
	await LocalStorage.setItem(storageKeys.notifications, JSON.stringify([]));
	await notify(`🕐 Started ${timer.name}`);
	return timer;
}

export async function updateTimer(): Promise<Timer | null> {
	let timer = await runningTimer();
	if (!timer) { return null; }
	let shouldNotify = false;
	timer.diff = await getDuration();
	timer.diffMinutes = Math.floor(timer.diff / 1000 / 60);
	timer.diffFormatted.short = formatDuration(timer.diff || 0, 'short');
	timer.diffFormatted.long = formatDuration(timer.diff || 0, 'long');
	if (timer.diffMinutes % 15 == 0) {
		let spentNotifications = [];
		const spentNotificationsRaw = await LocalStorage.getItem<string>(storageKeys.notifications);
		if (spentNotificationsRaw) {
			spentNotifications = JSON.parse(spentNotificationsRaw);
		}
		if (!spentNotifications.includes(timer.diffMinutes)) {
			shouldNotify = true;
			spentNotifications.push(timer.diffMinutes);
			await LocalStorage.setItem(storageKeys.notifications, JSON.stringify(spentNotifications));
		}
	}
	await LocalStorage.setItem(storageKeys.timer, JSON.stringify(timer));
	if (shouldNotify) {
		await notify(`🕐 ${timer.name}: ${timer.diffFormatted.long}`);
	}
	return timer;
}

export async function stopTimer(): Promise<Timer | null> {
	const timer = await updateTimer();
	if (!timer) {
		return null;
	}
	timer.end = new Date().getTime();
	await LocalStorage.removeItem(storageKeys.timer);
	await LocalStorage.removeItem(storageKeys.notifications);
	await logTime(timer.id, timer.name, timer.diffMinutes || 0);
	return timer;
}

export async function logTime(id: number, name: string | null, durationMinutes: number): Promise<Boolean> {
	const preferences = getPreferenceValues<Preferences>();
	await fs.appendFile(
		preferences.hoursFile,
		`${id},${name?.replace(/[^a-z0-9]/gi, "").substring(0, 15)},${durationMinutes},${moment().format("HH:mm:ss")},${moment().format("YYYY-MM-DD")}\r\n`,
		"utf8",
	);
	await notify(`✏️ Logged ${name}: ${durationMinutes} minutes`);
	return true;
}

export async function runningTimer(): Promise<Timer | null> {
	const timerRaw = await LocalStorage.getItem<string>(storageKeys.timer);
	if (!timerRaw) {
		return null;
	}
	const timer = JSON.parse(timerRaw);
	return timer;
}

export async function getDuration(): Promise<number>{
	const timer = await runningTimer();
	if (!timer) { return 0; }
	const end = timer.end || new Date().getTime();
	return end - timer.start;
}

export function formatDuration(duration: number, format: string = 'long'): string {
	if (!duration) { duration = 0; }
	const seconds = Math.floor(duration / 1000);
	let minutesWorking = Math.floor(seconds / 60);
	let hours = Math.floor(minutesWorking / 60);
	const minutes = minutesWorking - (hours * 60);
	let hoursString = `${hours > 0 ? `${hours} hour${hours != 1 ? "s" : ""} ` : ""}`;
	let minutesString = `${minutes} minute${minutes != 1 ? "s" : ""}`;
	if (format == 'short') {
		hoursString = `${hours > 0 ? `${hours}h` : ""}`;
		minutesString = `${minutes}m`;
	}
	return `${hoursString}${minutesString}`;
}

export async function notify(message: string, style: Toast.Style | null) {
	// await showToast(style || Toast.Style.Success, message);
	await showHUD(message);
}
