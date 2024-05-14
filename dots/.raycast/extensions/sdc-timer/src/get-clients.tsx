import { Cache, getPreferenceValues } from "@raycast/api";
import axios from 'axios';
import { Preferences, CacheClients } from "./types";

const CACHE_DURATION_IN_MS = 5 * 60 * 1_000;
const cache = new Cache();

export async function getClients() {
	let cacheKey = 'sdc-timer-clients';
	const cachedResponse = cache.get(cacheKey);
  if (cachedResponse) {
    const parsed: CacheClients = JSON.parse(cachedResponse);

    const elapsed = Date.now() - parsed.timestamp;
    console.log(`${cacheKey} cache age: ${elapsed / 1000} seconds`);

    if (elapsed <= CACHE_DURATION_IN_MS) {
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
