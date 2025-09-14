import 'package:flutter/material.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';
import 'package:provider/provider.dart';

import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:mobile_english_learning/viewmodels/auth/app_state_view_models.dart';



class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreenState();
  
}

class _homeScreenState extends State<HomeScreen>{
  final Color fontcolor = HexColor.fromHex("#102f74");

  
  @override
  Widget build(BuildContext context) {


      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/bg-fresh-open.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppBar(
              toolbarHeight: 120.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 260.0,
                  child: Image.asset(
                    'assets/icons/Wave-top-fix.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(150, 80, 222, 0.0),
                ),
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 160.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Image(
                      image: AssetImage('assets/icons/logo-fix.png'),
                      height: 220.0,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Hi, Guys!",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 40.0,
                                fontWeight: FontWeight.w600,
                                color: fontcolor,
                              ),
                            ),
                            Text(
                              "Welcome to\nBrain Boost",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                                color: fontcolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // The new bottom row should be here, inside the Stack
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(right: 20.0,top:600.0),
                child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // The image takes up the remaining space
                        Expanded(
                          child: Image.asset(
                            'assets/icons/Wave-bottom-fix.png',
                            fit: BoxFit.contain, // Use BoxFit.contain to prevent distortion
                          ),
                        ),
                        // A SizedBox for spacing before the "Next" text
                        const SizedBox(width: 8.0),
                        // The text
                        const Text(
                          "Next",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        // A SizedBox for spacing before the button
                        const SizedBox(width: 25.0),

                        ElevatedButton(
                              onPressed: () async {
                                final appState = context.read<AppStateViewModel>(); 
                                await appState.setFreshOpen(false); // persist properly
                                final stored = await SharedPrefUtils.readPrefBool('is_freshOpen');
                                debugPrint("Stored freshOpen after set: $stored");
                                Future.microtask(() {
                                    context.go('/login');
                                  });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fontcolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              child: const Icon(Icons.navigate_next,color: Colors.white,),
                            ),
            
                      ],
                    )
              ),
            ),
          ],
        ),
      );
  } 

}

