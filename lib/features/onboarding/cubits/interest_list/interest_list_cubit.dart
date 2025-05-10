import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/repository/user_repo.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';

part 'interest_list_cubit.freezed.dart';
part 'interest_list_state.dart';

class InterestCubit extends Cubit<InterestListState> {
  InterestCubit()
      : _inventoryRepo = locator<InventoryRepo>(),
        _userRepository = locator.get<UserRepository>(),
        super(const InterestListState.initial());

  late final InventoryRepo _inventoryRepo;
  late final UserRepository _userRepository;
  List<ProductCategory> interestsList = [];

  Future<void> getInterests() async {
    emit(const InterestListState.loading());
    final response = await _inventoryRepo.getProductCategories();
    response.when(
      success: (interests) {
        interestsList = interests?.data ?? [];
        emit(InterestListState.loaded(interests?.data ?? []));
      },
      error: (error) {
        emit(InterestListState.error(error.message ?? 'An error occurred'));
      },
    );
  }

  Future<void> saveInterest(List<String> list) async {
    emit(const InterestListState.loading());
    final response = await _userRepository.saveInterest(list);
    response.when(
      success: (interests) {
        emit(const InterestListState.saveInterestSuccess());
      },
      error: (error) {
        emit(
          InterestListState.saveInterestFailure(
            error.message ?? 'An error occurred',
          ),
        );
      },
    );
  }
}
