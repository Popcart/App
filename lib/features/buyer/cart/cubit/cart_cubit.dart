import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/cart_repo.dart';
import 'package:popcart/core/repository/transaction_repo.dart';
import 'package:popcart/core/repository/wallet_repo.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/live/models/cart_item_model.dart';
import 'package:popcart/features/webview/webview_screen.dart';

part 'cart_state.dart';

part 'cart_cubit.freezed.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : cartRepo = locator.get<CartRepo>(),
        super(const CartState.initial());

  final CartRepo cartRepo;
  final TransactionRepo transactionRepo = locator.get<TransactionRepo>();
  final WalletRepo walletRepo = locator.get<WalletRepo>();

  Future<void> getCart({bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(const CartState.loading());
      }
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

  Future<void> processPayment(Map<String, dynamic> data) async {
    try {
      emit(const CartState.processingOrder());
      final pref = locator<SharedPrefs>();
      final transactionRef = generateTransactionRef(pref.userUid);
      final map = {
        'userId': pref.userUid,
        'reference': transactionRef,
        'amount': data['amount'],
        'email': pref.email,
        'source': data['paymentOption'],
        'meta': {
          'cart': data['cart'],
          'deliveryAddress': data['deliveryAddress'],
          'recipientName': pref.username,
          'recipientPhone': data['recipientPhone'],
          'fulfilledBy': 'popcart',
        },
      };
      final createTransactionResponse = await transactionRepo.createTransaction(
        data: map,
      );
      await createTransactionResponse.when(
        success: (result) async {
          if (data['paymentOption'] == 'interswitch') {
            final navResponse = await Navigator.push(
              Get.context!,
              MaterialPageRoute<bool?>(
                builder: (context) => WebViewScreen(
                  txnRef: transactionRef,
                  amount: data['amount'],
                  paymentLink:
                      'https://newwebpay.qa.interswitchng.com/collections/w/pay',
                ),
              ),
            );
            if (navResponse != null && navResponse == true) {
              await cartRepo.clearCart(userId: pref.userUid);
              await updateTransaction({
                'reference': transactionRef,
                'source': data['paymentOption'],
                'status': 'success',
              });
              emit(const CartState.orderProcessed());
            } else {
              await updateTransaction({
                'reference': transactionRef,
                'source': data['paymentOption'],
                'status': 'failed',
              });
              emit(
                const CartState.processingOrderError(
                  'Unable to complete transaction',
                ),
              );
            }
          } else if (data['paymentOption'] == 'paystack') {
            ///Paystack integration here
            final navResponse = await Navigator.push(
              Get.context!,
              MaterialPageRoute<bool>(
                builder: (context) => WebViewScreen(
                  txnRef: transactionRef,
                  amount: data['amount'],
                  paymentLink: result?.data?['authorization_url'] as String,
                ),
              ),
            );
            if (navResponse != null && navResponse == true) {
              await cartRepo.clearCart(userId: pref.userUid);
              await updateTransaction({
                'reference': transactionRef,
                'source': data['paymentOption'],
                'status': 'success',
              });
              emit(const CartState.orderProcessed());
            } else {
              await updateTransaction({
                'reference': transactionRef,
                'source': data['paymentOption'],
                'status': 'failed',
              });
              emit(
                const CartState.processingOrderError(
                  'Unable to complete transaction',
                ),
              );
            }
          } else {
            ///Wallet integration here
            final debitResponse = await walletRepo.debitWallet(
              map: {
                'userId': pref.userUid,
                'amount': data['amount'],
                'type': 'purchase',
                'source': 'wallet',
                'destination': 'system',
                'transactionId': transactionRef,
              },
            );
            await debitResponse.when(
              success: (result) async {
                await cartRepo.clearCart(userId: pref.userUid);
                emit(const CartState.orderProcessed());
              },
              error: (message) {
                emit(
                  CartState.processingOrderError(
                    message.message ?? 'An error occurred',
                  ),
                );
              },
            );
          }
        },
        error: (e) {
          emit(
            CartState.processingOrderError(
              e.message ?? 'An error occurred',
            ),
          );
        },
      );
    } catch (_) {}
  }

  Future<void> updateTransaction(Map<String, dynamic> map) async {
    await transactionRepo.updateTransaction(data: map);
  }
}
