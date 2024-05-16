import { launchCommand, LaunchType } from "@raycast/api";

export default async function Command() {
  return launchCommand({ name: "choose-client", type: LaunchType.UserInitiated, context: { timerType: "invoice" } });
}
