import 'package:flutter/material.dart';
//import 'package:my_app_1/korean_gemini.dart';
import 'package:my_app_1/korean_tracer_page.dart';

class KhitHrtBiePage extends StatefulWidget {
  const KhitHrtBiePage({super.key});

  @override
  State<KhitHrtBiePage> createState() => _KhitHrtBiePageState();
}

class _KhitHrtBiePageState extends State<KhitHrtBiePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khittt hrtttt Bieee🫠🫠'),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Khittt hrttt mar kae 🥰🐶');
            },
            icon: Icon(Icons.favorite),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Column(
        children: [
          Image.asset('images/BJ.jpg'),
          const SizedBox(height: 60),
          //const Divider(color: Colors.amber),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amber,
            ),
            child: const Text(
              'Khittt hrttt mar kae 🥰🐶',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const KoreanTracerPage();
                  },
                ),
              );
            },
            child: const Text('Learning Korean', 
            style: TextStyle(color: Colors.black,),),
          ),
        ],
      ),
    );
  }
}
