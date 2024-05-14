import { launchCommand, LaunchType } from "@raycast/api";
import { runningTimer, stopTimer } from "./Timer";

export default async function Command() {
	if (await runningTimer()) {
		await stopTimer();
	}
  return launchCommand({ name: "choose-client", type: LaunchType.UserInitiated, context: { timerType: "running" } });
}
