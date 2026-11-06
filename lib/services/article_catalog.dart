import '../data/dummy_articles.dart';
import 'pilara_api.dart';

Future<List<Article>> loadArticleCatalog({int? limit}) async {
  final summaries = await PilaraApi.instance.fetchArticles();
  final articles = <Article>[];

  for (final summary in summaries) {
    Article? localContent;
    for (final article in dummyArticles) {
      if (article.id == summary.id) {
        localContent = article;
        break;
      }
    }
    if (localContent == null) {
      throw ApiException(
        'Konten artikel ${summary.id} belum tersedia di aplikasi.',
      );
    }
    articles.add(
      Article(
        id: summary.id,
        title: summary.title,
        description: summary.description,
        category: summary.category,
        readTime: summary.readTime,
        author: summary.author,
        updatedDate: summary.updatedDate,
        headerImage: summary.headerImage,
        icon: localContent.icon,
        introduction: localContent.introduction,
        sections: localContent.sections,
        importantPoints: localContent.importantPoints,
        sourceName: localContent.sourceName,
        sourceUrl: localContent.sourceUrl,
      ),
    );
  }

  if (limit == null || articles.length <= limit) return articles;
  return articles.sublist(0, limit);
}
