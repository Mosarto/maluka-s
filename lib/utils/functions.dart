import 'package:intl/intl.dart';
import 'package:malukas/data/model/model.dart';
import 'package:malukas/data/provider/mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

String formatPrice(double price) {
  final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return format.format(price);
}

Future<List<String>> getFavoriteIndex() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var favoriteIndex = prefs.getStringList('favoriteIndex') ?? [];
  return favoriteIndex;
}

Future<void> addFavoriteIndex(String index) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var favoriteIndex = prefs.getStringList('favoriteIndex') ?? [];
  favoriteIndex.add(index);
  await prefs.setStringList('favoriteIndex', favoriteIndex);
}

Future<void> removeFavoriteIndex(String index) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var favoriteIndex = prefs.getStringList('favoriteIndex') ?? [];
  favoriteIndex.remove(index);
  await prefs.setStringList('favoriteIndex', favoriteIndex);
}

Future<List<Item>> getFavoriteItens() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var favoriteIndex = prefs.getStringList('favoriteIndex') ?? [];
  var favoriteItens =
      itens.where((item) => favoriteIndex.contains(item.name)).toList();
  return favoriteItens;
}

launchWhatsAppUri({
  required List<CartItem> cartItems,
}) async {
  double totalPedido = 0.0;

  StringBuffer message = StringBuffer();
  message.writeln("Olá! Aqui está o seu pedido:\n");

  for (final cartItem in cartItems) {
    double totalItem = cartItem.item.price * cartItem.quantity;
    totalPedido += totalItem;

    message.writeln(
        "${cartItem.item.name} - ${cartItem.quantity}x R\$${cartItem.item.price.toStringAsFixed(2)} = R\$${totalItem.toStringAsFixed(2)}");
  }

  message
      .writeln("\nValor total do pedido: R\$${totalPedido.toStringAsFixed(2)}");
  message.writeln("\nMuito obrigado por comprar com a gente! 😊");
  message.writeln(
      "Não esqueça de nos seguir no Instagram para mais novidades: https://www.instagram.com/malukasbrownie/");

  var link = WhatsAppUnilink(
    phoneNumber: '+55 19 99944-4893',
    text: message.toString(),
  );

  await launchUrl(link.asUri());
}
