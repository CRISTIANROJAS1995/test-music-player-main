import '../models/song.dart';

class MusicService {

  Future<List<Song>> fetchSongs() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Song(
        title: 'Billie Jean',
        artist: 'Michael Jackson',
        duration: '4:54',
        imageUrl:
            'https://syspotec-test.s3.us-west-1.amazonaws.com/public/BillieJean.png',
      ),
      Song(
        title: 'Sweet Child o\' Mine',
        artist: 'Guns N\' Roses',
        duration: '5:56',
        imageUrl:
            'https://syspotec-test.s3.us-west-1.amazonaws.com/public/Sweet+Child.png',
      ),
      Song(
        title: 'Like a Prayer',
        artist: 'Madonna',
        duration: '5:41',
        imageUrl:
            'https://syspotec-test.s3.us-west-1.amazonaws.com/public/LikePrayer.png',
      ),
      Song(
        title: 'Smells Like Teen Spirit',
        artist: 'Nirvana',
        duration: '5:01',
        imageUrl:
            'https://syspotec-test.s3.us-west-1.amazonaws.com/public/SmellsLikeTeenSpirit.png',
      ),
      Song(
        title: 'Wonderwall',
        artist: 'Oasis',
        duration: '4:18',
        imageUrl:
            'https://syspotec-test.s3.us-west-1.amazonaws.com/public/Wonderwall.png',
      ),
    ];
  }
}
