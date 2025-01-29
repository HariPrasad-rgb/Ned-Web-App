import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/ConfigField.dart';
import '../provider/ConfigProvider.dart';

class LoanSlider extends StatefulWidget {
  final double businessRevenue;
  final ConfigField configField;

  const LoanSlider({
    Key? key,
    required this.businessRevenue,
    required this.configField,
  }) : super(key: key);

  @override
  _LoanSliderState createState() => _LoanSliderState();
}

class _LoanSliderState extends State<LoanSlider> {
  late double _currentValue;
  late double _maxValue;
  late double _minValue;
  final double _step = 1000.0;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _initializeSliderValues();
    _textController = TextEditingController(
      text: _formatCurrency(_currentValue),
    );
  }

  @override
  void didUpdateWidget(covariant LoanSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.businessRevenue != widget.businessRevenue) {
      _initializeSliderValues();
      if (_currentValue > _maxValue) {
        setState(() {
          _currentValue = _maxValue;
          _textController.text = _formatCurrency(_currentValue);
        });
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _initializeSliderValues() {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);

    final fundingMinConfig = configProvider.config.firstWhere(
      (field) => field.name == 'funding_amount_min',
    );
    final fundingMaxConfig = configProvider.config.firstWhere(
      (field) => field.name == 'funding_amount_max',
    );

    final double fundingAmountMin =
        double.tryParse(fundingMinConfig.value) ?? 25000;
    final double fundingAmountMax =
        double.tryParse(fundingMaxConfig.value) ?? 75000;

    final double calculatedMaxValue =
        (widget.businessRevenue / 3).floorToDouble();

    _maxValue = fundingAmountMax < calculatedMaxValue
        ? fundingAmountMax
        : calculatedMaxValue;

    if (_maxValue < fundingAmountMin || _maxValue <= 0) {
      _maxValue = fundingAmountMin;
    }

    _minValue = fundingAmountMin;

    _currentValue = _minValue;
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final isRevenueTooLow = widget.businessRevenue < _minValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Label
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Text(
            "What is your desired loan amount?",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: screenHeight * 0.018,
            ),
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatCurrency(_minValue),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: screenHeight * 0.016,
                        ),
                      ),
                      Text(
                        _formatCurrency(_maxValue),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: screenHeight * 0.016,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _currentValue,
                    min: _minValue,
                    max: _maxValue,
                    divisions: ((_maxValue - _minValue) / _step).floor() > 0
                        ? ((_maxValue - _minValue) / _step).floor()
                        : 1,
                    label: _formatCurrency(_currentValue),
                    onChanged: (value) {
                      setState(() {
                        _currentValue = _roundToNearestStep(value);
                        _textController.text = _formatCurrency(_currentValue);
                      });
                      _updateConfigProvider();
                    },
                    activeColor: theme.primaryColor,
                    inactiveColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Container(
              width: screenWidth * 0.15,
              height: screenHeight * 0.045,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: screenHeight * 0.016,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical:
                        (screenHeight * 0.045 - screenHeight * 0.018) / 2 - 2,
                  ),
                ),
                onChanged: (value) {
                  final parsedValue =
                      double.tryParse(value.replaceAll('\$', '')) ?? 0.0;
                  if (parsedValue >= _minValue && parsedValue <= _maxValue) {
                    setState(() {
                      _currentValue = parsedValue;
                    });
                    _updateConfigProvider();
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.02,
          child: isRevenueTooLow
              ? Text(
                  "Enter a business revenue greater than \$${_minValue.toStringAsFixed(0)} to adjust loan amount.",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenHeight * 0.016,
                  ),
                )
              : null,
        ),
      ],
    );
  }

  double _roundToNearestStep(double value) {
    return (value / _step).round() * _step;
  }

  void _updateConfigProvider() {
    Provider.of<ConfigProvider>(context, listen: false).updateConfig(
        widget.configField.name, _currentValue.toStringAsFixed(0));
  }
}
