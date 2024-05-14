import { launchCommand, LaunchType } from "@raycast/api";

export default function Command() {
	return launchCommand({ name: "choose-client", type: LaunchType.UserInitiated, context: { timerType: "enter" } });
}
