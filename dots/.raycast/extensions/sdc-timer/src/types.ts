export type Preferences = {
  endpoint: string;
  accessToken: string;
	hoursFile: string;
}

export type Client = {
	id: number;
	name: string;
	contact: string;
	logo: string;
}

export type CacheClients = {
  timestamp: number;
  clients: Array<Client>;
};
