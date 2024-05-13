import { runAppleScript } from "@raycast/utils";

export default async function main() {
  await runAppleScript(`tell application "System Events" to tell process "Spotify" to click menu item "Seek Forward" of menu 1 of menu bar item "Playback" of menu bar 1`);
}
