import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/ConfigField.dart';
import '../provider/ConfigProvider.dart';

class AnnualBusinessRevenueWidget extends StatefulWidget {
  final ConfigField configField;

  const AnnualBusinessRevenueWidget({
    Key? key,
    required this.configField,
  }) : super(key: key);

  @override
  _AnnualBusinessRevenueWidgetState createState() =>
      _AnnualBusinessRevenueWidgetState();
}

class _AnnualBusinessRevenueWidgetState
    extends State<AnnualBusinessRevenueWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _addDollarSign(widget.configField.value),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _addDollarSign(String value) {
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    return numericValue.isEmpty ? '' : '\$$numericValue';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.01),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.configField.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: screenHeight * 0.018,
                      ),
                ),
              ),
              SizedBox(width: 4),
              Text(
                "*",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                      fontSize: screenHeight * 0.018,
                    ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = screenHeight * 0.06;

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: widget.configField.placeholder,
                  hintStyle: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical:
                        (screenHeight * 0.06 - screenHeight * 0.02) / 2 - 2,
                    horizontal: screenWidth * 0.02,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(196, 196, 196, 0.15),
                ),
                onChanged: (value) {
                  final cursorPosition = _controller.selection.base.offset;
                  final formattedValue = _addDollarSign(value);
                  _controller.value = TextEditingValue(
                    text: formattedValue,
                    selection: TextSelection.collapsed(
                      offset: cursorPosition +
                          (formattedValue.length - value.length),
                    ),
                  );
                  final numericValue =
                      formattedValue.replaceAll(RegExp(r'[^0-9]'), '');
                  Provider.of<ConfigProvider>(context, listen: false)
                      .updateConfig(widget.configField.name, numericValue);
                },
              ),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}
