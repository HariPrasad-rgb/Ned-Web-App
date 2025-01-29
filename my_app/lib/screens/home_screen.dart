import 'package:flutter/material.dart';
import 'package:my_app/widgets/app_bar.dart';
import '../widgets/financing_options.dart';
import '../widgets/results.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedRevenueFrequency = "";
  String _selectedRepaymentDelay = "";
  dynamic _selectedRevenuPercentage;

  void _onRevenueFrequencyChanged(String value) {
    setState(() {
      _selectedRevenueFrequency = value;
    });
  }

  void _onDelayChanged(String value) {
    setState(() {
      _selectedRepaymentDelay = value;
    });
  }

  void onRevenuePerChanged(dynamic value) {
    setState(() {
      _selectedRevenuPercentage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            CustomAppBar(),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            flex: 3,
                            child: FinancingOptions(
                              onRevenueFrequencyChanged:
                                  _onRevenueFrequencyChanged,
                              onDelayChanged: _onDelayChanged,
                              onRevenuePercentageChanged: onRevenuePerChanged,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Flexible(
                            flex: 2,
                            child: Results(
                              revenueFrequency: _selectedRevenueFrequency,
                              repaymentDelay: _selectedRepaymentDelay,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const BottomNavigation(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
