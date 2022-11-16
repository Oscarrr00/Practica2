import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IconsLink extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final String link;
  final String tooltip;
  IconsLink({
    Key? key,
    this.icon,
    this.image,
    required this.link,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _launchUrl,
      iconSize: 50,
      icon: (icon != null)
          ? Icon(icon)
          : Image.asset("${image}", color: Colors.white),
      tooltip: tooltip,
    );
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse(link);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
