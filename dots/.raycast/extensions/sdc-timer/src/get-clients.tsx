import { Cache, getPreferenceValues } from "@raycast/api";
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

	const preferences = getPreferenceValues<Preferences>();
  const response = await axios.get(`${preferences.endpoint}?access_token=${preferences.accessToken}&sortBy=recentActivityDate`);
	cache.set(cacheKey, JSON.stringify({ timestamp: Date.now(), clients: response.data }));

  return response.data;
}
