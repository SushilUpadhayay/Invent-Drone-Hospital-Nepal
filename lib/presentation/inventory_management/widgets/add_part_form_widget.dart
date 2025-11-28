import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddPartFormWidget extends StatefulWidget {
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final Map<String, dynamic>? initialData;

  const AddPartFormWidget({
    super.key,
    this.onSave,
    this.onCancel,
    this.initialData,
  });

  @override
  State<AddPartFormWidget> createState() => _AddPartFormWidgetState();
}

class _AddPartFormWidgetState extends State<AddPartFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _partNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  final List<String> _availableDroneModels = [
    'DJI Mini 2',
    'DJI Air 2S',
    'DJI Mavic 3',
    'DJI FPV',
    'Autel EVO Lite+',
    'Skydio 2+',
    'Parrot Anafi',
    'Holy Stone HS720E',
    'Potensic Dreamer Pro',
    'Ruko F11GIM2',
  ];

  List<String> _selectedModels = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _populateInitialData();
    }
  }

  void _populateInitialData() {
    final data = widget.initialData!;
    _partNameController.text = data['partName'] as String? ?? '';
    _quantityController.text = (data['stock'] as int? ?? 0).toString();
    _priceController.text =
        (data['pricePerPiece'] as double? ?? 0.0).toString();
    _selectedModels = List<String>.from(
      data['compatibleModels'] as List? ?? [],
    );
  }

  @override
  void dispose() {
    _partNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 3.h),
            _buildPartNameField(context),
            SizedBox(height: 2.h),
            _buildCompatibleModelsSection(context),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(child: _buildQuantityField(context)),
                SizedBox(width: 4.w),
                Expanded(child: _buildPriceField(context)),
              ],
            ),
            SizedBox(height: 3.h),
            _buildActionButtons(context),
            SizedBox(height: 2.h),
          ],
        ),
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
        Text(
          widget.initialData != null ? 'Edit Part' : 'Add New Part',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPartNameField(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Part Name *',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _partNameController,
          decoration: InputDecoration(
            hintText: 'Enter part name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'build',
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Part name is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCompatibleModelsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compatible Drone Models',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'flight',
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  _selectedModels.isEmpty
                      ? 'Select compatible models'
                      : '${_selectedModels.length} models selected',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: CustomIconWidget(
                  iconName: 'expand_more',
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                onTap: () => _showModelSelectionDialog(context),
              ),
              if (_selectedModels.isNotEmpty) ...[
                const Divider(height: 1),
                Container(
                  padding: EdgeInsets.all(3.w),
                  child: Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _selectedModels.map((model) {
                      return Chip(
                        label: Text(model, style: theme.textTheme.labelSmall),
                        deleteIcon: CustomIconWidget(
                          iconName: 'close',
                          size: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedModels.remove(model);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity *',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '0',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'inventory',
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Quantity is required';
            }
            final quantity = int.tryParse(value);
            if (quantity == null || quantity < 0) {
              return 'Enter valid quantity';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriceField(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price (NPR) *',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: '0.00',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'currency_rupee',
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Price is required';
            }
            final price = double.tryParse(value);
            if (price == null || price < 0) {
              return 'Enter valid price';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    widget.onCancel?.call();
                  },
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(widget.initialData != null ? 'Update' : 'Save'),
          ),
        ),
      ],
    );
  }

  void _showModelSelectionDialog(BuildContext context) {
    final theme = Theme.of(context);
    List<String> tempSelected = List.from(_selectedModels);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Select Compatible Models'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _availableDroneModels.length,
              itemBuilder: (context, index) {
                final model = _availableDroneModels[index];
                final isSelected = tempSelected.contains(model);

                return CheckboxListTile(
                  title: Text(model),
                  value: isSelected,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        tempSelected.add(model);
                      } else {
                        tempSelected.remove(model);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedModels = tempSelected;
                });
                Navigator.pop(context);
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    widget.onSave?.call();
  }
}
