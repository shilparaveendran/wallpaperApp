import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  const ImageDetailPage({required this.imageUrl, super.key});

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    if (Platform.isAndroid) {
      // Request required permissions
      final storagePermission = await Permission.storage.request();
      if (!storagePermission.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required')),
        );
        return;
      }
    }

    try {
      final directory = Directory('/storage/emulated/0/Pictures'); // Pictures directory
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final dio = Dio();
      await dio.download(imageUrl, filePath);

      // Notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image downloaded to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 500,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () => downloadImage(context, imageUrl),
                  child: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
