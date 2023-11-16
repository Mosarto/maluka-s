import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/model/model.dart';
import 'package:malukas/data/provider/notifiers.dart';
import 'package:malukas/utils/functions.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ProdutoDetalheScreen extends StatefulWidget {
  final Item item;
  final bool isFavorite;
  const ProdutoDetalheScreen({
    super.key,
    required this.item,
    required this.isFavorite,
  });

  @override
  State<ProdutoDetalheScreen> createState() => _ProdutoDetalheScreenState();
}

class _ProdutoDetalheScreenState extends State<ProdutoDetalheScreen> {
  Item get item => widget.item;

  ValueNotifier<int> quantityNotifier = ValueNotifier<int>(0);

  late bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            text: 'Brownie ',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: item.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          //FavoriteButton(item: item),
          IconButton(
            onPressed: () async {
              setState(() {
                isFavorite = !isFavorite;
              });
              if (isFavorite) {
                await addFavoriteIndex(item.name);
              } else {
                await removeFavoriteIndex(item.name);
              }
            },
            isSelected: isFavorite,
            selectedIcon: const Icon(Icons.favorite_outlined),
            icon: const Icon(Icons.favorite_border_outlined),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Hero(
                        tag: item.name,
                        child: SimpleShadow(
                          opacity: 0.5,
                          color: Colors.pink[200]!,
                          offset: const Offset(2, 3),
                          sigma: 10,
                          child: item.image,
                        ),
                      ),
                    ),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xfffc9f14),
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '5.0',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Peso',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.weight}g',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.delivery} min',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 8),
                    BlocBuilder<CartCubit, List<CartItem>>(
                      builder: (context, cartItems) {
                        quantityNotifier.value = cartItems
                            .firstWhere(
                              (cartItem) => cartItem.item.name == item.name,
                              orElse: () => CartItem(
                                item: item,
                                quantity: 0,
                              ),
                            )
                            .quantity;
                        return Column(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: quantityNotifier,
                              builder: (context, value, child) {
                                return value >= 1
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
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
                                                context
                                                    .read<CartCubit>()
                                                    .removeItem(
                                                      item,
                                                    );
                                              },
                                              icon: Icon(
                                                Icons.remove,
                                                color: Colors.pink[200],
                                              ),
                                            ),
                                            Text(
                                              value.toString(),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.pink[200],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<CartCubit>()
                                                    .addItem(
                                                      item,
                                                    );
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.pink[200],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Colors.pink[200]!),
                                          ),
                                          onPressed: () {
                                            context.read<CartCubit>().addItem(
                                                  item,
                                                );
                                          },
                                          icon: Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Colors.pink[200],
                                          ),
                                          label: Text(
                                            'Adicionar',
                                            style: TextStyle(
                                              color: Colors.pink[200],
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (quantityNotifier.value >= 1) {
                                    Navigator.pop(context);
                                    context
                                        .read<CurrentProductIndexCubit>()
                                        .changeIndex(2);
                                  } else {
                                    Navigator.pop(context);
                                    context.read<CartCubit>().addItem(
                                          item,
                                        );
                                    context
                                        .read<CurrentProductIndexCubit>()
                                        .changeIndex(2);
                                  }
                                },
                                child: const Text(
                                  'Comprar Agora',
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
