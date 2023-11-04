part of 'controllers.dart';

class OptionsRouletteController extends GetxController {
  final TextEditingController optionNameTextController =
      TextEditingController();
  final RxList<RouletteElementModel> options = RxList.empty();
  // RxBool isSpinning = false.obs;
  // RxDouble rotationAngle = (0.0).obs;

  void callDialog(
      String title, String textLabel, String textCancel, String textConfirm) {
    optionNameTextController.clear();
    Get.defaultDialog(
      barrierDismissible: false,
      title: title,
      content: TextField(
        autofocus: true,
        controller: optionNameTextController,
        decoration: InputDecoration(
          label: Text(textLabel),
        ),
      ),
      textCancel: textCancel,
      textConfirm: textConfirm,
      onCancel: () => Get.back(),
      onConfirm: () async {
        await store();
        Get.back();
      },
    );
  }

  void yesNoRoulette(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    options.clear();
    final yesColor = RandomColor().randomColor();
    final noColor = RandomColor().randomColor();
    options.addAll([
      RouletteElementModel(text: appLocalizations!.yes, color: yesColor),
      RouletteElementModel(text: appLocalizations.no, color: noColor),
      RouletteElementModel(text: appLocalizations.yes, color: yesColor),
      RouletteElementModel(text: appLocalizations.no, color: noColor),
    ]);
  }

  void threeOptionsRoulette(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    options.clear();
    options.addAll([
      RouletteElementModel(
          text: '${appLocalizations!.option} 1',
          color: RandomColor().randomColor()),
      RouletteElementModel(
          text: '${appLocalizations.option} 2',
          color: RandomColor().randomColor()),
      RouletteElementModel(
          text: '${appLocalizations.option} 3',
          color: RandomColor().randomColor()),
    ]);
  }

  void fourOptionsRoulette(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    threeOptionsRoulette(context);
    options.add(
      RouletteElementModel(
          text: '${appLocalizations!.option} 4',
          color: RandomColor().randomColor()),
    );
  }

  Future store() async {
    options.add(RouletteElementModel(
        text: optionNameTextController.text,
        color: RandomColor().randomColor()));
  }
}
