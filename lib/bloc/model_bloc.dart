import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/song.dart';
import '../services/music_service.dart';

// Eventos
abstract class MusicEvent {}

class LoadSongsEvent extends MusicEvent {}

class PlayPauseEvent extends MusicEvent {}

class NextSongEvent extends MusicEvent {}

class PreviousSongEvent extends MusicEvent {}

class MusicEventSelectSong extends MusicEvent {
  final int selectedIndex;

  MusicEventSelectSong(this.selectedIndex);
}

// Estados
class MusicState {
  final bool isPlaying;
  final int currentSongIndex;
  final List<Song>? songs;
  final bool isLoading;
  final String errorMessage;

  MusicState({
    required this.isPlaying,
    required this.currentSongIndex,
    this.songs,
    this.isLoading = false,
    this.errorMessage = '',
  });

  MusicState copyWith({
    bool? isPlaying,
    int? currentSongIndex,
    List<Song>? songs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MusicState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicService musicService;

  MusicBloc({required this.musicService}) : super(MusicState(isPlaying: false, currentSongIndex: 0)) {
    on<LoadSongsEvent>(_onLoadSongs);
    on<PlayPauseEvent>(_onPlayPause);
    on<NextSongEvent>(_onNextSong);
    on<PreviousSongEvent>(_onPreviousSong);
    on<MusicEventSelectSong>(_onSelectSong);
  }

  // Cargar canciones
  Future<void> _onLoadSongs(LoadSongsEvent event, Emitter<MusicState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final songs = await musicService.fetchSongs();
      emit(state.copyWith(isLoading: false, songs: songs));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // Evento de Play/Pause
  void _onPlayPause(PlayPauseEvent event, Emitter<MusicState> emit) {
    emit(state.copyWith(isPlaying: !state.isPlaying));
  }

  // Evento de siguiente canción
  void _onNextSong(NextSongEvent event, Emitter<MusicState> emit) {
    final nextIndex = (state.currentSongIndex + 1) % (state.songs?.length ?? 1);
    emit(state.copyWith(currentSongIndex: nextIndex));
  }

  // Evento de canción anterior
  void _onPreviousSong(PreviousSongEvent event, Emitter<MusicState> emit) {
    final prevIndex = (state.currentSongIndex - 1 + (state.songs?.length ?? 1)) % (state.songs?.length ?? 1);
    emit(state.copyWith(currentSongIndex: prevIndex));
  }

  // Evento de selección de canción
  void _onSelectSong(MusicEventSelectSong event, Emitter<MusicState> emit) {
    emit(state.copyWith(currentSongIndex: event.selectedIndex));
  }
}
