import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sagem/Design/_controller.dart';
import 'package:sagem/models/article.dart';
import 'package:sagem/models/magasinier.dart';

class CourseCardArticle extends StatefulWidget {
  final String title;
  final Color color;
  final String iconSrc;
  final VoidCallback? onPressed;

  const CourseCardArticle({
    Key? key,
    required this.title,
    required this.color,
    this.iconSrc = "assets/icons/ios.svg",
    this.onPressed,
  }) : super(key: key);

  @override
  _CourseCardArticleState createState() => _CourseCardArticleState();
}

class _CourseCardArticleState extends State<CourseCardArticle> {
  String articleData = "";


  @override
  void initState() {
    super.initState();
    getArticleOTM();
  }
  @override
  void dispose() {
    super.dispose();
    
  }

  Future<void> getArticleOTM() async {
    Controller controller = Controller();
    Article article = await controller.getArticleOfTheMonth();
    setState(() {
      articleData = article.articleData;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        height: 280,
        width: 260,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, right: 8),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                      child: Text(
                        articleData,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height:20),
                    
                     const Text(
                      "  Article le plus servi",
                      style: TextStyle(
                        color: Color.fromARGB(175, 255, 243, 134),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        1,
                        (index) => Transform.translate(
                          offset: Offset((-10 * index).toDouble(), 0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              "assets/avaters/Avatar ${index + 1}.jpg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SvgPicture.asset(
              widget.iconSrc,
              height: 40,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
