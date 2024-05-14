import { launchCommand, LaunchType } from "@raycast/api";
import { runningTimer } from "./Timers";

export default async function Command() {
	if (await runningTimer()) {
		return launchCommand({ name: "stop-timer", type: LaunchType.Background });
	}
	return launchCommand({ name: "choose-client", type: LaunchType.UserInitiated, context: { timerType: "running" } });
}
