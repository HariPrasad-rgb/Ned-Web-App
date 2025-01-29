import 'package:flutter/material.dart';
import '../model/ConfigField.dart';

class DesiredRepaymentDelayWidget extends StatefulWidget {
  final ConfigField configField;
  final Function(String) onSelectionChanged;

  const DesiredRepaymentDelayWidget({
    Key? key,
    required this.configField,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _DesiredRepaymentDelayWidgetState createState() =>
      _DesiredRepaymentDelayWidgetState();
}

class _DesiredRepaymentDelayWidgetState
    extends State<DesiredRepaymentDelayWidget> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();

    final options = _getAvailableOptions();

    selectedValue = widget.configField.selectedValue ??
        (options.contains(widget.configField.value)
            ? widget.configField.value
            : (options.isNotEmpty ? options[0] : ''));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged(selectedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final String label = widget.configField.label.isNotEmpty
        ? widget.configField.label
        : "Repayment Delay";
    final List<String> options = _getAvailableOptions();

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
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
          Container(
            width: screenWidth * 0.10,
            height: screenHeight * 0.05,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                alignment: Alignment.centerLeft,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: screenHeight * 0.016,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedValue = newValue;
                    });
                    widget.onSelectionChanged(newValue);
                  }
                },
                dropdownColor: Colors.white,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        color: option == selectedValue
                            ? theme.primaryColor
                            : Colors.grey.shade600,
                        fontWeight: option == selectedValue
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getAvailableOptions() {
    return widget.configField.value
        .split('*')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
