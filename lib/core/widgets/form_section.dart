import 'package:flutter/material.dart';
import 'package:vivocure/core/theme/app_colors.dart';

/// Titled group of form fields with the design-system section header:
/// a tinted icon chip, title and optional subtitle, then the fields.
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primaryBlueDark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: theme.textTheme.titleSmall),
                    if (subtitle != null)
                      Text(subtitle!, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

/// Lays form fields out in two columns on tablets / landscape and a single
/// column on narrow screens. Children are expected to carry their own
/// bottom spacing (the standard field bottom padding of 12).
class FormFieldGrid extends StatelessWidget {
  const FormFieldGrid({
    super.key,
    required this.children,
    this.breakpoint = 600,
  });

  final List<Widget> children;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        }
        final List<Widget> rows = <Widget>[];
        for (int i = 0; i < children.length; i += 2) {
          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: children[i]),
                const SizedBox(width: 14),
                Expanded(
                  child: i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}

/// Soft informational banner used at the top of forms ("only the name is
/// required") and for inline edit context.
class FormHintBanner extends StatelessWidget {
  const FormHintBanner({super.key, required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon ?? Icons.info_outline,
            size: 18,
            color: AppColors.primaryBlueDark,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
