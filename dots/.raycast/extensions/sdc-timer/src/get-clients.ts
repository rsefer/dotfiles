import { Cache, getPreferenceValues, showToast, Toast } from "@raycast/api";
import { Preferences, CacheClients, Client } from "./types";
import { promises as fs, read } from "fs";
import { pipeline } from 'stream/promises';
import { parse } from 'csv-parse';
import axios from 'axios';
import { formatDuration } from "./Timer";

const cache = new Cache();

export async function getClients(forceRefresh: Boolean = false) {
	let cacheKey = 'sdc-timer-clients';
	const cachedResponse = cache.get(cacheKey);
  if (cachedResponse && !forceRefresh) {
    const parsed: CacheClients = JSON.parse(cachedResponse);
    const elapsed = Date.now() - parsed.timestamp;
    if (elapsed <= 12 * 60 * 60 * 1_000) {
			await assignClientMinutes(parsed.clients);
      return parsed.clients;
    } else {
      console.log(`Cache expired for ${cacheKey}`);
    }
  }

	await showToast({
    style: Toast.Style.Animated,
    title: "Refreshing client list",
  });

	let response = { data: [] };
	try {
		const preferences = getPreferenceValues<Preferences>();
		response = await axios.get(`${preferences.domain}${preferences.endpoint}?access_token=${preferences.accessToken}&sortBy=recentActivityDate`);
		cache.set(cacheKey, JSON.stringify({ timestamp: Date.now(), clients: response.data }));
		await showToast({
			title: "Client list updated",
			message: `${response.data.length} clients`
		});
	} catch (err) {
		await showToast({
			style: Toast.Style.Failure,
			title: "Failed to refresh client list"
		});
	}
  return response.data;
}

export async function readCSV(filePath:string) {
	let rows: Array<any> = [];
	await pipeline(
    await fs.readFile(filePath, "utf8"),
    parse({
      skip_empty_lines: true,
      columns: true
    }),
    async function* (source) {
      for await (const chunk of source) {
        rows.push(chunk);
      }
    }
  )
	return rows;
}

export async function assignClientMinutes(clients:Array<Client>) {
	const preferences = getPreferenceValues<Preferences>();
	let rawRows = await readCSV(preferences.hoursFile);
	let uniqueClientIDs = Array.from(new Set(rawRows.map(client => +client['client id'])));
	for (var clientID of uniqueClientIDs) {
		let relevantRows = rawRows.filter(client => +client['client id'] == clientID);
		let totalMinutes = relevantRows.reduce((sum, client) => sum + +client.minutes, 0);
		let foundClient = clients.find(client => client.id == clientID);
		if (foundClient) {
			foundClient.minutes = totalMinutes;
			foundClient.timeFormatted = formatDuration(foundClient.minutes * 1000 * 60, 'short');
		}
	}
	return clients;
}
