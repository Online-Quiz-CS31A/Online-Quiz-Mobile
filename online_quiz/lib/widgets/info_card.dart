import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? valueColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Widget? trailing;
  final bool showBorder;
  final Color? borderColor;
  final double? iconSize;
  final double? titleFontSize;
  final double? valueFontSize;
  final FontWeight? titleFontWeight;
  final FontWeight? valueFontWeight;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.backgroundColor,
    this.titleColor,
    this.valueColor,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.trailing,
    this.showBorder = false,
    this.borderColor,
    this.iconSize,
    this.titleFontSize,
    this.valueFontSize,
    this.titleFontWeight,
    this.valueFontWeight,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? Colors.blue.shade600;
    final defaultBackgroundColor = backgroundColor ?? Colors.white;
    final defaultTitleColor = titleColor ?? Colors.grey.shade600;
    final defaultValueColor = valueColor ?? Colors.black87;
    final defaultPadding = padding ?? const EdgeInsets.all(20);
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final defaultBoxShadow = boxShadow ?? [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];

    Widget cardContent = Container(
      width: double.infinity,
      padding: defaultPadding,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: defaultBorderRadius,
        boxShadow: defaultBoxShadow,
        border: showBorder
            ? Border.all(
                color: borderColor ?? Colors.grey.shade300,
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: defaultIconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: defaultIconColor,
              size: iconSize ?? 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize ?? 14,
                    color: defaultTitleColor,
                    fontWeight: titleFontWeight ?? FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize ?? 16,
                    color: defaultValueColor,
                    fontWeight: valueFontWeight ?? FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

// Preset configurations for common use cases
class InfoCardPresets {
  // Profile information card
  static InfoCard profile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      iconColor: Colors.blue.shade600,
      backgroundColor: Colors.white,
    );
  }

  // Compact info card for smaller spaces
  static InfoCard compact({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      iconColor: color ?? Colors.blue.shade600,
      padding: const EdgeInsets.all(16),
      iconSize: 20,
      titleFontSize: 12,
      valueFontSize: 14,
    );
  }

  // Success/completion info card
  static InfoCard success({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      iconColor: Colors.green.shade600,
      backgroundColor: Colors.green.shade50,
      showBorder: true,
      borderColor: Colors.green.shade200,
    );
  }

  // Warning/pending info card
  static InfoCard warning({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      iconColor: Colors.orange.shade600,
      backgroundColor: Colors.orange.shade50,
      showBorder: true,
      borderColor: Colors.orange.shade200,
    );
  }

  // Error/overdue info card
  static InfoCard error({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      iconColor: Colors.red.shade600,
      backgroundColor: Colors.red.shade50,
      showBorder: true,
      borderColor: Colors.red.shade200,
    );
  }

  // Info card with trailing widget (like arrow or button)
  static InfoCard withTrailing({
    required IconData icon,
    required String title,
    required String value,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      trailing: trailing,
      onTap: onTap,
      iconColor: Colors.blue.shade600,
    );
  }

  // Minimal info card without shadow
  static InfoCard minimal({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
    VoidCallback? onTap,
  }) {
    return InfoCard(
      icon: icon,
      title: title,
      value: value,
      onTap: onTap,
      iconColor: color ?? Colors.blue.shade600,
      backgroundColor: Colors.grey.shade50,
      boxShadow: [],
      showBorder: true,
      borderColor: Colors.grey.shade200,
    );
  }
}