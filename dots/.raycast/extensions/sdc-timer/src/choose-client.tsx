import { Action, ActionPanel, List, launchCommand, LaunchType } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { Client } from "./types";
import { getClients } from "./get-clients";

export default function Command() {
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
					actions={<Actions item={item} />}
				/>
      ))}
    </List>
  );
}

function Actions(props: { item: Client }) {
  return (
    <ActionPanel title={props.item.name}>
      <ActionPanel.Section>
				{props.item.id && (
					<Action title="Start Timer" onAction={() => launchCommand({
						name: "start-timer",
						type: LaunchType.UserInitiated,
						arguments: {
							id: props.item.id.toString(),
							name: props.item.name
						}
					}) } />
				)}
      </ActionPanel.Section>
    </ActionPanel>
  );
}
