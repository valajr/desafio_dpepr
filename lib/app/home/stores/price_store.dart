import 'package:desafio_dpepr/app/data/http/exceptions.dart';
import 'package:desafio_dpepr/app/data/models/price_model.dart';
import 'package:desafio_dpepr/app/data/repository/price_repository.dart';
import 'package:flutter/material.dart';

class PriceStore {
  final IPriceRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<PriceModel>> state = ValueNotifier<List<PriceModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  PriceStore({required this.repository});

  Future getPrices() async {
    isLoading.value = true;

    try{
      final result = await repository.getPrices();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    }
    catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}