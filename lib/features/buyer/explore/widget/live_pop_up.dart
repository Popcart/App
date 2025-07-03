import 'package:flutter/material.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class LivePopUp extends StatefulWidget {
  const LivePopUp({super.key});

  @override
  State<LivePopUp> createState() => _LivePopUpState();
}

class _LivePopUpState extends State<LivePopUp> {
  ValueNotifier<bool> isChecked = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.images.designerBag.path,
              scale: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Get Ready to Shop Live!',
              textAlign: TextAlign.center,
              style: TextStyles.heading,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Make sure your wallet is funded or your card is ready before'
                  ' entering the live room for a smooth checkout.',
              style: TextStyles.titleHeading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isChecked,
              builder: (BuildContext context, bool value, Widget? child) {
                return Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        onChanged: (bool? value) {
                          isChecked.value = value!;
                        },
                        value: value,
                        checkColor: AppColors.white,
                        activeColor: AppColors.orange,
                        side: const BorderSide(
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'Do not show this message again',
                      style: TextStyles.body.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              onPressed: () {
                locator<SharedPrefs>().showFundWalletDialog = !isChecked.value;
                Navigator.pop(context);
              },
              text: 'Fund Wallet/Add Card',
              showIcon: false,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
                locator<SharedPrefs>().showFundWalletDialog = !isChecked.value;
                Navigator.pop(context);
              },
              child: Text(
                'or continue anyway',
                style: TextStyles.textTitle.copyWith(color: AppColors.orange),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
