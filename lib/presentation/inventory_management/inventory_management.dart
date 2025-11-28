import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/add_part_form_widget.dart';
import './widgets/empty_inventory_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/inventory_card_widget.dart';
import './widgets/inventory_search_bar_widget.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});
  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  SortOption _currentSortOption = SortOption.dateAdded;
  StockFilter _currentStockFilter = StockFilter.all;
  bool _sortAscending = false;
  final bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock inventory data
  final List<Map<String, dynamic>> _inventoryData = [
    {
      "id": 1,
      "partName": "DJI Mini 2 Propeller Set",
      "compatibleModels": ["DJI Mini 2", "DJI Mini SE"],
      "stock": 15,
      "pricePerPiece": 850.0,
      "dateAdded": DateTime(2024, 10, 15),
      "addedBy": "Partner A",
    },
    {
      "id": 2,
      "partName": "Gimbal Camera Assembly",
      "compatibleModels": ["DJI Air 2S", "DJI Mavic 3"],
      "stock": 3,
      "pricePerPiece": 12500.0,
      "dateAdded": DateTime(2024, 10, 20),
      "addedBy": "Partner B",
    },
    {
      "id": 3,
      "partName": "Battery Pack 3000mAh",
      "compatibleModels": ["DJI Mini 2", "DJI Air 2S", "DJI FPV"],
      "stock": 8,
      "pricePerPiece": 4200.0,
      "dateAdded": DateTime(2024, 11, 1),
      "addedBy": "Partner A",
    },
    {
      "id": 4,
      "partName": "Motor Assembly Left Front",
      "compatibleModels": ["DJI Mavic 3", "Autel EVO Lite+"],
      "stock": 2,
      "pricePerPiece": 3800.0,
      "dateAdded": DateTime(2024, 11, 5),
      "addedBy": "Partner B",
    },
    {
      "id": 5,
      "partName": "Remote Controller Joystick",
      "compatibleModels": [
        "DJI Mini 2",
        "DJI Air 2S",
        "DJI Mavic 3",
        "DJI FPV",
      ],
      "stock": 12,
      "pricePerPiece": 650.0,
      "dateAdded": DateTime(2024, 11, 7),
      "addedBy": "Partner A",
    },
    {
      "id": 6,
      "partName": "Landing Gear Set",
      "compatibleModels": ["Skydio 2+", "Parrot Anafi"],
      "stock": 1,
      "pricePerPiece": 1200.0,
      "dateAdded": DateTime(2024, 11, 6),
      "addedBy": "Partner B",
    },
  ];
  List<Map<String, dynamic>> get _filteredInventory {
    List<Map<String, dynamic>> filtered = List.from(_inventoryData);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        final partName = (item['partName'] as String? ?? '').toLowerCase();
        final models = (item['compatibleModels'] as List<dynamic>? ?? [])
            .map((model) => model.toString().toLowerCase())
            .join(' ');
        final query = _searchQuery.toLowerCase();
        return partName.contains(query) || models.contains(query);
      }).toList();
    }
    if (_currentStockFilter != StockFilter.all) {
      filtered = filtered.where((item) {
        final stock = item['stock'] as int? ?? 0;
        switch (_currentStockFilter) {
          case StockFilter.adequate:
            return stock >= 10;
          case StockFilter.low:
            return stock >= 5 && stock < 10;
          case StockFilter.critical:
            return stock < 5;
          case StockFilter.all:
            return true;
        }
      }).toList();
    }

    filtered.sort((a, b) {
      int comparison = 0;
      switch (_currentSortOption) {
        case SortOption.stockLevel:
          comparison = (a['stock'] as int).compareTo(b['stock'] as int);
          break;
        case SortOption.price:
          comparison = (a['pricePerPiece'] as double).compareTo(
            b['pricePerPiece'] as double,
          );
          break;
        case SortOption.dateAdded:
          comparison = (a['dateAdded'] as DateTime).compareTo(
            b['dateAdded'] as DateTime,
          );
          break;
        case SortOption.partnerEntry:
          comparison = (a['addedBy'] as String).compareTo(
            b['addedBy'] as String,
          );
          break;
        case SortOption.alphabetical:
          comparison = (a['partName'] as String).compareTo(
            b['partName'] as String,
          );
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredItems = _filteredInventory;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Inventory Management',
        centerTitle: true,
      ),
      body: Column(
        children: [
          InventorySearchBarWidget(
            initialQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onFilterTap: _showFilterBottomSheet,
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : filteredItems.isEmpty
                    ? EmptyInventoryWidget(
                        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
                        onAddFirstPart: _showAddPartForm,
                      )
                    : _buildInventoryList(filteredItems),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showAddPartForm();
        },
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: CustomBottomBar.getCurrentIndex('/inventory-management'),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading inventory...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(List<Map<String, dynamic>> items) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InventoryCardWidget(
            inventoryItem: item,
            onEdit: () => _handleEditPart(item),
            onViewHistory: () => _handleViewHistory(item),
            onMarkAsUsed: () => _handleMarkAsUsed(item),
            onDelete: () => _handleDeletePart(item),
            onDuplicate: () => _handleDuplicatePart(item),
            onExport: () => _handleExportPart(item),
            onSetAlert: () => _handleSetAlert(item),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inventory synced successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheetWidget(
        currentSortOption: _currentSortOption,
        currentStockFilter: _currentStockFilter,
        sortAscending: _sortAscending,
        onSortChanged: (option, ascending) {
          setState(() {
            _currentSortOption = option;
            _sortAscending = ascending;
          });
        },
        onStockFilterChanged: (filter) {
          setState(() {
            _currentStockFilter = filter;
          });
        },
        onReset: () {
          setState(() {
            _currentSortOption = SortOption.dateAdded;
            _currentStockFilter = StockFilter.all;
            _sortAscending = false;
          });
        },
      ),
    );
  }

  void _showAddPartForm({Map<String, dynamic>? initialData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddPartFormWidget(
          initialData: initialData,
          onSave: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  initialData != null
                      ? 'Part updated successfully'
                      : 'Part added successfully',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _handleEditPart(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    _showAddPartForm(initialData: item);
  }

  void _handleViewHistory(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing history for ${item['partName']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMarkAsUsed(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark as Used'),
        content: Text('How many pieces of "${item['partName']}" were used?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Stock updated for ${item['partName']}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _handleDeletePart(Map<String, dynamic> item) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Part'),
        content: Text(
          'Are you sure you want to delete "${item['partName']}"? This action requires dual-partner PIN verification.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PIN verification required for deletion'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleDuplicatePart(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    final duplicatedItem = Map<String, dynamic>.from(item);
    duplicatedItem['partName'] = '${item['partName']} (Copy)';
    _showAddPartForm(initialData: duplicatedItem);
  }

  void _handleExportPart(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting details for ${item['partName']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSetAlert(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Reorder Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Set minimum stock level for "${item['partName']}"'),
            SizedBox(height: 2.h),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minimum Stock Level',
                hintText: '5',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reorder alert set for ${item['partName']}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text('Set Alert'),
          ),
        ],
      ),
    );
  }
}
