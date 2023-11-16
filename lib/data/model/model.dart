import 'package:flutter/material.dart';

class Item {
  String name;
  String description;
  Image image;
  double price = 0.0;
  int weight;
  int delivery;

  Item({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.weight,
    required this.delivery,
  });
}

class CartItem {
  Item item;
  int quantity;

  CartItem({required this.item, required this.quantity});
}
