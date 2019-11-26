function FindProxyForURL(url, host) {
	if (shExpMatch(host, "(*.onion)")) {
		return "SOCKS localhost:9050";
	}

	return "DIRECT";
}
