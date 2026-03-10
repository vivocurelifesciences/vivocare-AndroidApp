import 'package:flutter/material.dart';
import 'package:vivocare/core/theme/app_colors.dart';
import 'package:vivocare/core/widgets/app_logo.dart';
import 'package:vivocare/features/home/model/home_menu_item.dart';

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
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 10 : 16,
              14,
              compact ? 10 : 16,
              14,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppLogo(size: compact ? 38 : 48, showTagline: !compact),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (BuildContext context, int index) {
                final HomeMenuItem item = items[index];

                final Color iconColor = item.isActive
                    ? AppColors.primaryBlueDark
                    : AppColors.textSecondary;
                final Color labelColor = item.isActive
                    ? AppColors.primaryBlueDark
                    : AppColors.textSecondary;

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onItemTap(index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: item.isActive
                          ? const Color(0xFFEAF3FF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 10 : 12,
                        vertical: compact ? 10 : 11,
                      ),
                      child: Row(
                        mainAxisAlignment: compact
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            item.icon,
                            size: compact ? 18 : 20,
                            color: iconColor,
                          ),
                          if (!compact) ...[
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                item.label,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 13,
                                      color: labelColor,
                                      fontWeight: item.isActive
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
