import { showHUD, getPreferenceValues } from "@raycast/api";
import { formatDuration, getDuration, stopTimer } from "./Timers";
import { Preferences } from "./types";
import { promises as fs } from 'fs';
import moment from 'moment';

export default async function Command() {
  const timer = await stopTimer();
  if (timer === null) {
    await showHUD("No timer running");
    return;
  }
	let duration = getDuration(timer);
	let minutes = Math.ceil(duration / 1000 / 60);
	const preferences = getPreferenceValues<Preferences>();
	await fs.appendFile(preferences.hoursFile, `${timer.id},${minutes},${timer.name?.replace(/[^a-z0-9]/gi, '').substring(0,15)},${moment().format('HH:mm:ss')},${moment().format('YYYY-MM-DD')}\r\n`, 'utf8');
  await showHUD(`Stopped ${timer.name}: ${formatDuration(duration)}`);
}
