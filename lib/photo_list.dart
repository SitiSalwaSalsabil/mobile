import 'package:flutter/material.dart';

class PhotoListScreen extends StatelessWidget {
  final List<dynamic> photos;

  PhotoListScreen({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Foto'),
        backgroundColor: Color.fromARGB(255, 181, 218, 248),
      ),
      body: photos.isEmpty
          ? Center(child: Text('No photos available'))
          : ListView.builder(
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                final photoUrl = photo['isi_photo'] ?? '';
                final photoTitle = photo['judul_photo'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: photoUrl.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photoTitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 26, 51, 94),
                                ),
                              ),
                              SizedBox(height: 10),
                              Image.network(
                                photoUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ],
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
    );
  }
}
