import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ConfigProvider.dart';
import '../widgets/annual_business_revenue.dart';
import '../widgets/desired_repayment_delay.dart';
import '../widgets/loanslider.dart';
import '../widgets/revenue_percetange.dart';
import '../widgets/revenue_shared_frequency.dart';
import '../widgets/use_of_funds.dart';

class FinancingOptions extends StatelessWidget {
  final Function(String) onRevenueFrequencyChanged;
  final Function(String) onDelayChanged;
  final Function(dynamic) onRevenuePercentageChanged;

  const FinancingOptions({
    Key? key,
    required this.onRevenueFrequencyChanged,
    required this.onDelayChanged,
    required this.onRevenuePercentageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ConfigProvider>(
      builder: (context, configProvider, child) {
        if (configProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final revenueConfig = configProvider.config.firstWhere(
          (field) => field.name == 'revenue_amount',
        );
        final loanConfig = configProvider.config.firstWhere(
          (field) => field.name == 'funding_amount',
        );
        final loanAmount = double.tryParse(loanConfig.value) ?? 0.0;
        final revenueShareConfig = configProvider.config.firstWhere(
          (field) => field.name == 'revenue_percentage',
        );
        final revFreq = configProvider.config.firstWhere(
          (field) => field.name == 'revenue_shared_frequency',
        );
        final repaymentDelay = configProvider.config.firstWhere(
          (field) => field.name == 'desired_repayment_delay',
        );
        final fundsConfig = configProvider.config.firstWhere(
          (field) => field.name == 'use_of_funds',
        );
        final annualBusinessRevenue =
            double.tryParse(revenueConfig.value) ?? 0.0;

        return SizedBox(
          height: screenHeight * 0.65,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 3),
                  blurRadius: 20.0,
                  spreadRadius: 6.0,
                ),
              ],
            ),
            padding: EdgeInsets.all(screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Financing Options",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: screenHeight * 0.022,
                      ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnnualBusinessRevenueWidget(configField: revenueConfig),
                        SizedBox(height: screenHeight * 0.02),
                        LoanSlider(
                          businessRevenue: annualBusinessRevenue,
                          configField: loanConfig,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        RevenuePercentageWidget(
                          configField: revenueShareConfig,
                          revenueAmount: annualBusinessRevenue,
                          loanAmount: loanAmount,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        RevenueSharedFrequencyWidget(
                          configField: revFreq,
                          onSelectionChanged: onRevenueFrequencyChanged,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        DesiredRepaymentDelayWidget(
                          configField: repaymentDelay,
                          onSelectionChanged: onDelayChanged,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        UseOfFundsWidget(configField: fundsConfig),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
