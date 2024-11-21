import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/models/song.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/model_bloc.dart';
import '../services/music_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MusicBloc(musicService: MusicService())..add(LoadSongsEvent()),
      child: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          final musicBloc = context.read<MusicBloc>();

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage.isNotEmpty) {
            return _buildErrorState(state.errorMessage);
          }

          final songList = state.songs ?? [];
          final currentSong =
              songList.isNotEmpty ? songList[state.currentSongIndex] : null;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Playlist'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: _buildSongList(songList, musicBloc, state),
                ),
                if (currentSong != null)
                  _buildPlayerControls(currentSong, musicBloc, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Text('Error: $errorMessage',
          style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildSongList(
      List<Song> songList, MusicBloc musicBloc, MusicState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: songList.length,
        itemBuilder: (context, index) {
          final song = songList[index];
          final isCurrentSong = state.currentSongIndex == index;

          return ListTile(
              tileColor: isCurrentSong ? Colors.blue[100] : null,
              onTap: () {
                musicBloc.add(MusicEventSelectSong(index));
              },
              leading: _buildSongImage(song.imageUrl),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(song.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    song.duration,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              subtitle: Text(song.artist));
        },
      ),
    );
  }

  Widget _buildSongImage(String imageUrl) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        alignment: Alignment.center,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmer(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: 60.0,
        height: 60.0,
      ),
    );
  }

  Widget _buildPlayerControls(
      Song currentSong, MusicBloc musicBloc, MusicState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                ),
                color: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                iconSize: 40,
                onPressed: () => musicBloc.add(PreviousSongEvent()),
              ),
              IconButton(
                icon: state.isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_circle_fill_rounded),
                onPressed: () => musicBloc.add(PlayPauseEvent()),
                color: const Color(0xFF015AFE),
                iconSize: 60,
                splashColor: const Color(0xFF015AFE).withOpacity(0.2),
                highlightColor: Colors.transparent,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                color: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                iconSize: 40,
                onPressed: () => musicBloc.add(NextSongEvent()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Shimmer _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }
}
