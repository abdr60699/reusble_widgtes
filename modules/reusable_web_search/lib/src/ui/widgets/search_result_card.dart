import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import '../../utils/url_utils.dart';
import '../../constants/constants.dart';

/// Widget to display a single search result
class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showFavicon;
  final bool showThumbnail;
  final bool showDomain;
  final bool showDate;

  const SearchResultCard({
    super.key,
    required this.result,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.showFavicon = true,
    this.showThumbnail = true,
    this.showDomain = true,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: SearchConstants.resultCardPadding,
        vertical: SearchConstants.resultCardSpacing / 2,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(SearchConstants.resultCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and domain row
              Row(
                children: [
                  if (showFavicon) ...[
                    _buildFavicon(),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showDomain) ...[
                          const SizedBox(height: 4),
                          Text(
                            result.domain,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green[700],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showThumbnail && result.imageUrl != null)
                    _buildThumbnail(),
                ],
              ),
              const SizedBox(height: 8),

              // Snippet
              Text(
                result.snippet,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Metadata row
              if (showDate && result.publishedDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  _formatDate(result.publishedDate!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],

              // Actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? Colors.amber : null,
                    ),
                    onPressed: onFavorite,
                    tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareResult(),
                    tooltip: 'Share',
                  ),
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () => _copyUrl(context),
                    tooltip: 'Copy URL',
                  ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => UrlUtils.launchExternalUrl(result.url),
                    tooltip: 'Open in browser',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavicon() {
    final faviconUrl = UrlUtils.getFaviconUrl(result.url);
    return CachedNetworkImage(
      imageUrl: faviconUrl,
      width: SearchConstants.faviconSize,
      height: SearchConstants.faviconSize,
      placeholder: (context, url) => const SizedBox(
        width: SearchConstants.faviconSize,
        height: SearchConstants.faviconSize,
        child: Icon(Icons.language, size: 16),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.language,
        size: SearchConstants.faviconSize,
      ),
    );
  }

  Widget _buildThumbnail() {
    if (result.imageUrl == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: result.imageUrl!,
        width: SearchConstants.thumbnailSize,
        height: SearchConstants.thumbnailSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: SearchConstants.thumbnailSize,
          height: SearchConstants.thumbnailSize,
          color: Colors.grey[200],
          child: const Icon(Icons.image),
        ),
        errorWidget: (context, url, error) => Container(
          width: SearchConstants.thumbnailSize,
          height: SearchConstants.thumbnailSize,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  void _shareResult() {
    Share.share(
      '${result.title}\n${result.url}',
      subject: result.title,
    );
  }

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: result.url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL copied to clipboard')),
      );
    }
  }
}
