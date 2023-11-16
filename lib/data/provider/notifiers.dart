import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/model/model.dart';

class CurrentProductIndexCubit extends Cubit<int> {
  CurrentProductIndexCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  void addItem(Item item) {
    var foundItem = state.firstWhere(
      (cartItem) => cartItem.item.name == item.name,
      orElse: () => CartItem(item: item, quantity: 0),
    );

    if (foundItem.quantity == 0) {
      emit([...state, CartItem(item: item, quantity: 1)]);
    } else {
      emit(state.map((cartItem) {
        if (cartItem.item.name == item.name) {
          return CartItem(item: item, quantity: cartItem.quantity + 1);
        }
        return cartItem;
      }).toList());
    }
  }

  void removeItem(Item item) {
    var foundItem = state.firstWhere(
      (cartItem) => cartItem.item.name == item.name,
      orElse: () => CartItem(item: item, quantity: 0),
    );
    if (foundItem.quantity > 1) {
      emit(state.map((cartItem) {
        if (cartItem.item.name == item.name) {
          return CartItem(item: item, quantity: cartItem.quantity - 1);
        }
        return cartItem;
      }).toList());
    } else {
      emit(state.where((cartItem) => cartItem.item.name != item.name).toList());
    }
  }

  void clear() {
    emit([]);
  }

  double get total {
    return state.fold(
      0,
      (previousValue, cartItem) =>
          previousValue + cartItem.item.price * cartItem.quantity,
    );
  }
}
