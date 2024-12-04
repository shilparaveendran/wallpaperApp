import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageProviderModel extends ChangeNotifier {
  final String _baseUrl = 'https://api.slingacademy.com/v1/sample-data/photos';
  List<dynamic> _images = [];
  int _page = 1;
  bool _isLoading = false;

  List<dynamic> get images => _images;

  bool get isLoading => _isLoading;

  Future<void> fetchImages() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_baseUrl?page=$_page&limit=15');

    try {
      final response = await http.get(url);
      print('Requesting URL: $url');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');
        _images.addAll(data['photos']);
        _page++;
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
