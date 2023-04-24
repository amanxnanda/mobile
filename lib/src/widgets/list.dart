import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/styles/styles.dart';

/// A platform agnostic list section.
///
/// Use to show a limited number of items.
class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.children,
    this.header,
    this.onHeaderTap,
    this.margin,
    this.hasLeading = false,
    this.showDivider = false,
    this.showDividerBetweenTiles = false,
    this.dense = false,
    this.cupertinoAdditionalDividerMargin,
  });

  /// Usually a list of [PlatformListTile] widgets
  final List<Widget> children;

  /// Whether the iOS tiles have a leading widget.
  final bool hasLeading;

  /// Show a header above the children rows. Typically a [Text] widget.
  final Widget? header;
  final GestureTapCallback? onHeaderTap;

  final EdgeInsetsGeometry? margin;

  /// Only on android.
  final bool showDividerBetweenTiles;

  /// Show a [Divider] at the bottom of the section. Only on android.
  final bool showDivider;

  /// Use it to set [ListTileTheme.dense] property. Only on Android.
  final bool dense;

  /// See [CupertinoListSection.additionalDividerMargin].
  final double? cupertinoAdditionalDividerMargin;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Padding(
          padding: margin ?? Styles.sectionBottomPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null)
                ListTile(
                  dense: true,
                  title: DefaultTextStyle.merge(
                    style: Styles.sectionTitle,
                    child: header!,
                  ),
                  trailing: (onHeaderTap != null)
                      ? GestureDetector(
                          onTap: onHeaderTap,
                          child: const Icon(Icons.more_horiz),
                        )
                      : null,
                ),
              if (showDividerBetweenTiles)
                ...ListTile.divideTiles(
                  context: context,
                  tiles: children,
                )
              else
                ...children,
              if (showDivider)
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Divider(thickness: 0),
                ),
            ],
          ),
        );
      case TargetPlatform.iOS:
        return Padding(
          padding: margin ?? Styles.bodySectionPadding,
          child: Column(
            children: [
              if (header != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .merge(Styles.sectionTitle),
                        child: header!,
                      ),
                      if (onHeaderTap != null)
                        GestureDetector(
                          onTap: onHeaderTap,
                          child: const Icon(CupertinoIcons.ellipsis),
                        ),
                    ],
                  ),
                ),
              CupertinoListSection.insetGrouped(
                margin: EdgeInsets.zero,
                hasLeading: hasLeading,
                additionalDividerMargin: cupertinoAdditionalDividerMargin,
                children: children,
              ),
            ],
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// Platform agnostic list tile widget.
///
/// Will use [ListTile] on android and [CupertinoListTile] on iOS.
class PlatformListTile extends StatelessWidget {
  const PlatformListTile({
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.additionalInfo,
    this.dense,
    this.onTap,
    this.selected = false,
    this.isThreeLine = false,
    this.visualDensity,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  /// only on iOS
  final Widget? additionalInfo;

  // only on android
  final bool selected;

  // only on android
  final bool? dense;

  // only on android
  final bool isThreeLine;

  /// Only on android.
  final VisualDensity? visualDensity;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle != null
              ? DefaultTextStyle.merge(
                  child: subtitle!,
                  style: TextStyle(
                    color: textShade(context, Styles.subtitleOpacity),
                  ),
                )
              : null,
          trailing: trailing,
          dense: dense,
          visualDensity: visualDensity,
          onTap: onTap,
          selected: selected,
          isThreeLine: isThreeLine,
        );
      case TargetPlatform.iOS:
        return IconTheme(
          data: CupertinoIconThemeData(
            color: CupertinoColors.systemGrey.resolveFrom(context),
          ),
          child: CupertinoListTile.notched(
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            additionalInfo: additionalInfo,
            onTap: onTap,
          ),
        );

      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// A list tile that shows game info.
class GameListTile extends StatelessWidget {
  const GameListTile({
    this.icon,
    required this.playerTitle,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData? icon;
  final Widget playerTitle;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: onTap,
      leading: icon != null
          ? Icon(
              icon,
              size: defaultTargetPlatform == TargetPlatform.iOS ? 26.0 : 36.0,
            )
          : null,
      title: playerTitle,
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              child: subtitle!,
              style: TextStyle(
                color: textShade(context, Styles.subtitleOpacity),
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}
