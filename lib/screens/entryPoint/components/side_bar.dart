import 'dart:async'; // Import async library for Future.delayed
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Design/menu.dart';
import '../../../models/magasinier.dart';
import '../../../utils/rive_utils.dart';
import '../../Magasinier_funct/magasinier_controller.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  final void Function(Menu) updateSelectedMenuItem;
  final int selectedIndex;

  const SideBar({
    super.key,
    required this.updateSelectedMenuItem,
    required Menu selectedMenu,
    required this.selectedIndex,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late Menu selectedSideMenu;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex <= 2) {
      selectedSideMenu = sidebarMenus[widget.selectedIndex];
    } else {
      selectedSideMenu = sidebarMenus2[widget.selectedIndex - 3];
    }
  }

  Future<Magasinier> fetchMagasinierBymail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mail = prefs.getString('mail');
    if (mail != null && mail.isNotEmpty) {
      try {
        final controller = MagasinierController();
        final fetchedMagasinier = await controller.getMagasinierBymail(mail);
        return fetchedMagasinier;
      } catch (e) {
        log('Error fetching magasins: $e');
        return const Magasinier(
          nom: '',
          prenom: '',
          mail: '',
          idmagasinier: 0,
          age: 0,
          password: '',
          adminRole: 0,
        );
      }
    } else {
      return const Magasinier(
        nom: '',
        prenom: '',
        mail: '',
        idmagasinier: 0,
        age: 0,
        password: '',
        adminRole: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Magasinier>(
                future: fetchMagasinierBymail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final magasinier = snapshot.data!;
                    return InfoCard(
                      name: '${magasinier.nom} ${magasinier.prenom}',
                      bio: magasinier.adminRole == 1 ? "Chef Magasin" : "Magasinier",
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text("Browse".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white70)),
              ),
              ...sidebarMenus.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      RiveUtils.chnageSMIBoolState(menu.rive.status!);
                      widget.updateSelectedMenuItem(menu);
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.onPressed!(context);
                      });
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(artboard,
                          stateMachineName: menu.rive.stateMachineName);
                    },
                    index: menu.index,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "History".toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white70),
                ),
              ),
              ...sidebarMenus2.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      RiveUtils.chnageSMIBoolState(menu.rive.status!);
                      widget.updateSelectedMenuItem(
                          menu);
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.onPressed!(context);
                      });
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(artboard,
                          stateMachineName: menu.rive.stateMachineName);
                    },
                    index: menu.index,
                  )),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                              .pushReplacementNamed('/onboarding');
                },
              child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.white70,
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove("mail");
                        await prefs.remove("role");
                        
                          Navigator.of(context)
                              .pushReplacementNamed('/onboarding');
                        
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
