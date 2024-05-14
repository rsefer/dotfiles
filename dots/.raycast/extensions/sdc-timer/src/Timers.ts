import { LocalStorage } from "@raycast/api";

export type Timer = {
  id: number;
  name: string | null;
  start: number;
  end: number | null;
};

export type TimerList = {
  [key: string]: Timer;
};

export async function startTimer(id: number, name: string | null = null): Promise<Timer> {
  await stopTimer();
  const timer: Timer = {
    id: id,
    name: name,
    start: new Date().getTime(),
    end: null
  };
  await LocalStorage.setItem("runningTimer", JSON.stringify(timer));

  return timer;
}

export async function stopTimer(): Promise<Timer | null> {
  const timer = await runningTimer();
  if (!timer) {
    return null;
  }
  timer.end = new Date().getTime();
  await LocalStorage.removeItem("runningTimer");
  return timer;
}

export async function runningTimer(): Promise<Timer | null> {
  const timerRaw = await LocalStorage.getItem<string>("runningTimer");
  if (!timerRaw) {
    return null;
  }
	const timer = JSON.parse(timerRaw)
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
  return `${hours > 0 ? `${hours} hours ` : ''}${minutes} minutes:`;
}

export async function isRunning(): Promise<Boolean> {
	const timer = await runningTimer();
	return timer ? true : false;
}
