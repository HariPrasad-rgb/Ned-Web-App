import 'package:flutter/material.dart';
import '../model/ConfigField.dart';

class UseOfFundsWidget extends StatefulWidget {
  final ConfigField configField;

  const UseOfFundsWidget({
    Key? key,
    required this.configField,
  }) : super(key: key);

  @override
  _UseOfFundsWidgetState createState() => _UseOfFundsWidgetState();
}

class _UseOfFundsWidgetState extends State<UseOfFundsWidget> {
  final List<Map<String, dynamic>> fundsList = [];
  late String selectedDropdownValue;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final options = _getAvailableOptions();
    selectedDropdownValue = options.isNotEmpty ? options[0] : '';
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _addFund() {
    final description = descriptionController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (description.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide valid inputs.')),
      );
      return;
    }

    setState(() {
      fundsList.add({
        'type': selectedDropdownValue,
        'description': description,
        'amount': amount,
      });
      descriptionController.clear();
      amountController.clear();
    });
  }

  void _removeFund(int index) {
    setState(() {
      fundsList.removeAt(index);
    });
  }

  List<String> _getAvailableOptions() {
    return widget.configField.value
        .split('*')
        .map((option) => option.trim())
        .where((option) => option.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final String label = widget.configField.label ?? "Use of Funds";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: screenHeight * 0.018,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: screenHeight * 0.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedDropdownValue,
                      isExpanded: true,
                      alignment: Alignment.centerLeft,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: screenHeight * 0.016,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedDropdownValue = value;
                          });
                        }
                      },
                      dropdownColor: Colors.white,
                      items: _getAvailableOptions().map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: TextStyle(
                              color: option == selectedDropdownValue
                                  ? theme.primaryColor
                                  : Colors.grey.shade600,
                              fontWeight: option == selectedDropdownValue
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: screenHeight * 0.06,
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.012,
                      horizontal: screenWidth * 0.02,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: screenHeight * 0.06,
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.012,
                      horizontal: screenWidth * 0.02,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            IconButton(
              onPressed: _addFund,
              icon: Icon(Icons.add_circle, color: theme.primaryColor),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        if (fundsList.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight * 0.4),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: fundsList.length,
              itemBuilder: (context, index) {
                final fund = fundsList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(fund['type'])),
                      Expanded(flex: 5, child: Text(fund['description'])),
                      Expanded(flex: 2, child: Text("\$${fund['amount']}")),
                      IconButton(
                        onPressed: () => _removeFund(index),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
