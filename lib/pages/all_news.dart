import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/headline_model.dart';
import 'package:news_app/pages/articles_view.dart';
import 'package:news_app/services/news_service.dart';

class Newzz extends StatefulWidget {
  const Newzz({super.key, required this.news});

  final String news;

  @override
  State<Newzz> createState() => _AllNewsState();
}

class _AllNewsState extends State<Newzz> {
  List<ArticleModel> articles = [];
  List<HeadlineModel> headlines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.news == "Breaking") {
      getHeadlines();
    } else {
      getNews();
    }
  }

  void getNews() async {
    articles = await NewsService().getNews();
    setState(() {
      _isLoading = false;
    });
  }

  void getHeadlines() async {
    headlines = await NewsService().getTopHeadlines();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${widget.news} News",
          style: const TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemCount:
              widget.news == "Breaking" ? headlines.length : articles.length,
          itemBuilder: (ctx, idx) {
            return AllNewsSection(
              imageUrl: widget.news == "Breaking"
                  ? headlines[idx].urlToImage!
                  : articles[idx].urlToImage!,
              description: widget.news == "Breaking"
                  ? headlines[idx].description!
                  : articles[idx].description!,
              title: widget.news == "Breaking"
                  ? headlines[idx].title!
                  : articles[idx].title!,
              url: widget.news == "Breaking"
                  ? headlines[idx].url!
                  : articles[idx].url!,
            );
          },
          separatorBuilder: (ctx, idc) => const Gap(24),
        ),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  const AllNewsSection({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.url,
  });

  final String imageUrl;
  final String description;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => ArticleView(blogUrl: url)),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(5),
          Text( title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(10),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
