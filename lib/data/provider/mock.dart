import 'package:flutter/material.dart';
import 'package:malukas/data/model/model.dart';

List<Item> itens = [
  Item(
    name: 'Brigadeiro',
    description:
        'Maravilha de chocolate com aquele brigadeiro que todo mundo ama, por só 15 reais! Pra matar a vontade de doce sem pesar no bolso.',
    price: 15,
    weight: 250, // Supondo que o brownie pese 250 gramas
    delivery: 30, // Supondo entrega em 30 minutos
    image: Image.asset(
      'assets/images/brigadeiro.png',
      fit: BoxFit.contain,
    ),
  ),
  Item(
    name: 'Doce de Leite',
    description:
        'Brownie com doce de leite bem cremoso, só 15 reais. É doce na medida e bolo de chocolate que desmancha na boca!',
    price: 15,
    weight: 250, // Mesmo peso para padronizar
    delivery: 30, // Mesmo tempo de entrega
    image: Image.asset(
      'assets/images/doce.png',
    ),
  ),
  Item(
    name: 'Nutella',
    description:
        'Esse é pros fãs de Nutella: brownie top com um montão de creme de avelã. Só 20 reais e a felicidade tá garantida!',
    price: 20.00,
    weight: 300, // Pode ser um pouco mais pesado devido à Nutella
    delivery: 45, // Tempo de entrega um pouco maior devido à demanda
    image: Image.asset(
      'assets/images/nutella.png',
    ),
  ),
  Item(
    name: 'Ninho',
    description:
        'Brownie sabor Ninho, cremoso e com gostinho de infância. Tá esperando o quê pra se deliciar? Só 20 reais e o pedaço é seu!',
    price: 20.00,
    weight: 300, // Igual ao brownie de Nutella
    delivery: 45, // Mesmo tempo de entrega
    image: Image.asset(
      'assets/images/ninho.png',
    ),
  ),
];
