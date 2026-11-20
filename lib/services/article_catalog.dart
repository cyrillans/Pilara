import '../data/dummy_articles.dart';
import 'pilara_api.dart';

Future<List<Article>> loadArticleCatalog({int? limit}) async {
  final articles = await PilaraApi.instance.fetchArticles();
  if (limit == null || articles.length <= limit) return articles;
  return articles.sublist(0, limit);
}
