import { LaunchProps, Action, ActionPanel, List, launchCommand, LaunchType, Icon, Color, getPreferenceValues, open, popToRoot } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { Preferences, Client } from "./types";
import { getClients } from "./get-clients";
import { startTimer } from "./Timer";

const preferences = getPreferenceValues<Preferences>();

export default function Command(context: LaunchProps) {
	let workingTimerType = 'running';
	if (context.launchContext?.timerType) {
		workingTimerType = context.launchContext.timerType;
	}
  let { data, isLoading } = usePromise(getClients);
	if (data) {
		for (var client of data) {
			client.accessories = [];
			if (client.minutes) {
				client.accessories.push({
					tag: {
						value: client.timeFormatted,
						color: Color.Blue
					}
				});
			}
			if (workingTimerType == 'invoice') {
				client.accessories.push({
					tag: {
						value: client.currentrate ? `$${client.currentrate}` : '----',
						color: Color.Green
					}
				});
			}
		}
	}
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
					accessories={item.accessories}
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
					<NewInvoice item={props.item} />
					</>
				)}
				{props.item.id && props.timerType == 'enter' && (
					<>
					<EnterTime item={props.item} />
					<StartTimer item={props.item} />
					<NewInvoice item={props.item} />
					</>
				)}
				{props.item.id && props.timerType == 'invoice' && (
					<>
					<NewInvoice item={props.item} />
					<EnterTime item={props.item} />
					<StartTimer item={props.item} />
					</>
				)}
				<Action.OpenInBrowser
					title="Open on Biz"
					icon={{ source: Icon.Globe }}
					shortcut={{ modifiers: ["cmd"], key: "o" }}
					url={`${preferences.domain}/clients/${props.item.id}`}
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
			shortcut={{ modifiers: ["cmd"], key: "s" }}
			onAction={() => {
				startTimer(props.item.id, props.item.name);
				popToRoot();
			}}
		/>
	);
}

function EnterTime(props: { item: Client }) {
	return (
		<Action
			title="Enter Time"
			icon={{ source: Icon.Pencil, tintColor: Color.Blue }}
			shortcut={{ modifiers: ["cmd"], key: "e" }}
			onAction={() => launchCommand({ name: "enter-timer-form", type: LaunchType.UserInitiated, context: { client: props.item } }) }
		/>
	);
}

function NewInvoice(props: { item: Client }) {
	return (
		<Action
			title="Invoice"
			icon={{ source: Icon.BankNote, tintColor: Color.Yellow }}
			shortcut={{ modifiers: ["cmd"], key: "i" }}
			onAction={() => {
				open(`${preferences.domain}/invoices/new?client_id=${props.item.id}`);
				popToRoot();
			}}
		/>
	);
}
