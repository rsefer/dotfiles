import { Icon, Color, MenuBarExtra, launchCommand, LaunchType } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { runningTimer, updateTimer, stopTimer } from "./Timer";

export default function Command() {
	const { data: currentTimer, isLoading, revalidate } = usePromise(runningTimer, []);
	if (currentTimer) {
		updateTimer();
	}
  return (
    <MenuBarExtra
			isLoading={isLoading}
			icon={{ source: Icon.Stopwatch, tintColor: currentTimer ? Color.Green : null }}
			title={currentTimer ? `${currentTimer.name?.substring(0, 3)} ${currentTimer.diffFormatted.short}` : undefined}
			tooltip="Timer"
		>
			{ currentTimer ?
				<>
				<MenuBarExtra.Item
					title={currentTimer.name||""}
				/>
				<MenuBarExtra.Item
					title="Stop Timer"
					icon={{ source: Icon.Stop, tintColor: Color.Red }}
					onAction={() => stopTimer() }
				/>
				</>
			: <MenuBarExtra.Item
					title="Start Timer"
					icon={{ source: Icon.Stopwatch, tintColor: Color.Green }}
					onAction={() => launchCommand({ name: "choose-client", type: LaunchType.UserInitiated }) }
				/>
			}
    </MenuBarExtra>
  );
}
