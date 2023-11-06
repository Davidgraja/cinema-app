import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListView(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListView> createState() =>
      _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
   
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(children: [
        if (widget.title != null || widget.subTitle != null)
          _Header(
            title: widget.title,
            subTitle: widget.subTitle,
          ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FadeInRight(
                child: _Slide(movie: widget.movies[index])
              );
            },
          ),
        )
      ]),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push('/home/0/movie/${movie.id}'),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * imagen
              SizedBox(
                width: 150,
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholderFit: BoxFit.cover,
                    fit: BoxFit.cover,
                    placeholder: const  AssetImage('assets/images/fade-loading.gif'),
                    image: NetworkImage(movie.posterPath) ,
                  )
                ),
              ),
    
              const SizedBox(
                height: 5,
              ),
    
              //* Title slider
              SizedBox(
                width: 150,
                child: Text(
                  movie.title,
                  style: textStyles.titleSmall,
                  maxLines: 2,
                ),
              ),
    
              //* Rating
              SizedBox(
                width: 150,
                child: Row(
                  children: [
                    Icon(
                      Icons.star_half_outlined,
                      color: Colors.yellow.shade800,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${movie.voteAverage}',
                      style: textStyles.bodyMedium
                          ?.copyWith(color: Colors.yellow.shade800),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Spacer(),
                    Text(HumanFormats.humanReadbledNumber(movie.popularity),
                        style: textStyles.bodySmall),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class _Header extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _Header({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subTitle != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colors.inversePrimary),
              child: Text(subTitle!),
            )
        ],
      ),
    );
  }
}
