import 'package:flutter/material.dart';

// Map to store conversion rates for different currencies
final Map<int, CountryCurrency> currencies = {
  1: CountryCurrency(
    country: "ETB",
    inDollar: 0.01762,
    inPound: 0.0138,
    inEuro: 0.0162,
  ),
  2: CountryCurrency(
    country: "ERN",
    inDollar: 0.06667,
    inPound: 0.051848,
    inEuro: 0.060919,
  ),
  // ... other currencies
};

// Class to represent a country and its conversion rates
class CountryCurrency {
  final String country;
  final double inDollar;
  final double inPound;
  final double inEuro;

  CountryCurrency({
    required this.country,
    required this.inDollar,
    required this.inPound,
    required this.inEuro,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Currently selected country (default: Ethiopia)
  int selectedCountry = 1;

  // Type of conversion (1: Country to Dollar, 2: Dollar to Country)
  int conversionType = 1;

  // User entered amount
  double amount = 0.0;

  // Conversion result displayed to user
  String result = "";

  // Function to open dialog for selecting country
  void chooseCountry() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Country'),
          content: DropdownButton<int>(
            value: selectedCountry,
            items: currencies.keys.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(currencies[value]!.country),
              );
            }).toList(),
            onChanged: (int? newValue) {
              // Update selectedCountry and rebuild UI
              setState(() {
                selectedCountry = newValue!;
              });
            },
          ),
        );
      },
    );
  }

  // Function to open dialog for selecting conversion type
  void chooseConversionType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Conversion'),
          content: Column(
            children: [
              RadioListTile<int>(
                title: Text(
                    '${currencies[selectedCountry]!.country} to Dollar'),
                value: 1,
                groupValue: conversionType,
                onChanged: (int? value) {
                  // Update conversionType and rebuild UI
                  setState(() {
                    conversionType = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text(
                    'Dollar to ${currencies[selectedCountry]!.country}'),
                value: 2,
                groupValue: conversionType,
                onChanged: (int? value) {
                  // Update conversionType and rebuild UI
                  setState(() {
                    conversionType = value!;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }


  // Function to perform currency conversion
  void convert() {
    if (amount > 0) {
      CountryCurrency country = currencies[selectedCountry]!;
      double convertedAmount = 0.0;
      switch (conversionType) {
        case 1:
          convertedAmount = country.inDollar * amount;
          break;
        case 2:
          convertedAmount = 1.0 / country.inDollar * amount;
          break;
      }
      setState(() {
        result = "$amount ${currencies[selectedCountry]!
            .country} is equal to $convertedAmount USD";
      });
    } else {
      setState(() {
        result = "Please enter a valid amount.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: chooseCountry,
                    child: const Text('Select Country'),
                  ),
                  ElevatedButton(
                    onPressed: chooseConversionType,
                    child: const Text('Select Conversion'),
                  ),
                ],
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                ),
                onChanged: (value) {
                  // Update the amount variable
                  amount = double.tryParse(value) ?? 0.0;
                },
              ),
              ElevatedButton(
                onPressed: convert,
                child: const Text('Convert'),
              ),
              Text(result), // Display the conversion result
            ],
          ),
        ),
      ),
    );
  }
}