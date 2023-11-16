import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/model/model.dart';
import 'package:malukas/data/provider/notifiers.dart';
import 'package:malukas/screens/favoritos_screen.dart';
import 'package:malukas/screens/home_screen.dart';
import 'package:malukas/screens/sacola_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentProductIndexCubit, int>(
      builder: (context, indexCubit) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          body: SafeArea(
            child: [
              const HomeScreen(),
              const FavoritosScreen(),
              const SacolaScreen(),
            ][indexCubit],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: indexCubit,
            onDestinationSelected: (index) {
              context.read<CurrentProductIndexCubit>().changeIndex(index);
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Início',
              ),
              const NavigationDestination(
                icon: Icon(Icons.favorite_border_outlined),
                label: 'Favoritos',
              ),
              NavigationDestination(
                icon: BlocBuilder<CartCubit, List<CartItem>>(
                  builder: (context, cartItems) {
                    return cartItems.isNotEmpty
                        ? Badge(
                            label: Text(cartItems.length.toString()),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                          );
                  },
                ),
                label: 'Sacola',
              ),
            ],
          ),
        );
      },
    );
  }
}
