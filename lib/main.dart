// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:countryapp/data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  String flag = 'https://cdn-icons-png.flaticon.com/512/3638/3638361.png';
  String name = 'data';
  String capital = 'data';
  String region = 'data';
  String continent = 'data';
  String population = 'data';
  String url = 'flutter.com';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Country App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Введите страну', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: (){
                getData(controller.text);
              },
              child: const Icon(Icons.search),
            ),
            Image.network(flag, height: 50),
            InfoWidget(title: 'Официальное название', data: name),
            InfoWidget(title: 'Столица', data: capital),
            InfoWidget(title: 'Регион', data: region),
            InfoWidget(title: 'Численность населения', data: population),
            InfoWidget(title: 'Континент', data: continent),
            TextButton(onPressed: _launchUrl, child: const Icon(Icons.abc)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
  Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  Future<void> getData(String countryName) async {
   try{
     // ignore: unused_local_variable
    final Dio dio = Dio();
    final response = await dio
        .get('https://restcountries.com/v3.1/name/$countryName?fullText=true');

    List results = response.data;
    final result = DataModel.fromJson(results.first);
    // ignore: unused_local_variable
  //  final result = DataModel.fromJson(response.data);
  

     flag = result.flags?.png ??
        'https://cdn-icons-png.flaticon.com/512/3638/3638361.png';

    name = result.name?.official ?? 'data';
    capital = result.capital?.first ?? 'data';
    region = result.subregion ?? 'data';
    continent = '${result.population}';
    population = result.continents?.first ?? 'data';
    url = result.maps?.googleMaps?? 'flutter.dev';

    setState(() {});  
   }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      e.toString()
      ),
     ),
    );
   }
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const Spacer(),
          Text(
            data,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
