/// DevEnv, QAEnv and ProdEnv must implement all these values
abstract interface class EnvFields {
  abstract final String authServiceBaseUrl;
  abstract final String livestreamServiceBaseUrl;
  abstract final String introGifUrl;
  abstract final String sellerDashboardUrl;
  abstract final String agoraAppId;
  abstract final String imglyLicenseKey;
  abstract final String walletServiceBaseUrl;
}
