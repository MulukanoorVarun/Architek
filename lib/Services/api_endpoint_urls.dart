class APIEndpointUrls {
  static const String baseUrl = 'http://travel.ridev.in/';
  // static const String baseUrl = 'http://192.168.80.75:8090/';
  static const String apiUrl = 'api/';
  static const String authUrl = 'auth/';

  static const String register = '${authUrl}register';
  static const String login = '${authUrl}login';
  static const String userdetail = '${authUrl}user-detail';

  static const String refreshtoken = '${authUrl}register';
  static const String getTrip = '${apiUrl}trip';
  static const String tripcount = '${apiUrl}trip-summary';
  static const String getPrevousTrip = '${apiUrl}previous-trips';
  static const String getCategory = '${apiUrl}category';

}
