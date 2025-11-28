import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CustomerInfoSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;
  final String selectedContactPreference;
  final Function(String) onContactPreferenceChanged;

  const CustomerInfoSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    required this.selectedContactPreference,
    required this.onContactPreferenceChanged,
  });

  @override
  State<CustomerInfoSection> createState() => _CustomerInfoSectionState();
}

class _CustomerInfoSectionState extends State<CustomerInfoSection> {
  final List<Map<String, String>> countryCodes = [
    {"code": "+977", "country": "Nepal", "flag": "🇳🇵"},
    {"code": "+91", "country": "India", "flag": "🇮🇳"},
    {"code": "+86", "country": "China", "flag": "🇨🇳"},
    {"code": "+1", "country": "USA", "flag": "🇺🇸"},
    {"code": "+44", "country": "UK", "flag": "🇬🇧"},
  ];

  final List<String> contactPreferences = [
    "Phone Call",
    "SMS",
    "WhatsApp",
    "Email",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'person',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Customer Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Customer Name Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Name *',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: widget.nameController,
                decoration: InputDecoration(
                  hintText: 'Enter customer full name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Customer name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Phone Number Field with Country Code
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phone Number *',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  // Country Code Dropdown
                  Container(
                    height: 6.h,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: widget.selectedCountryCode,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            HapticFeedback.lightImpact();
                            widget.onCountryCodeChanged(newValue);
                          }
                        },
                        items: countryCodes.map<DropdownMenuItem<String>>((
                          country,
                        ) {
                          return DropdownMenuItem<String>(
                            value: country["code"]!,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  country["flag"]!,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  country["code"]!,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        icon: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: theme.colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Phone Number Input
                  Expanded(
                    child: TextFormField(
                      controller: widget.phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (value.trim().length < 7) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Contact Preference
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferred Contact Method',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.selectedContactPreference,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        HapticFeedback.lightImpact();
                        widget.onContactPreferenceChanged(newValue);
                      }
                    },
                    items: contactPreferences.map<DropdownMenuItem<String>>((
                      preference,
                    ) {
                      return DropdownMenuItem<String>(
                        value: preference,
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: _getContactIcon(preference),
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Text(preference, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      );
                    }).toList(),
                    icon: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: theme.colorScheme.onSurface,
                      size: 20,
                    ),
                    isExpanded: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getContactIcon(String preference) {
    switch (preference) {
      case 'Phone Call':
        return 'phone';
      case 'SMS':
        return 'sms';
      case 'WhatsApp':
        return 'chat';
      case 'Email':
        return 'email';
      default:
        return 'contact_phone';
    }
  }
}
