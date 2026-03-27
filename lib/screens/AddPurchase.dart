import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import '../providers/PurchaseProducts.dart';
import '../models/purchase.dart';
import 'CameraScreen.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  // Common fields
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Meals';
  String? _imagePath;

  // Bills Payment fields
  final _billTypeController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _billingPeriodController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _paymentMethodController = TextEditingController();

  // Transportation fields
  final _transportTypeController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _notesController = TextEditingController();

  static const List<Map<String, String>> _categories = [
    {'label': 'Meals', 'emoji': '🍽'},
    {'label': 'Merienda', 'emoji': '☕'},
    {'label': 'Groceries', 'emoji': '🛒'},
    {'label': 'Vegetables', 'emoji': '🥦'},
    {'label': 'Transportation', 'emoji': '🚗'},
    {'label': 'Bills', 'emoji': '🧾'},
    {'label': 'Entertainment', 'emoji': '🎮'},
    {'label': 'Health', 'emoji': '💊'},
    {'label': 'Others', 'emoji': '📦'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Add Purchase')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Add a new purchase',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Category',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.2,
                        children: _categories.map((cat) {
                          final selected = _selectedCategory == cat['label'];
                          return GestureDetector(
                            onTap: () => setState(
                              () => _selectedCategory = cat['label']!,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    cat['emoji']!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      cat['label']!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      // Render appropriate form based on category
                      if (_selectedCategory == 'Bills')
                        _buildBillsPaymentForm()
                      else if (_selectedCategory == 'Transportation')
                        _buildTransportationForm()
                      else
                        _buildGroceryForm(),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _takePhoto,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Take Photo for Confirmation'),
                        ),
                      ),
                      if (_imagePath != null) ...[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(_imagePath!),
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _savePurchase,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Save Purchase'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroceryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Daily dishes recommendation removed as requested
        // Add normal purchase input fields below
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Item Name'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillsPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _billTypeController,
          decoration: const InputDecoration(
            labelText: 'Bill Type (e.g., Electricity, Internet, Water)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _accountNumberController,
          decoration: const InputDecoration(labelText: 'Account Number'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _billingPeriodController,
                decoration: const InputDecoration(
                  labelText: 'Billing Period (e.g., Monthly)',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: 'Due Date'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _paymentMethodController,
          decoration: const InputDecoration(
            labelText: 'Payment Method (e.g., Credit Card, Bank Transfer)',
          ),
        ),
      ],
    );
  }

  Widget _buildTransportationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _transportTypeController,
          decoration: const InputDecoration(
            labelText: 'Transport Type (e.g., Taxi, Bus, Fuel)',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _originController,
                decoration: const InputDecoration(labelText: 'Origin/From'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination/To'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Fare/Cost'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
          maxLines: 2,
        ),
      ],
    );
  }

  void _takePhoto() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final navigator = Navigator.of(context);
      final result = await navigator.push(
        MaterialPageRoute(builder: (_) => CameraScreen(camera: cameras.first)),
      );
      if (result != null) {
        if (!mounted) return;
        setState(() {
          _imagePath = result;
        });

        // Here, you could add OCR or image recognition to auto-fill name
        final textRecognizer = TextRecognizer();
        final inputImage = InputImage.fromFilePath(_imagePath!);
        final recognizedText = await textRecognizer.processImage(inputImage);
        if (recognizedText.text.isNotEmpty) {
          // Simple heuristic: take the first line as item name
          final lines = recognizedText.text.split('\n');
          if (lines.isNotEmpty) {
            if (!mounted) return;
            setState(() {
              if (_selectedCategory == 'Bills' &&
                  _billTypeController.text.isEmpty) {
                _billTypeController.text = lines.first.trim();
              } else if (_selectedCategory == 'Transportation' &&
                  _transportTypeController.text.isEmpty) {
                _transportTypeController.text = lines.first.trim();
              } else if (_nameController.text.isEmpty) {
                _nameController.text = lines.first.trim();
              }
            });
          }
        }
        textRecognizer.close();
      }
    }
  }

  void _savePurchase() {
    if (_selectedCategory == 'Bills') {
      if (_billTypeController.text.isEmpty || _priceController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return;
      }

      final purchase = Purchase(
        itemName: _billTypeController.text,
        category: _selectedCategory,
        quantity: 1,
        price: double.parse(_priceController.text),
        date: DateTime.now().toIso8601String(),
        receiptImagePath: _imagePath,
        billType: _billTypeController.text,
        accountNumber: _accountNumberController.text.isEmpty
            ? null
            : _accountNumberController.text,
        billingPeriod: _billingPeriodController.text.isEmpty
            ? null
            : _billingPeriodController.text,
        dueDate: _dueDateController.text.isEmpty
            ? null
            : _dueDateController.text,
        paymentMethod: _paymentMethodController.text.isEmpty
            ? null
            : _paymentMethodController.text,
      );
      context.read<PurchaseProvider>().addPurchase(purchase);
      Navigator.pop(context);
    } else if (_selectedCategory == 'Transportation') {
      if (_transportTypeController.text.isEmpty ||
          _priceController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return;
      }

      final purchase = Purchase(
        itemName: _transportTypeController.text,
        category: _selectedCategory,
        quantity: 1,
        price: double.parse(_priceController.text),
        date: DateTime.now().toIso8601String(),
        receiptImagePath: _imagePath,
        transportType: _transportTypeController.text,
        origin: _originController.text.isEmpty ? null : _originController.text,
        destination: _destinationController.text.isEmpty
            ? null
            : _destinationController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      context.read<PurchaseProvider>().addPurchase(purchase);
      Navigator.pop(context);
    } else {
      // Grocery form
      if (_nameController.text.isEmpty ||
          _quantityController.text.isEmpty ||
          _priceController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return;
      }

      final purchase = Purchase(
        itemName: _nameController.text,
        category: _selectedCategory,
        quantity: double.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        date: DateTime.now().toIso8601String(),
        receiptImagePath: _imagePath,
      );
      context.read<PurchaseProvider>().addPurchase(purchase);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _billTypeController.dispose();
    _accountNumberController.dispose();
    _billingPeriodController.dispose();
    _dueDateController.dispose();
    _paymentMethodController.dispose();
    _transportTypeController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
