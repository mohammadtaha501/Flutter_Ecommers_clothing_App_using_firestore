import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:testapp/main_screen.dart';
import 'firebase_options.dart';
import 'landing-page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const EntryPage(),
  ),
  );
}

typedef DialogOptionBuilder<T>=Map<String,dynamic> Function();

Future<T?> showGenericDialog<T>({required BuildContext context,required String message,required String tittle ,required DialogOptionBuilder optionBuilder}){
  final options = optionBuilder();
  return showDialog<T?>(context: context, builder:(context){
    return AlertDialog(
      title: Text(tittle),
      content: Text(message),
      actions: options.keys.map((optionTitle){
        final value =options[optionTitle];
        return TextButton(onPressed: () {
          if(value!=null){
            Navigator.of(context).pop(value);
          }else{
            Navigator.of(context).pop();
          }
        }, child: Text(optionTitle));

      }).toList(),
    );
  }
  );
}


class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    TextEditingController email=TextEditingController();
    TextEditingController password=TextEditingController();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wall.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Set the border color here
                    width: 2, // Set the border width here
                  ),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/human.jpg'),
                ),
              ),

              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                  child: Text(
                      'Login here ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                  )
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Ensuring the container background is transparent
                    border: Border.all(
                      color: Colors.black, // Darker border color
                      width: 2.0, // Thicker border width
                    ),
                    borderRadius: BorderRadius.circular(5.0), // Rounded corners, optional
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: email,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'examplr@domain.com',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      border: InputBorder.none, // Remove the default border
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // Adjust padding
                      filled: true,
                      fillColor: Colors.transparent, // TextField background color
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0,bottom: 8),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Ensuring the container background is transparent
                    borderRadius: BorderRadius.circular(5.0), // Rounded corners, optional
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7), // Darker shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 5, // Blur radius
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 16.0,left: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Ensuring the container background is transparent
                    border: Border.all(
                      color: Colors.black, // Darker border color
                      width: 2.0, // Thicker border width
                    ),
                    borderRadius: BorderRadius.circular(5.0), // Rounded corners, optional
                  ),
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: password,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter your password here',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      border: InputBorder.none, // Remove the default border
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // Adjust padding
                      filled: true,
                      fillColor: Colors.transparent, // TextField background color
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0,bottom: 8),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Ensuring the container background is transparent
                    borderRadius: BorderRadius.circular(5.0), // Rounded corners, optional
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7), // Darker shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 5, // Blur radius
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 300, // Set the desired width here
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Set the border radius to 0.0 for rectangular edges
                    ),
                  ),
                  onPressed: () async {
                    try{
                    print('hi');
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                    print('sign is sucessfull');
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => GalleryView()),
                    // );
                    }on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        showGenericDialog(
                            context: context, message: 'No user found for that email.',
                            tittle: 'notice',
                            optionBuilder:()=>{'ok':true}
                        );
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided.');
                        showGenericDialog(
                            context: context,
                            message: 'Wrong password provided.',
                            tittle: '',
                            optionBuilder:()=>{
                            'ok':true,
                          }
                          );
                      } else {
                        print('Error: ${e.code}');
                        showGenericDialog(
                            context: context,
                            message: e.message??'something went wrong',
                            tittle: '',
                            optionBuilder:()=>{
                            'ok':true,
                        }
                        );
                      }
                    } catch (e) {
                      print('Unexpected error: ${e.runtimeType}');
                      showGenericDialog(
                          context: context,
                          message: 'something went wrong try again later',
                          tittle: '',
                          optionBuilder:()=>{
                        'ok':true,
                        },
                      );
                    }
                  },
                  child: const Center(
                      child: Text(
                          'login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)
                      )
                  ),
                ),
              ),

              const Text(
                  'other sign-in options',
                  style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w200)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook,color: Colors.blue,), // Icon to display
                    onPressed: () {
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
