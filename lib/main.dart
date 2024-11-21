import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/bloc/model_bloc.dart'; 
import 'package:music_player/pages/home_page.dart'; 
import 'package:music_player/services/music_service.dart';  

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player Challenge',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => MusicBloc(musicService: MusicService())..add(LoadSongsEvent()),
        child: const HomePage(),
      ),
    );
  }
}
