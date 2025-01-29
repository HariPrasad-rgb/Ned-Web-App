import 'package:flutter/material.dart';
import '../model/ConfigField.dart';

class RevenueSharedFrequencyWidget extends StatefulWidget {
  final ConfigField configField;
  final Function(String) onSelectionChanged;

  const RevenueSharedFrequencyWidget({
    Key? key,
    required this.configField,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _RevenueSharedFrequencyWidgetState createState() =>
      _RevenueSharedFrequencyWidgetState();
}

class _RevenueSharedFrequencyWidgetState
    extends State<RevenueSharedFrequencyWidget> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    final values = _getAvailableOptions();
    selectedValue = values.isNotEmpty ? values[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final String label = widget.configField.label ?? "Repayment Frequency";
    final List<String> options = _getAvailableOptions();

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: screenHeight * 0.018,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Flexible(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: options
                  .map(
                    (option) => Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.04),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedValue = option;
                          });
                          widget.onSelectionChanged(selectedValue);
                        },
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: screenHeight * 0.03,
                              width: screenHeight * 0.03,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: option == selectedValue
                                      ? theme.primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                                color: option == selectedValue
                                    ? theme.primaryColor.withOpacity(0.2)
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Container(
                                  height: screenHeight * 0.015,
                                  width: screenHeight * 0.015,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: option == selectedValue
                                        ? theme.primaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              option[0].toUpperCase() + option.substring(1),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: screenHeight * 0.018,
                                fontWeight: FontWeight.w500,
                                color: option == selectedValue
                                    ? theme.primaryColor
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getAvailableOptions() {
    return widget.configField.value.split('*');
  }
}
