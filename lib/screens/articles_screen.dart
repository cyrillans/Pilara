import 'package:flutter/material.dart';

import '../data/dummy_articles.dart';
import '../routers/app_router.dart';
import '../services/pilara_api.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _loadArticles();
  }

  Future<List<Article>> _loadArticles() async {
    final metadata = await PilaraApi.instance.articles();
    final fullContent = {
      for (final article in dummyArticles) article.id: article
    };
    return metadata.map((item) {
      final content = fullContent[item.id];
      return Article(
        id: item.id,
        title: item.title,
        description: item.description,
        category: item.category,
        readTime: item.readTime,
        author: item.author,
        updatedDate: item.updatedDate,
        headerImage: item.headerImage,
        icon: content?.icon ?? Icons.article_outlined,
        introduction: content?.introduction ?? item.description,
        sections: content?.sections ?? const [],
        importantPoints: content?.importantPoints ?? const [],
        sourceName: content?.sourceName ?? item.author,
        sourceUrl: content?.sourceUrl ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.green[50],
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Artikel Pilara',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat artikel: ${snapshot.error}'),
                  TextButton(
                    onPressed: () =>
                        setState(() => _articlesFuture = _loadArticles()),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final articles = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) =>
                _ArticleListCard(article: articles[index]),
          );
        },
      ),
    );
  }
}

// ==================================================================
// ARTICLE LIST CARD
// ==================================================================

class _ArticleListCard extends StatelessWidget {
  final Article article;

  const _ArticleListCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.articleDetail,
          arguments: article,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER IMAGE
            // ======================================================

            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.network(
                article.headerImage,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: Colors.green.shade50,
                    child: Icon(
                      article.icon,
                      size: 55,
                      color: Colors.green.shade700,
                    ),
                  );
                },
              ),
            ),

            // ======================================================
            // ARTICLE INFORMATION
            // ======================================================

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------------
                  // CATEGORY
                  // ------------------------------------------------

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------
                  // TITLE
                  // ------------------------------------------------

                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------
                  // DESCRIPTION
                  // ------------------------------------------------

                  Text(
                    article.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ------------------------------------------------
                  // DATE + READ TIME
                  // ------------------------------------------------

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          article.updatedDate,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        article.readTime,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ------------------------------------------------
                  // BACA ARTIKEL
                  // ------------------------------------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.green.shade700,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
