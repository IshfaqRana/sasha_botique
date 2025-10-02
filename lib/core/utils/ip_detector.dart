import 'dart:io';
import 'package:dio/dio.dart';

class IPDetector {
  static final Dio _dio = Dio();

  /// Gets the device's public IP address
  static Future<String> getPublicIP() async {
    try {
      // Try multiple IP detection services for reliability
      final List<String> ipServices = [
        'https://api.ipify.org?format=json',
        'https://httpbin.org/ip',
        'https://api.my-ip.io/ip.json',
      ];

      for (String service in ipServices) {
        try {
          final response = await _dio.get(
            service,
            options: Options(
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );

          if (response.statusCode == 200) {
            final data = response.data;

            // Handle different response formats
            if (service.contains('ipify.org')) {
              return data['ip'] ?? 'unknown';
            } else if (service.contains('httpbin.org')) {
              return data['origin']?.split(',')[0]?.trim() ?? 'unknown';
            } else if (service.contains('my-ip.io')) {
              return data['ip'] ?? 'unknown';
            }
          }
        } catch (e) {
          // Try next service if current one fails
          continue;
        }
      }

      // If all services fail, return fallback
      return 'unavailable';
    } catch (e) {
      return 'unavailable';
    }
  }

  /// Gets local IP address (WiFi/mobile network)
  static Future<String> getLocalIP() async {
    try {
      final interfaces = await NetworkInterface.list();

      // Prioritize WiFi and mobile interfaces
      final preferredInterfaces = ['wlan', 'wifi', 'en0', 'eth0', 'rmnet'];

      // First try to find a preferred interface
      for (String preferred in preferredInterfaces) {
        for (NetworkInterface interface in interfaces) {
          if (interface.name.toLowerCase().contains(preferred)) {
            for (InternetAddress addr in interface.addresses) {
              if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
                return addr.address;
              }
            }
          }
        }
      }

      // If no preferred interface found, get any non-loopback IPv4 address
      for (NetworkInterface interface in interfaces) {
        for (InternetAddress addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }

      return 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  /// Gets the best available IP address (prefers public, falls back to local)
  static Future<String> getBestAvailableIP() async {
    try {
      // First try to get public IP with timeout
      final publicIP = await getPublicIP().timeout(
        const Duration(seconds: 3),
        onTimeout: () => 'timeout',
      );

      // If public IP is available, return it
      if (publicIP != 'unavailable' && publicIP != 'unknown' && publicIP != 'timeout') {
        return publicIP;
      }

      // Fall back to local IP
      final localIP = await getLocalIP();
      return localIP;
    } catch (e) {
      print('IP Detection Error: $e');
      return 'unknown';
    }
  }

  /// Gets IP address quickly with a short timeout - for login use
  static Future<String> getQuickIP() async {
    try {
      // Try to get public IP with a very short timeout
      final result = await Future.any([
        getPublicIP(),
        Future.delayed(const Duration(milliseconds: 1000), () => 'timeout'),
      ]);

      if (result != 'unavailable' && result != 'unknown' && result != 'timeout') {
        return result;
      }

      // If public IP fails, immediately try local IP
      final localIP = await getLocalIP();
      if (localIP != 'unknown') {
        return localIP;
      }

      // As last resort, return a default local IP
      return '192.168.1.100'; // Default fallback IP
    } catch (e) {
      // If everything fails, return a default local IP
      return '192.168.1.100';
    }
  }
}