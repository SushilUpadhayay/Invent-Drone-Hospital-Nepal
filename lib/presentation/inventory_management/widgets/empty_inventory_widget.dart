import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyInventoryWidget extends StatelessWidget {
  final VoidCallback? onAddFirstPart;
  final String? searchQuery;

  const EmptyInventoryWidget({
    super.key,
    this.onAddFirstPart,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearchResult = searchQuery != null && searchQuery!.isNotEmpty;

    return Center(
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context, isSearchResult),
            SizedBox(height: 4.h),
            _buildTitle(context, isSearchResult),
            SizedBox(height: 2.h),
            _buildDescription(context, isSearchResult),
            SizedBox(height: 4.h),
            if (!isSearchResult) _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, bool isSearchResult) {
    final theme = Theme.of(context);

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: isSearchResult ? 'search_off' : 'inventory_2',
          size: 20.w,
          color: theme.colorScheme.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isSearchResult) {
    final theme = Theme.of(context);

    return Text(
      isSearchResult ? 'No Results Found' : 'No Inventory Items',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context, bool isSearchResult) {
    final theme = Theme.of(context);

    return Text(
      isSearchResult
          ? 'We couldn\'t find any parts matching "$searchQuery". Try adjusting your search terms or check the spelling.'
          : 'Start building your drone parts inventory by adding your first item. Track stock levels, prices, and compatible drone models.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onAddFirstPart?.call();
          },
          icon: CustomIconWidget(
            iconName: 'add',
            size: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text('Add First Part'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildQuickTips(context),
      ],
    );
  }

  Widget _buildQuickTips(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                size: 16,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Quick Tips',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildTipItem(
            context,
            'Add part names, compatible models, and stock levels',
          ),
          _buildTipItem(context, 'Set up reorder alerts for low stock items'),
          _buildTipItem(context, 'Track which partner added each part'),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String tip) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.8.h, right: 2.w),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
