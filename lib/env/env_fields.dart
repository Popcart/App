/// DevEnv, QAEnv and ProdEnv must implement all these values
abstract interface class EnvFields {
  abstract final String authServiceBaseUrl;
  abstract final String livestreamServiceBaseUrl;
  // abstract final String sellerDashboardUrl;
  abstract final String agoraAppId;
}
