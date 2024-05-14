import { LaunchProps, Action, ActionPanel, List, launchCommand, LaunchType, Icon, Color } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { Client } from "./types";
import { getClients } from "./get-clients";
import { startTimer } from "./Timers";

export default function Command(context: LaunchProps) {
	let workingTimerType = 'running';
	if (context.launchContext?.timerType) {
		workingTimerType = context.launchContext.timerType;
	}
  const { data, isLoading } = usePromise(getClients);
  return (
    <List
      isLoading={isLoading}
    >
      {data?.map((item: Client, index: number) => (
        <List.Item
					key={item.id}
					title={item.name}
					subtitle={item.contact}
					icon={item.logo}
					actions={<Actions item={item} timerType={workingTimerType} />}
				/>
      ))}
    </List>
  );
}

function Actions(props: { item: Client, timerType: String }) {
  return (
    <ActionPanel title={props.item.name}>
      <ActionPanel.Section>
				{props.item.id && props.timerType == 'running' && (
					<Action
						title="Start Timer"
						icon={{ source: Icon.Stopwatch, tintColor: Color.Green }}
						onAction={() => startTimer(props.item.id, props.item.name) }
					/>
				)}
				{props.item.id && props.timerType == 'enter' && (
					<Action
						title="Enter Time"
						icon={{ source: Icon.Stopwatch, tintColor: Color.Green }}
						onAction={() => console.log('entering time') }
					/>
				)}
      </ActionPanel.Section>
			<ActionPanel.Section>
				<Action
					title="Refresh Clients List"
					icon={{ source: Icon.RotateClockwise }}
					shortcut={{ modifiers: ["cmd"], key: "r" }}
					onAction={() => getClients(true) }
				/>
      </ActionPanel.Section>
    </ActionPanel>
  );
}
