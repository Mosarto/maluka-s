import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/model/model.dart';
import 'package:malukas/data/provider/notifiers.dart';
import 'package:malukas/utils/functions.dart';

class SacolaScreen extends StatefulWidget {
  const SacolaScreen({super.key});

  @override
  State<SacolaScreen> createState() => _SacolaScreenState();
}

class _SacolaScreenState extends State<SacolaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: BlocBuilder<CartCubit, List<CartItem>>(
          builder: (context, cartItems) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sacola',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                if (cartItems.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text('Sua sacola está vazia'),
                    ),
                  ),
                Column(
                  children: cartItems
                      .map(
                        (cartItem) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink[200]!,
                                blurRadius: 20,
                                spreadRadius: -10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: cartItem.item.image,
                                ),
                              ),
                              title: Text(cartItem.item.name),
                              subtitle: Text(
                                formatPrice(
                                  cartItem.item.price * cartItem.quantity,
                                ),
                                style: TextStyle(
                                  color: Colors.pink[300],
                                ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.pink[200]!,
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 118,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.pink[200]!,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context.read<CartCubit>().removeItem(
                                                cartItem.item,
                                              );
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.pink[200],
                                        ),
                                      ),
                                      Text(
                                        cartItem.quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.pink[200],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<CartCubit>().addItem(
                                                cartItem.item,
                                              );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.pink[200],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                if (cartItems.isNotEmpty)
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.pink[200]!),
                      ),
                      onPressed: () {
                        context.read<CurrentProductIndexCubit>().changeIndex(0);
                      },
                      icon: Icon(
                        Icons.add_outlined,
                        color: Colors.pink[200],
                      ),
                      label: Text(
                        'Adicionar mais itens',
                        style: TextStyle(
                          color: Colors.pink[200],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 96),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.all(16),
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink[200]!,
                  blurRadius: 20,
                  spreadRadius: -10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Total: ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: formatPrice(
                          context.read<CartCubit>().total,
                        ),
                        style: TextStyle(
                          color: Colors.pink[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Compra finalizada'),
                          content: const Text(
                            'Obrigada por comprar com a gente, iremos lhe encaminhas para o whatsapp para finalizar a compra',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                launchWhatsAppUri(cartItems: cartItems);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                      if (!mounted) return;
                      context.read<CartCubit>().clear();
                      context.read<CurrentProductIndexCubit>().changeIndex(0);
                    },
                    child: const Text('Finalizar compra'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
