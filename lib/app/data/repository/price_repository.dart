import 'dart:convert';

import 'package:desafio_dpepr/app/data/http/exceptions.dart';
import 'package:desafio_dpepr/app/data/http/http_client.dart';
import 'package:desafio_dpepr/app/data/models/price_model.dart';

abstract class IPriceRepository {
  Future<List<PriceModel>> getPrices();
}

class PriceRepository implements IPriceRepository {  
  final IHttpClient client;

  PriceRepository({required this.client});

  @override
  Future<List<PriceModel>> getPrices() async {
    final response = await client.get(
      url: 'https://testedefensoriapr.pythonanywhere.com/precos',
      );

    if (response.statusCode == 200) {
      final List<PriceModel> data = [];

      final body = jsonDecode(response.body);

      body.map((item) {
        final PriceModel shape = PriceModel.fromMap(item);
        data.add(shape);
      }).toList();

      return data;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida.');
    } else {
      throw Exception('Não foi possível carregar os preços.');
    }
  }
}