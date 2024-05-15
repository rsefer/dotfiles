import { LaunchProps, Action, ActionPanel, List, launchCommand, LaunchType, Icon, Color } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { Client } from "./types";
import { getClients } from "./get-clients";
import { startTimer } from "./Timer";

export default function Command(context: LaunchProps) {
	let workingTimerType = 'running';
	if (context.launchContext?.timerType) {
		workingTimerType = context.launchContext.timerType;
	}
  const { data, isLoading } = usePromise(getClients);
  return (
    <List
      isLoading={isLoading}
			searchBarPlaceholder="Search clients..."
    >
      {data?.map((item: Client, index: number) => (
        <List.Item
					key={item.id}
					title={item.name}
					subtitle={item.contact}
					keywords={[item.contact]}
					icon={item.logo}
					accessories={[
						{ tag: { value: `ID: ${item.id}`, color: Color.Magenta } },
						{ tag: { value: item.currentrate ? `$${item.currentrate}` : '----', color: Color.Green } }
					]}
					actions={<Actions item={item} timerType={workingTimerType} />}
				/>
      ))}
    </List>
  );
}

function Actions(props: { item: Client, timerType: String }) {
  return (
    <ActionPanel title={`Client: ${props.item.name}`}>
      <ActionPanel.Section>
				{props.item.id && props.timerType == 'running' && (
					<>
					<StartTimer item={props.item} />
					<EnterTime item={props.item} />
					</>
				)}
				{props.item.id && props.timerType == 'enter' && (
					<>
					<EnterTime item={props.item} />
					<StartTimer item={props.item} />
					</>
				)}
				<Action.OpenInBrowser
					title="Open on Biz"
					icon={{ source: Icon.Globe }}
					shortcut={{ modifiers: ["cmd"], key: "o" }}
					url={`https://biz.seferdesign.com/clients/${props.item.id}`}
				/>
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

function StartTimer(props: { item: Client }) {
	return (
		<Action
			title="Start Timer"
			icon={{ source: Icon.Stopwatch, tintColor: Color.Green }}
			onAction={() => startTimer(props.item.id, props.item.name) }
		/>
	);
}

function EnterTime(props: { item: Client }) {
	return (
		<Action
			title="Enter Time"
			icon={{ source: Icon.Pencil, tintColor: Color.Blue }}
			onAction={() => launchCommand({ name: "enter-timer-form", type: LaunchType.UserInitiated, context: { client: props.item } }) }
		/>
	);
}
