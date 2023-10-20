

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roulette/controllers/controllers.dart';
import 'package:roulette/models/models.dart';

import 'widgets/widgets.dart';

void main() => runApp(const GetMaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      title: 'Roulette',
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if(optionsRouletteController.options.isEmpty){
            return const _MainMenu();
          }else{
            List<Widget> options = [];
            for (var option in optionsRouletteController.options) {
              options.add(_OptionElement(option: option));
            }
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: _AddOptionButton(),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Information(widthRoulette: widthRoulette, options: options),
                          const RouletteWidget(widthRoulette: widthRoulette, widthIndicator: widthIndicator, heightIndicator: heightIndicator),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info, color: Colors.blueAccent,),
                              Text('Tap or Drag to Spin', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blueAccent),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      CustomButton(
                        text: 'Reset',
                        colorButton: Colors.redAccent,
                        colorText: Colors.white,
                        icon: Icons.restore,
                        onPressed: () {
                          optionsRouletteController.options.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}


class _OptionElement extends StatelessWidget {
  const _OptionElement({
    Key? key,
    required this.option,
  }) : super(key: key);

  final RouletteElementModel option;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(color: option.color, height: 10, width: 10,),
        const SizedBox(width: 5,),
        Text(option.text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)
      ],
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

class _MainMenu extends StatelessWidget {
  const _MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NewRouletteButton(),
            SizedBox(height: 15,),
            _YesNoRouletteButton(),
            SizedBox(height: 15,),
            _ThreeOptionsButton(),
            SizedBox(height: 15,),
            _FourOptionsButton()
          ],
        ),
      ),
    );
  }
}

class _NewRouletteButton extends StatelessWidget {
  const _NewRouletteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
    return CustomButton(
      onPressed: optionsRouletteController.callDialog,
      colorButton: Colors.blueAccent,
      colorText: Colors.white,
      text: 'New Roulette',
      icon: Icons.new_releases,
    );
  }
}

class _YesNoRouletteButton extends StatelessWidget {
  const _YesNoRouletteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
    return CustomButton(
      onPressed: optionsRouletteController.yesNoRoulette,
      colorButton: Colors.greenAccent,
      colorText: Colors.black,
      text: 'Yes/No Roulette',
      icon: Icons.radio_button_checked,
    );
  }
}

class _ThreeOptionsButton extends StatelessWidget {
  const _ThreeOptionsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
    return CustomButton(
      onPressed: optionsRouletteController.threeOptionsRoulette,
      colorButton: Colors.redAccent,
      colorText: Colors.white,
      text: 'Three Options Roulette',
      icon: Icons.radio_button_checked,
    );
  }
}

class _FourOptionsButton extends StatelessWidget {
  const _FourOptionsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
    return CustomButton(
      onPressed: optionsRouletteController.fourOptionsRoulette,
      colorButton: Colors.amberAccent,
      colorText: Colors.black,
      text: 'Four Options Roulette',
      icon: Icons.radio_button_checked,
    );
  }
}