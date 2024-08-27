
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

typedef CloseLoadingScreen=bool Function();
typedef UpdateLoadingScreen=bool Function();

@immutable
class LoadingScreenController{
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update
  });

}
/// use of the LoadingScreenController is to check weather the overlay is been displayed or not
class WaitingScreen{

  WaitingScreen._sharedinstance();
  static final _shared=WaitingScreen._sharedinstance();
  factory WaitingScreen()=>_shared;

  LoadingScreenController? _controller;

  void show({required BuildContext context}){
    ///if the _controller is null that overlay has not been show so it will return the false
    ///so the else will be executed which will show the overlay if the _controller has an object
    ///then it will update the text of the overlay and .update returns the true so after that function will return
    if(_controller?.update()??false){
      return;
    }else{
      _controller=_showOverlay(context: context);
    }
  }

  void close(){
    _controller?.close();
    _controller=null;
  }

  LoadingScreenController _showOverlay({required BuildContext context}){
    final text0= StreamController<String>();
    //get the size
    final state=Overlay.of(context);
    final renderBox= context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
            color:Colors.black.withAlpha(150),
            child:Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: size.width* 0.8,
                  maxHeight: size.height* 0.8,
                  minWidth: size.width* 0.5,
                ),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10,),
                          Center(child: Lottie.asset('assets/loading.json', width: 200, height: 200),),
                          const SizedBox(height: 20,),
                          const Text(
                                  'Loading',
                                  textAlign: TextAlign.center,
                                ),
                        ],
                      ),
                    )
                ),
              ),
            )
        );
      },
    );
    state.insert(overlay);
    return LoadingScreenController(close:() {
      text0.close();
      overlay.remove();
      return true;
    },
      update: () {
        return true;
      },
    );

  }

}

class DoneScreenOverlay{

  DoneScreenOverlay._sharedinstance();
  static final _shared=DoneScreenOverlay._sharedinstance();
  factory DoneScreenOverlay()=>_shared;

  LoadingScreenController? _controller;

  void show({required BuildContext context}){
    ///if the _controller is null that overlay has not been show so it will return the false
    ///so the else will be executed which will show the overlay if the _controller has an object
    ///then it will update the text of the overlay and .update returns the true so after that function will return
    if(_controller?.update()??false){
      return;
    }else{
      _controller=_showOverlay(context: context);
    }
  }

  void close(){
    _controller?.close();
    _controller=null;
  }

  LoadingScreenController _showOverlay({required BuildContext context}){
    final text0= StreamController<String>();
    //get the size
    final state=Overlay.of(context);
    final renderBox= context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color:Colors.black.withAlpha(150),
          child:Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: size.width* 0.8,
                  maxHeight: size.height* 0.8,
                  minWidth: size.width* 0.5,
                ),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      const SizedBox(height: 10,),
                    Center(child: Lottie.asset('assets/first-project.json', width: 200, height: 200)),
                    const SizedBox(height: 20,),
                    const Text(
                      'Loading',
                      textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
            ),
          ),
        )
        );
      },
    );
    state.insert(overlay);
    return LoadingScreenController(close:() {
      text0.close();
      overlay.remove();
      return true;
    },
      update: () {
        return true;
      },
    );

  }
}
final waitingScreen=WaitingScreen();
final doneScreen=DoneScreenOverlay();
