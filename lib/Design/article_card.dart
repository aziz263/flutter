import 'package:flutter/material.dart';

class ArticleTable extends StatelessWidget {
  const  ArticleTable({
    super.key,
    required this.title,
    required this.articleData,
    required this.colorl,
    this.onPressed,
  });

  final String title;
  final String articleData;
  final Color colorl;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Execute the onPressed function when tapped
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
            color: colorl,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          // Changed to Row
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children at the start
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Name article: $articleData',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(
              height: 70,
              child: VerticalDivider(
                // thickness: 5,
                color: Colors.white70,
              ),
            ),

            // SvgPicture.asset(iconsSrc),
          ],
        ),
      ),
    );
  }
}
