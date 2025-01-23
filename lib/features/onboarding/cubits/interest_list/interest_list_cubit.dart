import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

part 'interest_list_cubit.freezed.dart';
part 'interest_list_state.dart';

class InterestListCubit extends Cubit<InterestListState> {
  InterestListCubit()
      : _inventoryRepo = locator<InventoryRepo>(),
        super(const InterestListState.initial());

  late final InventoryRepo _inventoryRepo;

  Future<void> getInterests() async {
    emit(const InterestListState.loading());
    final response = await _inventoryRepo.getProductCategories();
    response.when(
      success: (interests) {
        emit(InterestListState.loaded(interests?.data ?? []));
      },
      error: (error) {
        emit(InterestListState.error(error.message ?? 'An error occurred'));
      },
    );
  }
}
