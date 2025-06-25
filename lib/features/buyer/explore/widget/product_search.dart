import 'dart:convert';

import 'package:extended_image/extended_image.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:popcart/features/components/network_image.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/live/models/similar_product.dart';
import 'package:popcart/route/route_constants.dart';

class ProductSearch extends StatefulWidget {
  final XFile file;

  const ProductSearch({super.key, required this.file});

  @override
  State<ProductSearch> createState() => _InterestFilterState();
}

class _InterestFilterState extends State<ProductSearch> {
  Future<List<SimilarProduct>> uploadImage() async {
    try {
      final uri = Uri.parse(
          'https://intelligence-0o5n.onrender.com/search-similar?top_k=5');
      final request = http.MultipartRequest('POST', uri);

      final mimeType = lookupMimeType(widget.file.path)?.split('/');
      final file = await http.MultipartFile.fromPath(
        'image',
        widget.file.path,
        contentType:
            mimeType != null ? MediaType(mimeType[0], mimeType[1]) : null,
      );

      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['top_matches'] as List;
        return list
            .map(
                (item) => SimilarProduct.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text('Similar Products Available',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: uploadImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()]),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 16,
                              mainAxisExtent: 150),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) =>
                          productItem(snapshot.data![index])),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget productItem(SimilarProduct product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, productScreen,
            arguments: product.productId);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 100,
              child: NetworkImageWithLoader(
                product.imageUrl,
                radius: 5,
              )),
          const SizedBox(height: 8),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
