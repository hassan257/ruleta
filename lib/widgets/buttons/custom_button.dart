part of '../widgets.dart';
class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? colorButton;
  final Color? colorText;
  final String text;
  final IconData? icon;
  const CustomButton({
    Key? key, this.onPressed, this.colorButton, this.colorText, required this.text, this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          shape: BoxShape.rectangle,
          color: colorButton,
        ),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(icon, color: colorText,),
            Text(text,
              style: TextStyle(
                color: colorText, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}