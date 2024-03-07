import 'package:desafio_dpepr/app/data/http/http_client.dart';
import 'package:desafio_dpepr/app/data/repository/price_repository.dart';
import 'package:desafio_dpepr/app/home/stores/price_store.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PriceStore store = PriceStore(
    repository: PriceRepository(
      client: HttpClient(),
    ),
  );

  final _formKey = GlobalKey<FormState>();
  String selectedShape = 'Círculo';
  double side1 = 0.0;
  double side2 = 0.0;
  double price = 0.0;
  double area = 0.0;
  double result = 0.0;

  @override
  void initState() {
    super.initState();
    store.getPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Aladdin Tapetes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          store.erro,
          store.state,
        ]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (store.erro.value.isNotEmpty) {
            return Center(
              child: Text(
                store.erro.value,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum item na lista',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Padding(
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
                        // price = 0.0;
                        // area = 0.0;
                        // result = 0.0;
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            if (selectedShape == 'Círculo') {
                              price = store.state.value[1].price;
                              area = 3.14 * side1 * side1;
                              result = price * area;
                            } else if (selectedShape == 'Retângulo') {
                              price = store.state.value[2].price;
                              area = 3.14 * side1 * side1;
                              result = price * area;
                            } else if (selectedShape == 'Triângulo') {
                              price = store.state.value[0].price;
                              area = 3.14 * side1 * side1;
                              result = price * area;
                            }
                            
                            price = num.parse(price.toStringAsFixed(2)).toDouble();
                            area = num.parse(area.toStringAsFixed(2)).toDouble();
                            result = num.parse(result.toStringAsFixed(2)).toDouble();
                          });
                        }
                      },
                      child: Text('Calcular Orçamento'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Preço do m² do tapete em forma de $selectedShape: R\$ $price',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Área do tapete: $area m²',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Preço do tapete: R\$ $result',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}