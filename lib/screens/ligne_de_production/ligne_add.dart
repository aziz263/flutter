import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';
import '../../models/ligne_add.dart';
import 'ligne_controller.dart';


class AddLigne extends StatefulWidget {
  const AddLigne({super.key});

  @override
  AddLigneState createState() => AddLigneState();
}

class AddLigneState extends State<AddLigne> {
  final TextEditingController _numLigneController = TextEditingController();

  Future<void> _addUs() async {
    final String numLigne = _numLigneController.text.trim();

    if (numLigne.isNotEmpty) {
      final news = LigneAdd(
        numLigne: numLigne,
      );
      try {
        final LigneController controller = LigneController();
        final http.Response response = await controller.addUs(us: news);
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: "ligne ajouté avec succès",
              contentType: ContentType.success,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pop(context, true);
        } else {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Fail',
              message: "Failed to add ligne: ${response.statusCode}",
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: "Failed to add ligne: $e",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add Ligne"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        const Colorie(),
        Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _numLigneController,
                decoration: const InputDecoration(labelText: 'Ligne'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  child: Center(
                child: ElevatedButton(
                    onPressed: _addUs,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      ),
                    ),
                    child: const Text('Add Ligne')),
              )),
            ],
          ),
        ),
      ]),
    );
  }
}
