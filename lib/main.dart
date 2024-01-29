import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _codeCount = 10;
  final List<String> _generatedCodes = [];
  String _selectedCodeType = 'Alphanumeric';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Generator'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white60.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Generate Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Number of codes (max 100)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            setState(() {
                              _codeCount = int.parse(value.trim());
                              _codeCount = _codeCount.clamp(1, 100);
                            });
                          } on FormatException catch (e) {
                            print('Invalid input: $e');
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedCodeType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Alphanumeric',
                        child: Text('Alphanumeric'),
                      ),
                      DropdownMenuItem(
                        value: 'Numeric',
                        child: Text('Numeric'),
                      ),
                      DropdownMenuItem(
                        value: 'Symbols',
                        child: Text('Symbols'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedCodeType = value!),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () =>
                        generateCodes(_codeCount, _selectedCodeType),
                    child: const Text('Generate'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_generatedCodes.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _generatedCodes
                          .map((code) => Text(
                                code,
                                style: const TextStyle(fontSize: 16),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _clearGeneratedCodes(),
                child: const Text('Clear Codes'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _copyToClipboard(_generatedCodes.join(', ')),
                child: const Text('Upload to the system'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _copyToClipboard(_generatedCodes.join(', ')),
                child: const Text('Copy Codes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateCodes(int count, String codeType) {
    _generatedCodes.clear();
    for (int i = 0; i < count; i++) {
      _generatedCodes.add(_generateCode(codeType));
    }
    setState(() {});
  }

  String _generateCode(String codeType) {
    const alphanumericChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const numericChars = '0123456789';
    const symbolChars = '!@#\$%^&*()_-+=<>?/{}';

    String chars = '';

    switch (codeType) {
      case 'Alphanumeric':
        chars = alphanumericChars;
        break;
      case 'Numeric':
        chars = numericChars;
        break;
      case 'Symbols':
        chars = symbolChars;
        break;
    }

    String code = '';
    final random = Random();

    for (int i = 0; i < 16; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  void _clearGeneratedCodes() {
    setState(() {
      _generatedCodes.clear();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Codes copied to clipboard')),
    );
  }
}
