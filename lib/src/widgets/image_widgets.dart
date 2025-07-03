import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';

/// Image widgets implementation for JSON UI Builder.
class ImageWidgets {
  /// Registers all image widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('Image', _buildImage, [
      'src',
      'width',
      'height',
      'fit',
      'alignment',
    ]);

    registry.registerWidget('NetworkImage', _buildNetworkImage, [
      'src',
      'width',
      'height',
      'fit',
      'alignment',
    ]);

    registry.registerWidget('AssetImage', _buildAssetImage, [
      'src',
      'width',
      'height',
      'fit',
      'alignment',
    ]);

    registry.registerWidget('CircleAvatar', _buildCircleAvatar, [
      'radius',
      'backgroundImage',
      'backgroundColor',
      'child',
    ]);

    registry.registerWidget('Icon', _buildIcon, ['icon', 'size', 'color']);
  }

  static Widget _buildImage(WidgetConfig config) {
    final src = PropertyParser.parseRequiredString(config, 'src');
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final fit = _parseBoxFit(config.getProperty<String>('fit'));
    final alignment =
        PropertyParser.parseAlignment(config, 'alignment') ?? Alignment.center;

    // Determine image type based on src
    if (src.startsWith('http://') || src.startsWith('https://')) {
      return Image.network(
        src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage(width, height);
        },
      );
    } else if (src.startsWith('assets/')) {
      return Image.asset(
        src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage(width, height);
        },
      );
    } else {
      // Try as network image by default
      return Image.network(
        src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage(width, height);
        },
      );
    }
  }

  static Widget _buildNetworkImage(WidgetConfig config) {
    final src = PropertyParser.parseRequiredString(config, 'src');
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final fit = _parseBoxFit(config.getProperty<String>('fit'));
    final alignment =
        PropertyParser.parseAlignment(config, 'alignment') ?? Alignment.center;

    return Image.network(
      src,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorImage(width, height);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  static Widget _buildAssetImage(WidgetConfig config) {
    final src = PropertyParser.parseRequiredString(config, 'src');
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final fit = _parseBoxFit(config.getProperty<String>('fit'));
    final alignment =
        PropertyParser.parseAlignment(config, 'alignment') ?? Alignment.center;

    return Image.asset(
      src,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorImage(width, height);
      },
    );
  }

  static Widget _buildCircleAvatar(WidgetConfig config) {
    final radius = PropertyParser.parseDouble(config, 'radius') ?? 20.0;
    final backgroundColor = PropertyParser.parseColor(
      config,
      'backgroundColor',
    );
    final backgroundImageSrc = PropertyParser.parseString(
      config,
      'backgroundImage',
    );

    ImageProvider? backgroundImage;
    if (backgroundImageSrc != null) {
      if (backgroundImageSrc.startsWith('http://') ||
          backgroundImageSrc.startsWith('https://')) {
        backgroundImage = NetworkImage(backgroundImageSrc);
      } else if (backgroundImageSrc.startsWith('assets/')) {
        backgroundImage = AssetImage(backgroundImageSrc);
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      child: backgroundImage == null ? const Icon(Icons.person) : null,
    );
  }

  static Widget _buildIcon(WidgetConfig config) {
    final iconName = PropertyParser.parseRequiredString(config, 'icon');
    final size = PropertyParser.parseDouble(config, 'size') ?? 24.0;
    final color = PropertyParser.parseColor(config, 'color');

    final iconData = _parseIcon(iconName);

    return Icon(iconData, size: size, color: color);
  }

  // Helper methods

  static BoxFit? _parseBoxFit(String? value) {
    if (value == null) return null;

    switch (value.toLowerCase()) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitwidth':
        return BoxFit.fitWidth;
      case 'fitheight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaledown':
        return BoxFit.scaleDown;
      default:
        return null;
    }
  }

  static Widget _buildErrorImage(double? width, double? height) {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey),
      ),
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  static IconData _parseIcon(String iconName) {
    // Comprehensive icon mapping
    switch (iconName.toLowerCase()) {
      // Navigation
      case 'home':
        return Icons.home;
      case 'menu':
        return Icons.menu;
      case 'arrow_back':
        return Icons.arrow_back;
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'close':
        return Icons.close;

      // Actions
      case 'add':
        return Icons.add;
      case 'remove':
        return Icons.remove;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'save':
        return Icons.save;
      case 'search':
        return Icons.search;
      case 'refresh':
        return Icons.refresh;
      case 'settings':
        return Icons.settings;

      // Communication
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'message':
        return Icons.message;
      case 'chat':
        return Icons.chat;

      // Media
      case 'play_arrow':
        return Icons.play_arrow;
      case 'pause':
        return Icons.pause;
      case 'stop':
        return Icons.stop;
      case 'skip_next':
        return Icons.skip_next;
      case 'skip_previous':
        return Icons.skip_previous;
      case 'volume_up':
        return Icons.volume_up;
      case 'volume_down':
        return Icons.volume_down;
      case 'volume_off':
        return Icons.volume_off;

      // Social
      case 'person':
        return Icons.person;
      case 'people':
        return Icons.people;
      case 'favorite':
        return Icons.favorite;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'share':
        return Icons.share;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'thumb_down':
        return Icons.thumb_down;

      // Content
      case 'star':
        return Icons.star;
      case 'star_border':
        return Icons.star_border;
      case 'bookmark':
        return Icons.bookmark;
      case 'bookmark_border':
        return Icons.bookmark_border;
      case 'comment':
        return Icons.comment;
      case 'description':
        return Icons.description;

      // Status
      case 'check':
        return Icons.check;
      case 'cancel':
        return Icons.cancel;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
        return Icons.info;
      case 'help':
        return Icons.help;

      // File operations
      case 'folder':
        return Icons.folder;
      case 'file_copy':
        return Icons.file_copy;
      case 'download':
        return Icons.download;
      case 'upload':
        return Icons.upload;
      case 'attach_file':
        return Icons.attach_file;

      // Visibility
      case 'visibility':
        return Icons.visibility;
      case 'visibility_off':
        return Icons.visibility_off;

      // Security
      case 'lock':
        return Icons.lock;
      case 'lock_open':
        return Icons.lock_open;
      case 'security':
        return Icons.security;

      // Location
      case 'location_on':
        return Icons.location_on;
      case 'place':
        return Icons.place;
      case 'map':
        return Icons.map;

      // Time
      case 'access_time':
        return Icons.access_time;
      case 'schedule':
        return Icons.schedule;
      case 'today':
        return Icons.today;
      case 'event':
        return Icons.event;

      // Miscellaneous
      case 'language':
        return Icons.language;
      case 'translate':
        return Icons.translate;
      case 'color_lens':
        return Icons.color_lens;
      case 'palette':
        return Icons.palette;
      case 'camera':
        return Icons.camera_alt;
      case 'photo':
        return Icons.photo;
      case 'image':
        return Icons.image;
      case 'broken_image':
        return Icons.broken_image;

      default:
        return Icons.help_outline; // Default fallback icon
    }
  }
}
