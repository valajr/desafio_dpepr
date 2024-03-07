class PriceModel {
  final String nome;
  final double price;

  PriceModel({
    required this.nome,
    required this.price,
  });

  factory PriceModel.fromMap(Map<String, dynamic> map) {
    return PriceModel(
      nome: map['nome'],
      price: map['valor_m2'],
    );
  }
}