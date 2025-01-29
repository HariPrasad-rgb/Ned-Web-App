import 'package:flutter/material.dart';
import '../model/ConfigField.dart';
import 'package:provider/provider.dart';
import '../provider/ConfigProvider.dart';

class RevenuePercentageWidget extends StatelessWidget {
  final ConfigField configField;
  final double revenueAmount;
  final double loanAmount;

  const RevenuePercentageWidget({
    Key? key,
    required this.configField,
    required this.revenueAmount,
    required this.loanAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);

    // Fetch min and max constraints
    final revenueMinConfig = configProvider.config.firstWhere(
      (field) => field.name == 'revenue_percentage_min',
    );
    final revenueMaxConfig = configProvider.config.firstWhere(
      (field) => field.name == 'revenue_percentage_max',
    );
    final double revenuePercentageMin =
        double.tryParse(revenueMinConfig.value) ?? 5.0;
    final double revenuePercentageMax =
        double.tryParse(revenueMaxConfig.value) ?? 10.0;
    final double revenuePercentage = _calculateRevenuePercentage()
        .clamp(revenuePercentageMin, revenuePercentageMax);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateConfig(configProvider, revenuePercentage);
    });

    final String label = configField.label ?? "Revenue Share Percentage";
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        right: 16.0,
        top: screenHeight * 0.01,
        bottom: screenHeight * 0.01,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: screenHeight * 0.018,
                  ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 6.0),

          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "${revenuePercentage.toStringAsFixed(2)}%",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.018,
                  ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateRevenuePercentage() {
    if (revenueAmount <= 0 || loanAmount <= 0) {
      return 0.0;
    }

    const double constant1 = 0.156;
    const double constant2 = 6.2055;
    return (constant1 / (constant2 * revenueAmount)) * (loanAmount * 10) * 100;
  }

  void _updateConfig(ConfigProvider configProvider, double revenuePercentage) {
    final currentValue = configProvider.config
        .firstWhere(
          (field) => field.name == configField.name,
        )
        .value;

    if (currentValue != revenuePercentage.toStringAsFixed(2)) {
      configProvider.updateConfig(
        configField.name,
        revenuePercentage.toStringAsFixed(2),
      );
    }
  }
}
