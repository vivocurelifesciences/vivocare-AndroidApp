import 'package:flutter/material.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_logo.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/features/home/model/home_menu_item.dart';

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({
    super.key,
    required this.items,
    required this.width,
    required this.onItemTap,
    this.compact = false,
  });

  final List<HomeMenuItem> items;
  final double width;
  final ValueChanged<int> onItemTap;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
        child: AppPanel(
          padding: EdgeInsets.fromLTRB(
            compact ? 10 : 14,
            14,
            compact ? 10 : 14,
            14,
          ),
          borderRadius: 28,
          backgroundColor: Colors.white.withValues(alpha: 0.88),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: compact ? 88 : 128,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderStrong),
                ),
                child: Center(
                  child: AppLogo(size: compact ? 56 : 72, showTagline: true),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    final HomeMenuItem item = items[index];
                    final bool isActive = item.isActive;
                    final Color iconColor = isActive
                        ? Colors.white
                        : AppColors.textSecondary;
                    final Color labelColor = isActive
                        ? Colors.white
                        : AppColors.textPrimary;

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => onItemTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 10 : 12,
                          vertical: compact ? 12 : 13,
                        ),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? const LinearGradient(
                                  colors: <Color>[
                                    AppColors.primaryBlueDark,
                                    AppColors.primaryBlue,
                                  ],
                                )
                              : null,
                          color: isActive
                              ? null
                              : Colors.white.withValues(alpha: 0.58),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isActive
                                ? const Color(0x00000000)
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: compact
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              width: compact ? 34 : 36,
                              height: compact ? 34 : 36,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white.withValues(alpha: 0.14)
                                    : const Color(0xFFF4F8FC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item.icon,
                                size: compact ? 18 : 20,
                                color: iconColor,
                              ),
                            ),
                            if (!compact) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: 13,
                                        color: labelColor,
                                        fontWeight: isActive
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
