

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _AddOptionButton(),
        Obx(() => optionsRouletteController.options.isNotEmpty ? const RouletteWidget(widthRoulette: widthRoulette, widthIndicator: widthIndicator, heightIndicator: heightIndicator) : Container()),
      ],
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
        title: 'Add Option',
        content: TextField(
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



