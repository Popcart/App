import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class SelectInterestsScreen extends HookWidget {
  const SelectInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        context.read<InterestListCubit>().getInterests();
        return null;
      },
      const [],
    );
    final interests = context.watch<InterestListCubit>();
    final selectedInterests = useState(<ProductCategory>[]);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              const SizedBox(height: 32),
              Text(
                l10n.select_interests,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: interests.state.maybeWhen(
                  loaded: (data) => data
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ChoiceChip(
                            selectedColor: AppColors.orange,
                            showCheckmark: false,
                            backgroundColor: const Color(0xff24262b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                color: selectedInterests.value.contains(e)
                                    ? AppColors.orange
                                    : const Color(0xff50535b),
                              ),
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                            label: Text(
                              e.name,
                            ),
                            selected: selectedInterests.value.contains(e),
                            onSelected: (value) {
                              if (value) {
                                selectedInterests.value = [
                                  ...selectedInterests.value,
                                  e,
                                ];
                              } else {
                                selectedInterests.value = selectedInterests
                                    .value
                                    .where((element) => element != e)
                                    .toList();
                              }
                            },
                          ),
                        ),
                      )
                      .toList(),
                  orElse: () => const [],
                ),
              ),
              const SizedBox(height: 32),
              IgnorePointer(
                ignoring: selectedInterests.value.isEmpty,
                child: AnimatedOpacity(
                  opacity: selectedInterests.value.isEmpty ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: BouncingEffect(
                    onTap: () => context.go(AppPath.authorizedUser.live.path),
                    child: CustomElevatedButton(
                      text: l10n.next,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
