import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            AppAssets.images.box.image(),
            SizedBox(height: 10,),
            const Text("Looks like you haven’t added any products yet. Add products to start tracking and selling efficiently.",
            textAlign: TextAlign.center,
            style: TextStyles.titleHeading,),
            const Spacer(),
            CustomElevatedButton(
              text: "Add Product", onPressed: () {
              context.pushNamed(
                AppPath.authorizedUser.seller.inventory.addProduct.path,
              );
            },
            )
          ],
        ),
      ),
    );
  }
}
