import 'package:flutter/material.dart';

class MagasinierCard extends StatelessWidget {
  const MagasinierCard({
    super.key,
    required this.title,
    required this.nom,
    required this.prenom,
    required this.mail,
    required this.age,
    required this.adminRole,
    required this.qrCode,
    required this.colorl,
    this.onPressed,
  });

  final String title;
  final String nom;
  final String prenom;
  final String mail;
  final String age;
  final String adminRole;
  final int? qrCode;
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
                    'Email: $mail',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prenom: $prenom ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nom: $nom',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Age: $age',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role: $adminRole',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'N° serie: $qrCode',
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
