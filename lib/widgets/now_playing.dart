import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../bloc/get_movie_videos_bloc.dart';
import '../bloc/get_now_playing_bloc.dart';
import '../model/movie.dart';
import '../model/movie_response.dart';
import '../model/video.dart';
import '../model/video_response.dart';
import '../pages/video_player.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    nowPlayingMoviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildHomeWidget(snapshot.data as MovieResponse);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildHomeWidget(MovieResponse data) {
    List<Movie> movies = data.movies;

    if (movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              ImageProvider<Object> imageProvider;

              if (movies[index].backposter == null) {
                imageProvider = const AssetImage('images/default-movie.png');
              } else {
                imageProvider = CachedNetworkImageProvider(
                  'https://image.tmdb.org/t/p/original/${movies[index].backposter}',
                );
              }
              movieVideosBloc..getMovieVideos(movies[index].id);
              return StreamBuilder<VideoResponse>(
                stream: movieVideosBloc.subject.stream,
                builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.error.isNotEmpty) {
                      return _buildErrorWidget(snapshot.data!.error);
                    }
                    return _buildVideoWidget(
                        data: snapshot.data as VideoResponse,
                        movies: movies,
                        imageProvider: imageProvider,
                        index: index);
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  } else {
                    return _buildLoadingWidget();
                  }
                },
              );
            },
          ),
        ),
      );
    }
  }

  Widget _buildVideoWidget(
      {required VideoResponse data,
      required List<Movie> movies,
      required ImageProvider<Object> imageProvider,
      required int index}) {
    List<Video> videos = data.videos;
    return GestureDetector(
      onTap: () {
        if (videos.length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                controller: YoutubePlayerController(
                  initialVideoId: videos[0].key,
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: true,
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: Stack(
        children: <Widget>[
          Hero(
            tag: movies[index].id,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 220.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [
                    0.0,
                    0.9
                  ],
                  colors: [
                    Colors.black87.withOpacity(1.0),
                    Colors.transparent.withOpacity(0.0)
                  ]),
            ),
          ),
          const Positioned(
            bottom: 0.0,
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Icon(
              Icons.play_arrow,
              color: Colors.yellowAccent,
              size: 40.0,
            ),
          ),
          Positioned(
              bottom: 30.0,
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movies[index].title ?? "",
                      style: const TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
    ;
  }
}
