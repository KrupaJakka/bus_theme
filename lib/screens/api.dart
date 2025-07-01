class Api {
  static const String baseUrl = 'https://your-api-gateway-url.com';

  // Driver APIs
  static const String startRideUrl = '$baseUrl/startRide';
  static const String stopRideUrl = '$baseUrl/stopRide';
  static const String uploadPhotoUrl = '$baseUrl/uploadPhoto';

  // Student APIs
  static const String nearbyBusesUrl = '$baseUrl/nearbyBuses';

  // Admin APIs
  static const String getAllBusesUrl = '$baseUrl/allBuses';

  // Parent APIs
  static const String getStudentLocationUrl = '$baseUrl/studentLocation';
  static const String getDriverInfoUrl = '$baseUrl/driverInfo';

  // You can expand with headers, authentication tokens, etc.
}
