import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GaleryScreen extends StatefulWidget {
  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  List<dynamic> _galleryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGalleryData();
  }

  Future<void> _fetchGalleryData() async {
    try {
      // Replace this with your API URL
      final response = await http.get(Uri.parse('http://10.0.2.2/ujikom-master1/public/api/galery'));
      print('Response body: ${response.body}');  // Debugging line

      if (response.statusCode == 200) {
        setState(() {
          _galleryItems = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load gallery');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeri SMKN 4 Bogor'),
        backgroundColor: Color.fromARGB(255, 181, 218, 248),
      ),
      body: Container(
        color: Color.fromARGB(255, 141, 203, 255),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Galeri',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 26, 51, 94),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dokumentasi foto dan video kegiatan sekolah',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _galleryItems.isEmpty
                    ? Expanded(child: Center(child: Text('No items found')))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _galleryItems.length,
                          itemBuilder: (context, index) {
                            final item = _galleryItems[index];
                            final title = item['judul'] ?? 'No Title';
                            final description = item['deskripsi'] ?? 'No Description';
                            final photos = item['photos'] ?? [];

                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 1, 5, 12),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 60, 60, 60),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: List.generate(
                                        (photos.length > 3 ? 3 : photos.length),
                                        (i) {
                                          final photoUrl = photos[i]['isi_photo'] ?? '';
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: photoUrl.isNotEmpty
                                                  ? Image.network(
                                                      photoUrl,
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width: 80,
                                                      height: 80,
                                                      color: Colors.grey[300],
                                                      child: Center(child: Text('No Image')),
                                                    ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        // Add functionality for viewing more photos if needed
                                      },
                                      child: Text(
                                        'Lihat foto lainnya',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
