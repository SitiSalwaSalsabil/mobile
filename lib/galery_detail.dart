import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'photo_list.dart';  // Import halaman photo_list.dart untuk menampilkan daftar foto

class GaleryDetailScreen extends StatefulWidget {
  final int galeryId;

  GaleryDetailScreen({required this.galeryId});

  @override
  _GaleryDetailScreenState createState() => _GaleryDetailScreenState();
}

class _GaleryDetailScreenState extends State<GaleryDetailScreen> {
  dynamic _galeryDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGaleryDetail();
  }

  Future<void> _fetchGaleryDetail() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/ujikom-master1/public/api/galery/${widget.galeryId}'));
      print('Response body: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        setState(() {
          _galeryDetail = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load galery details');
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
        title: Text('Detail Galeri'),
        backgroundColor: Color.fromARGB(255, 181, 218, 248),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _galeryDetail == null
              ? Center(child: Text('No details found'))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _galeryDetail['judul'] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 26, 51, 94),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _galeryDetail['deskripsi'] ?? 'No Description',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Photos:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 26, 51, 94),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _galeryDetail['photos'].length,
                          itemBuilder: (context, index) {
                            final photo = _galeryDetail['photos'][index];
                            final photoUrl = photo['isi_photo'] ?? '';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: photoUrl.isNotEmpty
                                    ? Image.network(
                                        photoUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        height: 200,
                                        child: Center(child: Text('No Image')),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Tambahkan link untuk navigasi ke halaman lain
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoListScreen(photos: _galeryDetail['photos']),
                              ),
                            );
                          },
                          child: Text('Lihat foto lainnya'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
