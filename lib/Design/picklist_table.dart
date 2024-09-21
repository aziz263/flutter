import 'package:flutter/material.dart';

class PicklistTable extends StatelessWidget {
  const PicklistTable({
    super.key,
    required this.title,
    required this.magasin,
    required this.ligne,
    required this.date,
    required this.colorl,
    this.onPressed,
  });

  final String title;
  final String magasin;
  final int ligne;
  final String date;
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
                    'Magasin: $magasin',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ligne: $ligne',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: $date',
                    style: const TextStyle(color: Colors.white),
                  ),
                 
                ],
              ),
            ),
            const SizedBox(
              height: 140,
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
