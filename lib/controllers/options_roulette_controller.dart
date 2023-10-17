part of 'controllers.dart';
class OptionsRouletteController extends GetxController{
  final TextEditingController optionNameTextController = TextEditingController();
  final RxList<RouletteElementModel> options = RxList.empty();
  Future store() async{
    options.add(RouletteElementModel(text: optionNameTextController.text, color: RandomColor().randomColor()));
  }
}