import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class InventorySearchBarWidget extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  const InventorySearchBarWidget({
    super.key,
    this.initialQuery,
    this.onSearchChanged,
    this.onFilterTap,
    this.showFilter = true,
  });

  @override
  State<InventorySearchBarWidget> createState() =>
      _InventorySearchBarWidgetState();
}

class _InventorySearchBarWidgetState extends State<InventorySearchBarWidget> {
  late TextEditingController _searchController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _isSearchActive = widget.initialQuery?.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isSearchActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: _isSearchActive ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _isSearchActive = value.isNotEmpty;
                  });
                  widget.onSearchChanged?.call(value);
                },
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _isSearchActive = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search parts or drone models...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      size: 20,
                      color: _isSearchActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  suffixIcon: _isSearchActive
                      ? IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _searchController.clear();
                            setState(() {
                              _isSearchActive = false;
                            });
                            widget.onSearchChanged?.call('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            size: 20,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          if (widget.showFilter) ...[
            SizedBox(width: 3.w),
            _buildFilterButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onFilterTap?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'tune',
              size: 24,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
