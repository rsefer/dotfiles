import { Cache, getPreferenceValues, showToast, Toast } from "@raycast/api";
import { Preferences, CacheClients } from "./types";
import axios from 'axios';

const cache = new Cache();

export async function getClients(forceRefresh: Boolean = false) {
	let cacheKey = 'sdc-timer-clients';
	const cachedResponse = cache.get(cacheKey);
  if (cachedResponse && !forceRefresh) {
    const parsed: CacheClients = JSON.parse(cachedResponse);
    const elapsed = Date.now() - parsed.timestamp;
    if (elapsed <= 12 * 60 * 60 * 1_000) {
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
		response = await axios.get(`${preferences.endpoint}?access_token=${preferences.accessToken}&sortBy=recentActivityDate`);
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
