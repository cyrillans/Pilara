import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/dummy_articles.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  // ============================================================
  // BUKA SUMBER ARTIKEL
  // ============================================================

  Future<void> _openSource() async {
    final Uri url = Uri.parse(article.sourceUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
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
          'Detail Artikel',
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER IMAGE
            // ======================================================

            SizedBox(
              width: double.infinity,
              height: 240,

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

                    child: Center(
                      child: Icon(
                        article.icon,
                        size: 70,
                        color: Colors.green.shade700,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ======================================================
            // ARTICLE CONTENT
            // ======================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                35,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // CATEGORY
                  // ==================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      article.category,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  Text(
                    article.title,

                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // ARTICLE META
                  // ==================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),

                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        // ------------------------------------------------
                        // AUTHOR
                        // ------------------------------------------------

                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 18,
                                color:
                                    Colors.grey.shade600,
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  article.author,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ------------------------------------------------
                        // DATE
                        // ------------------------------------------------

                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color:
                                  Colors.grey.shade600,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              article.updatedDate,
                              style: TextStyle(
                                color:
                                    Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // READ TIME
                  // ==================================================

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: Colors.green.shade700,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        'Waktu baca: ${article.readTime}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // INTRODUCTION
                  // ==================================================

                  Text(
                    article.introduction,

                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // ARTICLE SECTIONS
                  // ==================================================

                  ...article.sections.map(
                    (section) {
                      return _ArticleSectionWidget(
                        section: section,
                      );
                    },
                  ),

                  // ==================================================
                  // IMPORTANT POINTS
                  // ==================================================

                  if (article.importantPoints.isNotEmpty) ...[
                    const SizedBox(height: 15),

                    const Text(
                      'Poin Penting',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          ...article.importantPoints.map(
                            (point) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(
                                  bottom: 12,
                                ),

                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [
                                    Container(
                                      margin:
                                          const EdgeInsets.only(
                                        top: 5,
                                      ),

                                      width: 7,
                                      height: 7,

                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .green.shade700,
                                        shape:
                                            BoxShape.circle,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Text(
                                        point,
                                        style:
                                            const TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ==================================================
                  // SOURCE
                  // ==================================================

                  const Text(
                    'Sumber',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Container(
                              width: 40,
                              height: 40,

                              decoration: BoxDecoration(
                                color:
                                    Colors.green.shade50,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),

                              child: Icon(
                                Icons.language_rounded,
                                color:
                                    Colors.green.shade700,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    'Sumber artikel',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    article.sourceName,
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ------------------------------------------------
                        // SOURCE BUTTON
                        // ------------------------------------------------

                        SizedBox(
                          width: double.infinity,

                          child: OutlinedButton.icon(
                            onPressed: _openSource,

                            icon: const Icon(
                              Icons.open_in_new_rounded,
                              size: 17,
                            ),

                            label: const Text(
                              'Buka sumber artikel',
                            ),

                            style:
                                OutlinedButton.styleFrom(
                              foregroundColor:
                                  Colors.green.shade700,

                              side: BorderSide(
                                color:
                                    Colors.green.shade300,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),

                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // CATATAN KOMENTAR
                  // ==================================================
                  //
                  // Belum dibuat sesuai konsep sebelumnya.
                  // Fitur komentar dapat ditambahkan nanti.
                  //
                  // ==================================================
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// ARTICLE SECTION
// ==================================================================

class _ArticleSectionWidget extends StatelessWidget {
  final ArticleSection section;

  const _ArticleSectionWidget({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 25,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ========================================================
          // SECTION TITLE
          // ========================================================

          Text(
            section.title,

            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 10),

          // ========================================================
          // SECTION CONTENT
          // ========================================================

          Text(
            section.content,

            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}