import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/ConfigProvider.dart';
import '../model/ConfigField.dart';

class Results extends StatelessWidget {
  final String revenueFrequency;
  final String repaymentDelay;

  const Results({
    Key? key,
    required this.revenueFrequency,
    required this.repaymentDelay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ConfigProvider>(
      builder: (context, configProvider, child) {
        final revenueConfig = configProvider.config.firstWhere(
          (field) => field.name == 'revenue_amount',
          orElse: () => ConfigField(
              name: '', value: '0', label: '', placeholder: '', tooltip: ''),
        );

        final loanConfig = configProvider.config.firstWhere(
          (field) => field.name == 'funding_amount',
          orElse: () => ConfigField(
              name: '', value: '0', label: '', placeholder: '', tooltip: ''),
        );

        final revenueShareConfig = configProvider.config.firstWhere(
          (field) => field.name == 'revenue_percentage',
          orElse: () => ConfigField(
              name: '', value: '4.0', label: '', placeholder: '', tooltip: ''),
        );

        RegExp regExp = RegExp(r'\d+');
        String? match = regExp.firstMatch(repaymentDelay)?.group(0);
        int myrepaymentDelay = int.tryParse(match ?? '30') ?? 30;

        final double annualRevenue =
            double.tryParse(revenueConfig.value) ?? 0.0;
        final double fundingAmount = double.tryParse(loanConfig.value) ?? 0.0;
        final double revenueSharePercentage =
            double.tryParse(revenueShareConfig.value) ?? 4.0;

        final bool isValidRevenue = annualRevenue > 0;
        final bool isValidFunding = fundingAmount > 0;
        final bool isValidPercentage = revenueSharePercentage > 0;

        final double fees = isValidFunding ? 0.5 * fundingAmount : 0.0;
        final double totalRevenueShare =
            isValidFunding ? fundingAmount + fees : 0.0;

        int expectedTransfers = 0;
        if (isValidRevenue && isValidFunding && isValidPercentage) {
          if (revenueFrequency == 'weekly') {
            expectedTransfers = (totalRevenueShare *
                    52 /
                    (annualRevenue * revenueSharePercentage / 100))
                .ceil();
          } else {
            expectedTransfers = (totalRevenueShare *
                    12 /
                    (annualRevenue * revenueSharePercentage / 100))
                .ceil();
          }
        }

        expectedTransfers = expectedTransfers > 1200 ? 1200 : expectedTransfers;

        final DateTime today = DateTime.now();

        DateTime? completionDate;
        if (isValidRevenue && isValidFunding && isValidPercentage) {
          if (revenueFrequency == 'weekly') {
            completionDate = today
                .add(Duration(days: expectedTransfers * 7 + myrepaymentDelay));
          } else {
            completionDate = DateTime(
              today.year + (today.month + expectedTransfers - 1) ~/ 12,
              (today.month + expectedTransfers - 1) % 12 + 1,
              today.day,
            ).add(Duration(days: myrepaymentDelay));
          }
        }

        final int maxDays = 365 * 100;
        final DateTime maxAllowedDate = today.add(Duration(days: maxDays));
        final DateTime? safeCompletionDate =
            (completionDate != null && completionDate.isAfter(maxAllowedDate))
                ? maxAllowedDate
                : completionDate;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xCCFFFFFF),
            borderRadius: BorderRadius.circular(screenHeight * 0.03),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0D000000),
                offset: const Offset(0, 3),
                blurRadius: 20.0,
                spreadRadius: 6.0,
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Results",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
                      ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 1.0),
                SizedBox(height: screenHeight * 0.01),
                _buildRow(
                    context,
                    "Annual Business Revenue",
                    isValidRevenue
                        ? "\$${annualRevenue.toStringAsFixed(0)}"
                        : "Invalid",
                    screenHeight),
                _buildRow(
                    context,
                    "Funding Amount",
                    isValidFunding
                        ? "\$${fundingAmount.toStringAsFixed(0)}"
                        : "Invalid",
                    screenHeight),
                _buildRow(
                    context,
                    "Fees",
                    isValidFunding
                        ? "(50%) \$${fees.toStringAsFixed(0)}"
                        : "Invalid",
                    screenHeight),
                Divider(color: Colors.grey.shade300, thickness: 1.0),
                _buildRow(
                    context,
                    "Total Revenue Share",
                    isValidFunding
                        ? "\$${totalRevenueShare.toStringAsFixed(0)}"
                        : "Invalid",
                    screenHeight),
                _buildRow(context, "Expected Transfers", "$expectedTransfers",
                    screenHeight),
                _buildRow(
                  context,
                  "Expected Completion Date",
                  safeCompletionDate != null
                      ? DateFormat('MMMM d, y').format(safeCompletionDate)
                      : "Invalid",
                  screenHeight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(
      BuildContext context, String label, String value, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: screenHeight * 0.018,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: screenHeight * 0.018,
                      ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
