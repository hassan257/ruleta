part of 'controllers.dart';
class OptionsRouletteController extends GetxController{
  final TextEditingController optionNameTextController = TextEditingController();
  final RxList<RouletteElementModel> options = RxList.empty();
  // RxBool isSpinning = false.obs;
  // RxDouble rotationAngle = (0.0).obs;
  
  void callDialog() {
    optionNameTextController.clear();
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Add Option',
      content: TextField(
        autofocus: true,
        controller: optionNameTextController,
        decoration: const InputDecoration(
          label: Text('Option\'s Name'),
        ),
      ),
      onCancel: () => Get.back(),
      onConfirm: () async{
        await store();
        Get.back();
      },
    );
  }

  void yesNoRoulette(){
    options.clear();
    final yesColor = RandomColor().randomColor();
    final noColor = RandomColor().randomColor();
    options.addAll([
      RouletteElementModel(text: 'Yes', color: yesColor),
      RouletteElementModel(text: 'No', color: noColor),
      RouletteElementModel(text: 'Yes', color: yesColor),
      RouletteElementModel(text: 'No', color: noColor),
    ]);
  }

  void threeOptionsRoulette(){
    options.clear();
    options.addAll([
      RouletteElementModel(text: 'Option 1', color: RandomColor().randomColor()),
      RouletteElementModel(text: 'Option 2', color: RandomColor().randomColor()),
      RouletteElementModel(text: 'Option 3', color: RandomColor().randomColor()),
    ]);
  }

  void fourOptionsRoulette(){
    threeOptionsRoulette();
    options.add(
      RouletteElementModel(text: 'Option 4', color: RandomColor().randomColor()),
    );
  }

  Future store() async{
    options.add(RouletteElementModel(text: optionNameTextController.text, color: RandomColor().randomColor()));
  }


}