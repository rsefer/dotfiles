export type Preferences = {
	domain: string;
	endpoint: string;
	accessToken: string;
	hoursFile: string;
};

export type Client = {
	id: number;
	name: string;
	contact: string;
	logo: string;
	currentrate: number;
	site_url: string;
	minutes: number;
	timeFormatted: string;
	accessories: Array<any>;
};

export type CacheClients = {
	timestamp: number;
	clients: Array<Client>;
};

export type Timer = {
	id: number;
	name: string | null;
	start: number;
	end: number | null;
	diff: number | null;
	diffMinutes: number | null;
	diffFormatted: {
		short: string | null;
		long: string | null;
	};
};
