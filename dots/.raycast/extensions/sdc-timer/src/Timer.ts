import { LocalStorage, showHUD, getPreferenceValues } from "@raycast/api";
import { Timer, Preferences } from "./types";
import { promises as fs } from "fs";
import moment from "moment";

export async function startTimer(id: number | string, name: string | null = null): Promise<Timer> {
	await stopTimer();
	const timer: Timer = {
		id: +id,
		name: name,
		start: new Date().getTime(),
		end: null
	};
	await LocalStorage.setItem("runningTimer", JSON.stringify(timer));
	await showHUD(`Started ${timer.name}`);
	return timer;
}

export async function stopTimer(): Promise<Timer | null> {
	const timer = await runningTimer();
	if (!timer) {
		await showHUD("No timer running");
		return null;
	}
	timer.end = new Date().getTime();
	await LocalStorage.removeItem("runningTimer");
	let duration = getDuration(timer);
	let minutes = Math.ceil(duration / 1000 / 60);
	await logTime(timer.id, timer.name, minutes);
	return timer;
}

export async function logTime(id: number, name: string | null, durationMinutes: number): Promise<Boolean> {
	const preferences = getPreferenceValues<Preferences>();
	await fs.appendFile(
		preferences.hoursFile,
		`${id},${name?.replace(/[^a-z0-9]/gi, "").substring(0, 15)},${durationMinutes},${moment().format("HH:mm:ss")},${moment().format("YYYY-MM-DD")}\r\n`,
		"utf8",
	);
	await showHUD(`Logged ${name}: ${durationMinutes} minutes`);
	return true;
}

export async function runningTimer(): Promise<Timer | null> {
	const timerRaw = await LocalStorage.getItem<string>("runningTimer");
	if (!timerRaw) {
		return null;
	}
	const timer = JSON.parse(timerRaw);
	return timer;
}

export function getDuration(timer: Timer): number {
	const end = timer.end || new Date().getTime();
	return end - timer.start;
}

export function formatDuration(duration: number): string {
	if (!duration) {
		return "-";
	}
	const seconds = Math.floor(duration / 1000);
	const minutes = Math.ceil(seconds / 60);
	const hours = Math.floor(minutes / 60);
	return `${hours > 0 ? `${hours} hour${hours != 1 ? "s" : ""} ` : ""}${minutes} minute${minutes != 1 ? "s" : ""}`;
}
