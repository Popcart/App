import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/cart_repo.dart';
import 'package:popcart/features/live/models/cart_item_model.dart';

part 'cart_state.dart';

part 'cart_cubit.freezed.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : cartRepo = locator.get<CartRepo>(),
        super(const CartState.initial());

  final CartRepo cartRepo;

  Future<void> getCart() async {
    try {
      emit(const CartState.loading());
      final userId = locator<SharedPrefs>().userUid;
      final response = await cartRepo.getCart(
        userId: userId,
      );
      response.when(
        success: (data) {
          emit(CartState.getCartSuccess(data?.data ?? []));
        },
        error: (e) {
          emit(
            CartState.getCartError(
              e.message ?? 'An error occurred',
            ),
          );
        },
      );
    } catch (_) {}
  }

  Future<void> addToCart(CartItemModel cartItem) async {
    try {
      emit(const CartState.addingToCart());
      final response = await cartRepo.addProductToCart(
        cartItem: cartItem,
      );
      response.when(
        success: (data) {
          emit(const CartState.cartAddedSuccess());
        },
        error: (e) {
          emit(
            CartState.cartAddingError(
              e.message ?? 'An error occurred',
            ),
          );
        },
      );
    } catch (_) {}
  }

  Future<void> updateCartItem(CartItemModel cartItem) async {
    try {
      final response = await cartRepo.updateCartItem(
        cartItem: cartItem,
      );
      response.when(
        success: (data) {
          emit(const CartState.updateCartSuccess());
        },
        error: (e) {
          emit(
            CartState.updateCartError(
              e.message ?? 'An error occurred',
            ),
          );
        },
      );
    } catch (_) {}
  }

  Future<void> deleteCartItem(CartItemModel cartItem) async {
    try {
      final response = await cartRepo.deleteCartItem(
        cartItem: cartItem,
      );
      response.when(
        success: (data) {
          getCart();
        },
        error: (e) {
          emit(
            CartState.updateCartError(
              e.message ?? 'An error occurred',
            ),
          );
        },
      );
    } catch (_) {}
  }
}
