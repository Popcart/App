import 'dart:convert';
import 'package:extended_image/extended_image.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class LocationBottomsheet extends StatefulWidget {
  const LocationBottomsheet({super.key});

  @override
  State<LocationBottomsheet> createState() => _LocationBottomsheetState();
}

class _LocationBottomsheetState extends State<LocationBottomsheet> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  ValueNotifier<List<String>> addresses = ValueNotifier([]);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<List<String>> fetchPlaceSuggestions() async {
    final link =
        Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {
      'input': searchController.text,
      'types': 'establishment|geocode',
      'key': 'AIzaSyDYxkdoCPdRSTXYPfjAodX4HpR2njHpKVA',
      'components': 'country:ng'
    });
    final response = await http.get(link);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final predictions = data['predictions'] as List;
      return predictions.map((p) => p['description'] as String).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<String?> getCurrentAddress() async {
    try {
      await Geolocator.requestPermission();
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        return null;
      }

      final position = await Geolocator.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }

      return null;
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text('Search Address',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          TextField(
            focusNode: focusNode,
            controller: searchController,
            onChanged: (value) async {
              if (value.isNotEmpty) {
                final locations = await fetchPlaceSuggestions();
                addresses.value = locations;
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter location',
              hintStyle:
                  const TextStyle(color: Color(0xffD7D8D9), fontSize: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: AppAssets.icons.search.svg(),
              ),
              fillColor: const Color(0xff24262B),
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              await getCurrentAddress().then((address) {
                if (address != null) {
                  Navigator.pop(context, address);
                } else {
                  context.showError('Unable to fetch current location');
                }
              });
            },
            child: Row(
              children: [
                AppAssets.icons.sendOrange.svg(),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Use your current location',
                  style:
                      TextStyles.titleHeading.copyWith(color: AppColors.orange),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ValueListenableBuilder(
            valueListenable: addresses,
            builder: (BuildContext context, List<String> value, Widget? child) {
              return Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(context, value[index]),
                      child: Row(
                        children: [
                          AppAssets.icons.location.svg(),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              value[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.subheading,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Divider(
                        thickness: 0.5,
                        color: AppColors.textFieldFillColor,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
