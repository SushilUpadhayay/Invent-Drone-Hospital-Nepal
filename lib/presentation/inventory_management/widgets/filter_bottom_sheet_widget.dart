import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SortOption { stockLevel, price, dateAdded, partnerEntry, alphabetical }

enum StockFilter { all, adequate, low, critical }

class FilterBottomSheetWidget extends StatefulWidget {
  final SortOption? currentSortOption;
  final StockFilter? currentStockFilter;
  final bool? sortAscending;
  final Function(SortOption, bool)? onSortChanged;
  final Function(StockFilter)? onStockFilterChanged;
  final VoidCallback? onReset;
  final VoidCallback? onApply;

  const FilterBottomSheetWidget({
    super.key,
    this.currentSortOption,
    this.currentStockFilter,
    this.sortAscending,
    this.onSortChanged,
    this.onStockFilterChanged,
    this.onReset,
    this.onApply,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late SortOption _selectedSortOption;
  late StockFilter _selectedStockFilter;
  late bool _sortAscending;

  @override
  void initState() {
    super.initState();
    _selectedSortOption = widget.currentSortOption ?? SortOption.dateAdded;
    _selectedStockFilter = widget.currentStockFilter ?? StockFilter.all;
    _sortAscending = widget.sortAscending ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 3.h),
          _buildSortSection(context),
          SizedBox(height: 3.h),
          _buildStockFilterSection(context),
          SizedBox(height: 4.h),
          _buildActionButtons(context),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 12.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filter & Sort',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedSortOption = SortOption.dateAdded;
                  _selectedStockFilter = StockFilter.all;
                  _sortAscending = false;
                });
                widget.onReset?.call();
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'sort',
              size: 20,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Sort By',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...SortOption.values.map((option) => _buildSortOption(context, option)),
        SizedBox(height: 2.h),
        _buildSortOrderToggle(context),
      ],
    );
  }

  Widget _buildSortOption(BuildContext context, SortOption option) {
    final theme = Theme.of(context);
    final isSelected = _selectedSortOption == option;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedSortOption = option;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Radio<SortOption>(
                value: option,
                groupValue: _selectedSortOption,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSortOption = value;
                    });
                  }
                },
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSortOptionTitle(option),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? theme.colorScheme.primary : null,
                      ),
                    ),
                    Text(
                      _getSortOptionDescription(option),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOrderToggle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _sortAscending ? 'arrow_upward' : 'arrow_downward',
            size: 20,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Sort Order',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: _sortAscending,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _sortAscending = value;
              });
            },
          ),
          SizedBox(width: 2.w),
          Text(
            _sortAscending ? 'Ascending' : 'Descending',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockFilterSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'filter_list',
              size: 20,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Stock Level Filter',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: StockFilter.values
              .map((filter) => _buildStockFilterChip(context, filter))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStockFilterChip(BuildContext context, StockFilter filter) {
    final theme = Theme.of(context);
    final isSelected = _selectedStockFilter == filter;

    return FilterChip(
      label: Text(_getStockFilterTitle(filter)),
      selected: isSelected,
      onSelected: (selected) {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedStockFilter = filter;
        });
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: isSelected ? theme.colorScheme.primary : null,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onSortChanged?.call(_selectedSortOption, _sortAscending);
              widget.onStockFilterChanged?.call(_selectedStockFilter);
              widget.onApply?.call();
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ),
      ],
    );
  }

  String _getSortOptionTitle(SortOption option) {
    switch (option) {
      case SortOption.stockLevel:
        return 'Stock Level';
      case SortOption.price:
        return 'Price';
      case SortOption.dateAdded:
        return 'Date Added';
      case SortOption.partnerEntry:
        return 'Partner Entry';
      case SortOption.alphabetical:
        return 'Alphabetical';
    }
  }

  String _getSortOptionDescription(SortOption option) {
    switch (option) {
      case SortOption.stockLevel:
        return 'Sort by available quantity';
      case SortOption.price:
        return 'Sort by price per piece';
      case SortOption.dateAdded:
        return 'Sort by entry date';
      case SortOption.partnerEntry:
        return 'Sort by partner who added';
      case SortOption.alphabetical:
        return 'Sort by part name A-Z';
    }
  }

  String _getStockFilterTitle(StockFilter filter) {
    switch (filter) {
      case StockFilter.all:
        return 'All Items';
      case StockFilter.adequate:
        return 'Adequate Stock (10+)';
      case StockFilter.low:
        return 'Low Stock (5-9)';
      case StockFilter.critical:
        return 'Critical Stock (<5)';
    }
  }
}
