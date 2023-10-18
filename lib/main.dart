

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruleta/controllers/controllers.dart';

import 'widgets/widgets.dart';

void main() => runApp(const GetMaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    const double heightIndicator = 30;
    const double widthIndicator = 30;
    const double widthRoulette = 200;
    final OptionsRouletteController optionsRouletteController = Get.put(OptionsRouletteController());
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _AddOptionButton(),
              Obx(() {
                if(optionsRouletteController.options.isNotEmpty){
                  List<Widget> options = [];
                  for (var option in optionsRouletteController.options) {
                    options.add(Row(children: [
                    Container(color: option.color, height: 10, width: 10,),
                    Text(option.text)
                    ],));
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Information(widthRoulette: widthRoulette, options: options),
                      const RouletteWidget(widthRoulette: widthRoulette, widthIndicator: widthIndicator, heightIndicator: heightIndicator),
                    ],
                  );
                }else{
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Information extends StatelessWidget {
  const _Information({
    Key? key,
    required this.widthRoulette,
    required this.options,
  }) : super(key: key);

  final double widthRoulette;
  final List<Widget> options;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthRoulette,
      child: Wrap(
        direction: Axis.horizontal,
        children: options,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
      ),
    );
  }
}

class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
    return Obx(() => CustomButton(
      onPressed: _callDialog,
      colorButton: Colors.blueAccent,
      colorText: Colors.white,
      text: optionsRouletteController.options.isNotEmpty ? 'Add Option' : 'New Roulette',
      icon: Icons.add_circle,
    ));
  }

  void _callDialog() {
      final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
      optionsRouletteController.optionNameTextController.clear();
      Get.defaultDialog(
        barrierDismissible: false,
        title: 'Add Option',
        content: TextField(
          autofocus: true,
          controller: optionsRouletteController.optionNameTextController,
          decoration: const InputDecoration(
            label: Text('Option\'s Name'),
          ),
        ),
        onCancel: () => Get.back(),
        onConfirm: () async{
          await optionsRouletteController.store();
          Get.back();
        },
      );
    }
}



