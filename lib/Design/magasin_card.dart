import 'package:flutter/material.dart';

class MagasinTable extends StatelessWidget {
  const MagasinTable({
    super.key,
    required this.title,
    required this.nomMg,
    required this.colorl,
    this.onPressed,
  });

  final String title;
  final String nomMg;
  final Color colorl;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, 
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
            color: colorl,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
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
                    'Nom Magasin: $nomMg',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(
              height: 70,
              child: VerticalDivider(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}