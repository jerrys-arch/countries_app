import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/country_summary.dart';

class CountryTile extends StatelessWidget {
  final CountrySummary country;
  final Widget trailing;
  final VoidCallback onTap;
  final String subtitle;

  const CountryTile({
    super.key,
    required this.country,
    required this.trailing,
    required this.onTap,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isSearchMode = subtitle.isEmpty;

    Widget buildFlag() {
      return Hero(
        tag: country.cca2, 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: country.flagPng,
            fit: BoxFit.cover,
            memCacheWidth: 200,
            placeholder: (context, url) => Container(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            ),
            errorWidget: (context, url, error) => const Icon(Icons.flag),
          ),
        ),
      );
    }

    if (isSearchMode) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 75,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: buildFlag(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  country.commonName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing is! SizedBox) const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      );
    }

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 75,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: buildFlag(),
      ),
      title: Text(
        country.commonName,
        style: const TextStyle(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
    );
  }
}