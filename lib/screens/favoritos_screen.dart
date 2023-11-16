import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/model/model.dart';
import 'package:malukas/data/provider/notifiers.dart';
import 'package:malukas/screens/produto_detalhe_screen.dart';
import 'package:malukas/utils/functions.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: FutureBuilder<List<Item>>(
        future: getFavoriteItens(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var favoriteItens = snapshot.data!;
            if (favoriteItens.isEmpty) {
              return const Center(
                child: Text('Nenhum item favoritado'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItens.length,
              itemBuilder: (context, index) {
                var item = favoriteItens[index];
                return Container(
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
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builderContext) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<CartCubit>(),
                                ),
                                BlocProvider.value(
                                  value:
                                      context.read<CurrentProductIndexCubit>(),
                                ),
                              ],
                              child: ProdutoDetalheScreen(
                                item: item,
                                isFavorite: true,
                              ),
                            ),
                          ),
                        );
                        setState(() {});
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
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.pink[200]!,
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Aviso'),
                                content: const Text(
                                  'Deseja remover este item dos favoritos?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Não'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await removeFavoriteIndex(item.name);
                                      if (mounted) {
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    },
                                    child: const Text('Sim'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
