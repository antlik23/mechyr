import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchEmail(
    BuildContext context,
    String email,
  ) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    try {
      final bool canLaunch = await canLaunchUrl(emailUri);
      if (!context.mounted) return;

      if (canLaunch) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError(context, 'Nelze otevřít emailového klienta');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Chyba při otevírání emailu: ${e.toString()}');
    }
  }

  /// Launch phone dialer with pre-filled phone number
  static Future<void> launchPhone(
    BuildContext context,
    String phone,
  ) async {
    // Clean phone number (remove spaces, dashes, etc.)
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: cleanPhone,
    );

    try {
      final bool canLaunch = await canLaunchUrl(phoneUri);
      if (!context.mounted) return;

      if (canLaunch) {
        await launchUrl(
          phoneUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError(context, 'Nelze zahájit telefonní hovor');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Chyba při volání: ${e.toString()}');
    }
  }

  /// Launch website in external browser
  static Future<void> launchWebsite(
    BuildContext context,
    String url,
  ) async {
    String finalUrl = url.trim();

    // Add https:// if no protocol is specified
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }

    final Uri webUri = Uri.parse(finalUrl);

    try {
      final bool canLaunch = await canLaunchUrl(webUri);
      if (!context.mounted) return;

      if (canLaunch) {
        await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError(context, 'Nelze otevřít webovou stránku');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Chyba při otevírání webu: ${e.toString()}');
    }
  }

  /// Launch Google Maps with coordinates or address
  static Future<void> launchMaps(
    BuildContext context, {
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    Uri mapsUri;

    try {
      if (latitude != null && longitude != null) {
        // Use coordinates for more precise location
        mapsUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        );
      } else if (address != null && address.isNotEmpty) {
        // Use address as fallback
        final encodedAddress = Uri.encodeComponent(address);
        mapsUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
        );
      } else {
        if (!context.mounted) return;
        _showError(context, 'Nelze otevřít mapy - chybí adresa');
        return;
      }

      final bool canLaunch = await canLaunchUrl(mapsUri);
      if (!context.mounted) return;

      if (canLaunch) {
        await launchUrl(
          mapsUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError(context, 'Nelze otevřít mapy');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Chyba při otevírání map: ${e.toString()}');
    }
  }

  /// Show error message using SnackBar
  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
