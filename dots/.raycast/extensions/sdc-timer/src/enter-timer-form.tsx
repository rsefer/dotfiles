import { LaunchProps, Form, popToRoot, ActionPanel, Action, getPreferenceValues } from "@raycast/api";
import { logTime } from "./Timer";

const preferences = getPreferenceValues<Preferences>();

export default function Command(context: LaunchProps) {
	let client = context.launchContext?.client;
  return (
		<Form
			searchBarAccessory={
				<Form.LinkAccessory
					target={preferences.domain}
					text="Go to Biz"
				/>
			}
			actions={
				<ActionPanel>
					<Action.SubmitForm
						onSubmit={(values) => {
							logTime(client.id, client.name, +values.minutes);
							popToRoot();
						}}
					/>
				</ActionPanel>
			}
		>
			<Form.Description
				title="Client"
				text={ client.name }
			/>
			<Form.TextField
				id="minutes"
				title="Minutes"
				placeholder="60"
				autoFocus={true}
			/>
		</Form>
  );
}
