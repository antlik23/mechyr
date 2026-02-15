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

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nelze otevřít emailového klienta'),
          ),
        );
      }
    }
  }

  static Future<void> launchPhone(
    BuildContext context,
    String phone,
  ) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nelze zahájit telefonní hovor'),
          ),
        );
      }
    }
  }

  static Future<void> launchWebsite(
    BuildContext context,
    String url,
  ) async {
    String finalUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      finalUrl = 'https://$url';
    }

    final Uri webUri = Uri.parse(finalUrl);

    if (await canLaunchUrl(webUri)) {
      await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nelze otevřít webovou stránku'),
          ),
        );
      }
    }
  }

  static Future<void> launchMaps(
    BuildContext context, {
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    Uri mapsUri;

    if (latitude != null && longitude != null) {
      mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
    } else if (address != null && address.isNotEmpty) {
      final encodedAddress = Uri.encodeComponent(address);
      mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nelze otevřít mapy - chybí adresa'),
          ),
        );
      }
      return;
    }

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(
        mapsUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nelze otevřít mapy'),
          ),
        );
      }
    }
  }
}
