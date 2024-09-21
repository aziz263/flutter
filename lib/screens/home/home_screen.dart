import 'package:flutter/material.dart';
import 'package:sagem/Design/components/course_cardArticle.dart';

import '../../Design/components/course_card.dart';
import '../../Design/components/secondary_course_card.dart';
import '../../Design/course.dart';

class HomePage extends StatelessWidget {
  static String name = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "News",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: courses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final course = entry.value;
                    final isEven = index.isEven;

                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: isEven
                          ? CourseCard(
                              title: course.title,
                              iconSrc: course.iconSrc,
                              color: course.color,
                              onPressed: () {
                                if (course.onPressed != null) {
                                  course.onPressed!(context);
                                }
                              },
                            )
                          : CourseCardArticle(
                              title: course.title,
                              iconSrc: course.iconSrc,
                              color: course.color,
                              onPressed: () {
                                if (course.onPressed != null) {
                                  course.onPressed!(context);
                                }
                              },
                            ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Menu",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ...recentCourses.map((course) => Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: SecondaryCourseCard(
                      title: course.title,
                      // iconsSrc: course.iconSrc,
                      colorl: course.color,
                      onPressed: () {
                        if (course.onPressed != null) {
                          course.onPressed!(context);
                        }
                      },
                      subtitle: '',
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
