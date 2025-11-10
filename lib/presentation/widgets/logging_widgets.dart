import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';

/// A Text widget that logs when it's constructed - OPTIMIZED version with const
///
/// Use this widget to demonstrate const widget reuse. When marked as const,
/// the widget instance will be reused across rebuilds, reducing memory allocation.
class OptimizedLoggingText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String context;
  final TextAlign? textAlign;

  const OptimizedLoggingText({
    super.key,
    required this.text,
    this.style,
    required this.context,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    AppLogger.logWidgetReused('OptimizedLoggingText("$text")', this.context);
    return Text(text, style: style, textAlign: textAlign);
  }
}

/// A Text widget that logs when it's constructed - NON-OPTIMIZED version
///
/// This widget does NOT use const constructor, so a new instance is created
/// on every rebuild, demonstrating poor memory usage patterns.
class NonOptimizedLoggingText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String context;
  final TextAlign? textAlign;

  // Intentionally NOT const to demonstrate non-optimized behavior
  const NonOptimizedLoggingText({
    super.key,
    required this.text,
    this.style,
    required this.context,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    AppLogger.logWidgetCreated(
      'NonOptimizedLoggingText("$text")',
      this.context,
    );
    return Text(text, style: style, textAlign: textAlign);
  }
}

/// A logging button that demonstrates widget creation patterns
class LoggingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String context;
  final bool isOptimized;

  const LoggingButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.context,
    this.isOptimized = true,
  });

  // Non-const constructor for non-optimized version
  LoggingButton.nonOptimized({
    super.key,
    required this.text,
    required this.onPressed,
    required this.context,
  }) : isOptimized = false;

  @override
  Widget build(BuildContext context) {
    if (isOptimized) {
      AppLogger.logWidgetReused('LoggingButton("$text")', this.context);
    } else {
      AppLogger.logWidgetCreated('LoggingButton("$text")', this.context);
    }

    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}

/// A logging card that demonstrates container widget patterns
class LoggingCard extends StatelessWidget {
  final Widget child;
  final String context;
  final bool isOptimized;
  final EdgeInsets? margin;
  final Color? color;

  const LoggingCard({
    super.key,
    required this.child,
    required this.context,
    this.isOptimized = true,
    this.margin,
    this.color,
  });

  // Non-const constructor for non-optimized version
  LoggingCard.nonOptimized({
    super.key,
    required this.child,
    required this.context,
    this.margin,
    this.color,
  }) : isOptimized = false;

  @override
  Widget build(BuildContext context) {
    if (isOptimized) {
      AppLogger.logWidgetReused('LoggingCard', this.context);
    } else {
      AppLogger.logWidgetCreated('LoggingCard', this.context);
    }

    return Card(margin: margin, color: color, child: child);
  }
}

/// A logging icon that demonstrates simple widget patterns
class LoggingIcon extends StatelessWidget {
  final IconData iconData;
  final Color? color;
  final double? size;
  final String context;
  final bool isOptimized;

  const LoggingIcon({
    super.key,
    required this.iconData,
    this.color,
    this.size,
    required this.context,
    this.isOptimized = true,
  });

  // Non-const constructor for non-optimized version
  LoggingIcon.nonOptimized({
    super.key,
    required this.iconData,
    this.color,
    this.size,
    required this.context,
  }) : isOptimized = false;

  @override
  Widget build(BuildContext context) {
    if (isOptimized) {
      AppLogger.logWidgetReused('LoggingIcon($iconData)', this.context);
    } else {
      AppLogger.logWidgetCreated('LoggingIcon($iconData)', this.context);
    }

    return Icon(iconData, color: color, size: size);
  }
}
