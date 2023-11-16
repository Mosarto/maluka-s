import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/model/model.dart';
import 'package:malukas/data/provider/mock.dart';
import 'package:malukas/data/provider/notifiers.dart';
import 'package:malukas/screens/produto_detalhe_screen.dart';
import 'package:malukas/utils/functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          SearchAnchor(
            builder: (
              BuildContext searchAnchorContext,
              SearchController controller,
            ) {
              return SearchBar(
                focusNode: _focusNode,
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.white,
                ),
                surfaceTintColor: MaterialStateColor.resolveWith(
                  (states) => Colors.white,
                ),
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                shadowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.pink[200]!,
                ),
                elevation: const MaterialStatePropertyAll<double>(5.0),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                hintText: 'Pesquisar',
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (
              BuildContext suggestionsBuilderContext,
              SearchController controller,
            ) {
              List<Item> searchItens = itens
                  .where(
                    (item) => item.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()),
                  )
                  .toList();
              return List<ListTile>.generate(
                searchItens.length,
                (int index) {
                  var item = searchItens[index];
                  return ListTile(
                    onTap: () async {
                      controller.closeView(item.name);
                      controller.clear();
                      List<String> favoriteIndex = await getFavoriteIndex();
                      if (!mounted) return;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builderContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<CartCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<CurrentProductIndexCubit>(),
                              ),
                            ],
                            child: ProdutoDetalheScreen(
                              item: itens[index],
                              isFavorite: favoriteIndex.contains(
                                itens[index].name,
                              ),
                            ),
                          ),
                        ),
                      );
                      _focusNode.unfocus();
                    },
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag: item.name,
                          child: item.image,
                        ),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text(
                      formatPrice(item.price),
                      style: TextStyle(
                        color: Colors.pink[300],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 0,
              color: Colors.pink[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Brownies\n',
                        style: TextStyle(
                          height: 1.4,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: 'Entrega Rápida\n',
                            style: TextStyle(
                              height: 1.4,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: 'Até 70% OFF',
                            style: TextStyle(
                              height: 1.4,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/brownie.png',
                      height: 140,
                      scale: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          //Produtos gridview
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itens.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
            ),
            itemBuilder: (itemContext, index) {
              return BlocBuilder<CartCubit, List<CartItem>>(
                builder: (contextBloc, cartItems) {
                  int quantity = cartItems
                      .where(
                          (cartItem) => cartItem.item.name == itens[index].name)
                      .fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.quantity);

                  return InkWell(
                    onTap: () async {
                      List<String> favoriteIndex = await getFavoriteIndex();
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builderContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: contextBloc.read<CartCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<CurrentProductIndexCubit>(),
                              ),
                            ],
                            child: ProdutoDetalheScreen(
                              item: itens[index],
                              isFavorite: favoriteIndex.contains(
                                itens[index].name,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.pink[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: itens[index].name,
                                  child: itens[index].image,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itens[index].name,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                formatPrice(itens[index].price),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pink[300],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          quantity > 0
                              ? Container(
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
                                          contextBloc
                                              .read<CartCubit>()
                                              .removeItem(
                                                itens[index],
                                              );
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.pink[200],
                                        ),
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.pink[200],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          contextBloc.read<CartCubit>().addItem(
                                                itens[index],
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
                                      side:
                                          BorderSide(color: Colors.pink[200]!),
                                    ),
                                    onPressed: () {
                                      contextBloc.read<CartCubit>().addItem(
                                            itens[index],
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
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
