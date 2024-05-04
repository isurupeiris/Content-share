import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final String text =
      'a function can be implemented that will make an url using the database that is deployed to the site ';
  final String assetImage = 'assets/image.png';
  final String urlImage =
      'https://durhamcollege.ca/wp-content/uploads/dc-banner-image-scaled.jpg';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "URL TEST-GROUND",
            style: TextStyle(
              fontSize: 24,
              color: Colors.greenAccent,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.yellow, Colors.blue],
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: buildBody(context),
        bottomNavigationBar: buildBottomAppBar(),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          shareButton('Share Link', () => Share.share(text)),
          decoratedImageContainer(assetImage),
          shareButton('Share placeholder from storage', () => sharePlaceholderFromAssets()),
          decoratedImageContainer(urlImage),
          shareButton('Share Placeholder from web', () => sharePlaceholderFromWeb()),
          shareButton('Share Placeholder from files', () => pickAndSharePlaceholder()),
        ],
      ),
    );
  }

  Widget shareButton(String title, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.yellowAccent.shade700,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget decoratedImageContainer(String imagePath) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imagePath.startsWith('http')
            ? Image.network(imagePath, fit: BoxFit.contain)
            : Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }

  Widget buildBottomAppBar() {
    return BottomAppBar(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.yellow, Colors.blue],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "P.I.P",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> sharePlaceholderFromAssets() async {
    final image = await rootBundle.load(assetImage);
    final buffer = image.buffer;
    Share.shareXFiles([
      XFile.fromData(
        buffer.asUint8List(image.offsetInBytes, image.lengthInBytes),
        name: 'Flutter Logo',
        mimeType: 'image/png',
      ),
    ], subject: 'Flutter Logo');
  }

  Future<void> sharePlaceholderFromWeb() async {
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    Share.shareXFiles([
      XFile.fromData(
        response.bodyBytes,
        name: 'Flutter 3',
        mimeType: 'image/png',
      ),
    ], subject: 'Flutter 3');
  }

  Future<void> pickAndSharePlaceholder() async {
    final imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      Uint8List uint8List = await imagePicker.readAsBytes();
      Share.shareXFiles([
        XFile.fromData(
          uint8List,
          name: 'Image Gallery',
          mimeType: 'image/png',
        ),
      ], subject: 'Image Gallery');
    }
  }
}
