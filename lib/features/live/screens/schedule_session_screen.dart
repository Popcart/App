import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/bouncing_effect_widget.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class ScheduleSessionScreen extends HookWidget {
  const ScheduleSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final openLivestream = context.watch<OpenLivestreamCubit>();
    final generatedLiveStream = useState<Stream?>(null);
    final livestreamTitleController = useTextEditingController();
    final startTimeController = useTextEditingController();
    final isScheduled = useState(false);
    final startTime = useState<DateTime?>(null);
    final productIds = useState<List<String>>([]);
    final selectDate = useCallback(() async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      );
      if (selectedDate != null && context.mounted) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          startTime.value = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          startTimeController.text = startTime.value!.toString();
        }
      }
    });
    final selectProducts = useCallback(() async {
      if (livestreamTitleController.text.isEmpty) {
        await context.showError('Please enter a title');
        return;
      }
      if (isScheduled.value && startTime.value == null) {
        await context.showError('Please select a start time');
        return;
      }
      final ids = await context.pushNamed<List<String>>(
        AppPath.authorizedUser.live.selectProducts.path,
      );
      if (ids != null) {
        productIds.value = ids;
        await openLivestream.createLivestreamSession(
          name: livestreamTitleController.text,
          products: productIds.value,
          scheduled: isScheduled.value,
        );
      }
    });
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: BouncingEffect(
          onTap: selectProducts,
          child: CustomElevatedButton(
            text: productIds.value.isEmpty
                ? l10n.select_products
                : isScheduled.value
                    ? l10n.schedule_livestream
                    : l10n.go_live,
            loading: openLivestream.state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            ),
          ),
        ),
      ),
      body: BlocListener<OpenLivestreamCubit, OpenLivestreamState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (liveStream) {
              generatedLiveStream.value = liveStream;
              openLivestream.generateAgoraToken(
                channelName: liveStream.id,
                agoraRole: 0,
                uid: 0,
              );
            },
            error: (message) {
              context.showError(message);
            },
            generateTokenSuccess: (token) {
              context.pushReplacementNamed(
                AppPath.authorizedUser.live.sellerLivestream.path,
                extra: true,
                queryParameters: {
                  'token': token,
                  'channelName': generatedLiveStream.value?.id,
                },
              );
            },
            generateTokenError: (message) {
              context.showError(message);
            },
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackButton(),
                const SizedBox(height: 32),
                Text(
                  l10n.start_a_livestream,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: livestreamTitleController,
                  hintText: l10n.livestream_title,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 24),
                ...[false, true].map((e) {
                  return RadioListTile<bool>(
                    title: Text(e ? l10n.schedule_livestream : l10n.go_live),
                    value: e,
                    groupValue: isScheduled.value,
                    onChanged: (value) {
                      isScheduled.value = value!;
                    },
                  );
                }),
                const SizedBox(height: 24),
                if (isScheduled.value)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: selectDate,
                    child: IgnorePointer(
                      child: CustomTextFormField(
                        controller: startTimeController,
                        hintText: l10n.start_time,
                        enabled: false,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
