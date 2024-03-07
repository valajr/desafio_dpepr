import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String selectedShape = 'Círculo';
  double side1 = 0.0;
  double side2 = 0.0;
  double result = 0.0;

  void _calculateArea() {
    setState(() {
      if (selectedShape == 'Círculo') {
        result = 3.14 * side1 * side1 * 7.25;
      } else if (selectedShape == 'Retângulo') {
        result = side1 * side2 * 2.36;
      } else if (selectedShape == 'Triângulo') {
        result = 0.5 * side1 * side2 * 3.94;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aladdin Tapetes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedShape,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedShape = newValue!;
                  });
                },
                items: <String>['Círculo', 'Retângulo', 'Triângulo']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Escolha uma forma'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma das medidas';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    side1 = double.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Número 1'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a outra medida';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    side2 = double.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Número 2'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _calculateArea();
                  }
                },
                child: Text('Calcular Orçamento'),
              ),
              SizedBox(height: 20),
              Text(
                'Preço do tapete: $result',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
