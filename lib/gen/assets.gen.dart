/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/WorkSans-Italic-VariableFont_wght.ttf
  String get workSansItalicVariableFontWght =>
      'assets/fonts/WorkSans-Italic-VariableFont_wght.ttf';

  /// File path: assets/fonts/WorkSans-VariableFont_wght.ttf
  String get workSansVariableFontWght =>
      'assets/fonts/WorkSans-VariableFont_wght.ttf';

  /// List of all assets
  List<String> get values =>
      [workSansItalicVariableFontWght, workSansVariableFontWght];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/Search.svg');

  /// File path: assets/icons/auctions_selected.svg
  SvgGenImage get auctionsSelected =>
      const SvgGenImage('assets/icons/auctions_selected.svg');

  /// File path: assets/icons/auctions_unselected.svg
  SvgGenImage get auctionsUnselected =>
      const SvgGenImage('assets/icons/auctions_unselected.svg');

  /// File path: assets/icons/checkicon.svg
  SvgGenImage get checkicon => const SvgGenImage('assets/icons/checkicon.svg');

  /// File path: assets/icons/error_icon.svg
  SvgGenImage get errorIcon => const SvgGenImage('assets/icons/error_icon.svg');

  /// File path: assets/icons/live_selected.svg
  SvgGenImage get liveSelected =>
      const SvgGenImage('assets/icons/live_selected.svg');

  /// File path: assets/icons/live_unselected.svg
  SvgGenImage get liveUnselected =>
      const SvgGenImage('assets/icons/live_unselected.svg');

  /// File path: assets/icons/profile_selected.svg
  SvgGenImage get profileSelected =>
      const SvgGenImage('assets/icons/profile_selected.svg');

  /// File path: assets/icons/profile_unselected.svg
  SvgGenImage get profileUnselected =>
      const SvgGenImage('assets/icons/profile_unselected.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        search,
        auctionsSelected,
        auctionsUnselected,
        checkicon,
        errorIcon,
        liveSelected,
        liveUnselected,
        profileSelected,
        profileUnselected
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/auth_bg.png
  AssetGenImage get authBg => const AssetGenImage('assets/images/auth_bg.png');

  /// File path: assets/images/buyer.png
  AssetGenImage get buyer => const AssetGenImage('assets/images/buyer.png');

  /// File path: assets/images/seller.png
  AssetGenImage get seller => const AssetGenImage('assets/images/seller.png');

  /// File path: assets/images/splash_image.png
  AssetGenImage get splashImage =>
      const AssetGenImage('assets/images/splash_image.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [appLogo, authBg, buyer, seller, splashImage];
}

class AppAssets {
  const AppAssets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
