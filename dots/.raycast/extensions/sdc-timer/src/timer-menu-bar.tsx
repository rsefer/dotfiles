import { Icon, Color, MenuBarExtra, launchCommand, LaunchType } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { runningTimer } from "./Timers";
import moment from 'moment';

export default function Command() {
	const { data: currentTimer, isLoading, revalidate } = usePromise(runningTimer, []);
  return (
    <MenuBarExtra
			isLoading={isLoading}
			icon={{ source: Icon.Stopwatch, tintColor: currentTimer ? Color.Green : null }}
			title={currentTimer ? `${currentTimer.name?.substring(0, 3)} ${moment().diff(moment(currentTimer.start), 'minutes')}m` : undefined}
			tooltip="Timer"
		>
			{ currentTimer ?
				<MenuBarExtra.Item
					title="Stop"
					onAction={() => launchCommand({ name: "stop-timer", type: LaunchType.UserInitiated }) }
				/>
			: <MenuBarExtra.Item
					title="Start"
					onAction={() => launchCommand({ name: "choose-client", type: LaunchType.UserInitiated }) }
				/>
			}
    </MenuBarExtra>
  );
}
