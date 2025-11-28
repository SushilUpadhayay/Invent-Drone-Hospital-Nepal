import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> inventoryItem;
  final VoidCallback? onEdit;
  final VoidCallback? onViewHistory;
  final VoidCallback? onMarkAsUsed;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onExport;
  final VoidCallback? onSetAlert;

  const InventoryCardWidget({
    super.key,
    required this.inventoryItem,
    this.onEdit,
    this.onViewHistory,
    this.onMarkAsUsed,
    this.onDelete,
    this.onDuplicate,
    this.onExport,
    this.onSetAlert,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(inventoryItem['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                HapticFeedback.lightImpact();
                onEdit?.call();
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (context) {
                HapticFeedback.lightImpact();
                onViewHistory?.call();
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.history,
              label: 'History',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (context) {
                HapticFeedback.lightImpact();
                onMarkAsUsed?.call();
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.check_circle,
              label: 'Used',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                HapticFeedback.mediumImpact();
                onDelete?.call();
              },
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.heavyImpact();
            _showContextMenu(context);
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          inventoryItem['partName'] as String? ??
                              'Unknown Part',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStockIndicator(context),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  _buildCompatibleModels(context),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStockInfo(context),
                      _buildPriceInfo(context),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  _buildMetaInfo(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final stock = inventoryItem['stock'] as int? ?? 0;

    Color indicatorColor;
    String statusText;

    if (stock >= 10) {
      indicatorColor = AppTheme.lightTheme.colorScheme.tertiary;
      statusText = 'Good';
    } else if (stock >= 5) {
      indicatorColor = Colors.orange;
      statusText = 'Low';
    } else {
      indicatorColor = theme.colorScheme.error;
      statusText = 'Critical';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: indicatorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: indicatorColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            statusText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibleModels(BuildContext context) {
    final theme = Theme.of(context);
    final models = inventoryItem['compatibleModels'] as List<dynamic>? ?? [];

    if (models.isEmpty) {
      return Text(
        'No compatible models specified',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 1.w,
      runSpacing: 0.5.h,
      children: models.take(3).map((model) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            model.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList()
        ..addAll(
          models.length > 3
              ? [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${models.length - 3} more',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]
              : [],
        ),
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    final theme = Theme.of(context);
    final stock = inventoryItem['stock'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stock',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'inventory',
              size: 16,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 1.w),
            Text(
              '$stock pieces',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    final theme = Theme.of(context);
    final price = inventoryItem['pricePerPiece'] as double? ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Price per piece',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'currency_rupee',
              size: 16,
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
            SizedBox(width: 1.w),
            Text(
              'NPR ${price.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    final theme = Theme.of(context);
    final dateAdded = inventoryItem['dateAdded'] as DateTime? ?? DateTime.now();
    final addedBy = inventoryItem['addedBy'] as String? ?? 'Unknown';

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(width: 1.w),
              Text(
                '${dateAdded.day}/${dateAdded.month}/${dateAdded.year}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'person',
              size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(width: 1.w),
            Text(
              addedBy,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              inventoryItem['partName'] as String? ?? 'Part Options',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(
              context,
              icon: 'content_copy',
              title: 'Duplicate Entry',
              onTap: () {
                Navigator.pop(context);
                onDuplicate?.call();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'file_download',
              title: 'Export Details',
              onTap: () {
                Navigator.pop(context);
                onExport?.call();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'notifications',
              title: 'Set Reorder Alert',
              onTap: () {
                Navigator.pop(context);
                onSetAlert?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        size: 24,
        color: theme.colorScheme.primary,
      ),
      title: Text(title, style: theme.textTheme.bodyMedium),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
