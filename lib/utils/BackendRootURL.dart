library backend__root_url;

String serverRootURL = '';

void loadConfig(String env) {
  if (env == "PROD") {
    serverRootURL = 'https://bus.hollinger.asia';
  } else {
    serverRootURL = 'http://10.203.142.100:8778';
  }
}
