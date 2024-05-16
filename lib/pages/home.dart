import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/model/headline_model.dart';
import 'package:news_app/pages/all_news.dart';
import 'package:news_app/pages/articles_view.dart';
import 'package:news_app/pages/category_news.dart';
import 'package:news_app/services/datapath.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  List<HeadlineModel> headlines = [];
  int carouselIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    sliders = getSliders();
    getHeadlines();
    getNews();
  }

  void getNews() async {
    final fetchedArticles = await NewsService().getNews();
    articles = fetchedArticles;
    setState(() {
      _isLoading = false;
    });
  }

  void getHeadlines() async {
    final fetchedHeadlines = await NewsService().getTopHeadlines();
    headlines = fetchedHeadlines;
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
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge,
            children: const [
              TextSpan(
                text: "Global ",
                  style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w400)
              ),
              TextSpan(
                  text: " News",
                  )
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              height: double.maxFinite,
              child: const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News Categories Section
                  Container(
                    height: 70,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(left: 10),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          categoryName: categories[index].categoryName,
                          image: categories[index].image,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Gap(10);
                      },
                    ),
                  ),
                  const Gap(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Breaking News!!!",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Newzz(news: "Breaking")),
                            );
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.deepPurpleAccent),
                          child: const Text(
                            "Show",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Carousel Section
                  const Gap(30),
                  CarouselSlider.builder(
                    itemCount: 7,
                    itemBuilder: (context, itemIndex, pageViewIndex) {
                      String res = headlines[itemIndex].urlToImage!;
                      String name = headlines[itemIndex].title!;
                      return buildImage(res, itemIndex, name);
                    },
                    options: CarouselOptions(
                        // height of carousel
                        height: 250,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        autoPlay: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1000),
                        onPageChanged: (index, reason) {
                          setState(() {
                            carouselIndex = index;
                          });
                        }),
                  ),
                  const Gap(10),
                  Center(child: buildIndicator()),

                  // Latest Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Latest News !!!",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Newzz(news: "Latest")),
                            );
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.redAccent),
                          child: const Text(
                            "Show",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),

                  const Gap(10),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, idx) {
                      return Tile(
                        imageUrl: articles[idx].urlToImage!,
                        title: articles[idx].title!,
                        description: articles[idx].description!,
                        url: articles[idx].url!,
                      );
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Text(
                  name,
                  maxLines: 3,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      );

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: carouselIndex,
      count: 5,
      effect: const WormEffect(
          dotWidth: 8, dotHeight: 8, activeDotColor: Colors.blue),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, this.image, this.categoryName});

  final String? image;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryNews(
            categoryName: categoryName!,
          ),
        ));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset( image!,
              width: 120, height: 70,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black26, borderRadius: BorderRadius.circular(6)),
            width: 120, height: 70,
            child: Center(
              child: Text(
                categoryName!,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.url});

  final String imageUrl;
  final String title;
  final String description;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 3.0,
        surfaceTintColor: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleView(blogUrl: url),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    )),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text( title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      const Gap(10),
                      Text( description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
