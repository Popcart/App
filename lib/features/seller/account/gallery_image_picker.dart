import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImagePicker extends StatefulWidget {
  const GalleryImagePicker({required this.onImageSelected, super.key});

  final void Function(AssetEntity image) onImageSelected;

  @override
  State<GalleryImagePicker> createState() => _GalleryImagePickerState();
}

class _GalleryImagePickerState extends State<GalleryImagePicker> {
  List<AssetEntity> images = [];

  @override
  void initState() {
    super.initState();
    loadGalleryImages();
  }

  Future<void> loadGalleryImages() async {
    try {
      await PhotoManager.requestPermissionExtend();

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
        onlyAll: true,
      );
      if (albums.isEmpty) return;
      final recentAlbum = albums.first;
      final assets = await recentAlbum.getAssetListPaged(page: 0, size: 100);

      setState(() => images = assets);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (_, index) {
        return FutureBuilder<Uint8List?>(
          future: images[index]
              .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
          builder: (_, snapshot) {
            final data = snapshot.data;
            if (data == null) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () => widget.onImageSelected(images[index]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  data,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
