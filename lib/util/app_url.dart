class AppUrl {
  static const String liveBaseURL = "jeschor.net";
  /*static const String localBaseURL = "http://10.0.2.2:4000/api/v1";*/

  static const String baseURL = liveBaseURL;
  static const String login = "/app/public/auth/login";
  static const String register = "/app/public/auth/register";
  static const String user = "/app/public/auth/me";
  static const String refresh = "/app/public/auth/refresh";

  static const String getGroup = "/app/public/api/group/";
  static const String joinGroup = "/app/public/api/group/join";
  static const String getGroups = "/app/public/api/group";

  static const String getReceipts = "/app/public/api/receipt";
  static const String createReceipt = "/app/public/api/receipt";
  static const String uploadReceiptImages = "/app/public/api/receipt/image";
  static const String getSteps = "/app/public/api/receipt/steps";
  static const String getIngredients = "/app/public/api/receipt/ingredient";
  static const String getUnits = "/app/public/api/receipt/unit";
  static const String getAllUnits = "/app/public/api/unit";
  static const String getAllTags = "/app/public/api/tag";
  /*static const String forgotPassword = baseURL + "/forgot-password";*/
}