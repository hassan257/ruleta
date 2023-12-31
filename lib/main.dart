import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:roulette/controllers/controllers.dart';
import 'package:roulette_widget/roulette_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/ad/banner_widget.dart';
import 'helpers/ad_helper.dart';
import 'widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // Inicializar publicidad
    await MobileAds.instance.initialize();
  }
  // Para inhabilitar el cambio de orientación
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const GetMaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roulette',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const _Body(),
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          actions: const [_PrivacyButton()],
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
    );
  }
}

class _PrivacyButton extends StatelessWidget {
  const _PrivacyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        child: const Icon(
          Icons.privacy_tip,
          color: Colors.black26,
        ),
        onTap: () async {
          const url =
              'https://hassansystems.com/src/privacidad/privacidad_simple_decision_roulette.html';
          final Uri _url = Uri.parse(url);
          if (await canLaunchUrl(_url)) {
            await launchUrl(_url, mode: LaunchMode.externalApplication);
          }
        },
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
    final OptionsRouletteController optionsRouletteController =
        Get.put(OptionsRouletteController());
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (optionsRouletteController.options.isEmpty) {
            return Column(
              children: [
                const Expanded(child: _MainMenu()),
                Platform.isAndroid ? const BannerWidget() : Container()
              ],
            );
          } else {
            List<Widget> options = [];
            List<RouletteElementModel> optionsRoulette = [];
            for (var option in optionsRouletteController.options) {
              options.add(_OptionElement(option: option));
              optionsRoulette.add(
                  RouletteElementModel(text: option.text, color: option.color));
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
                          _Information(
                              widthRoulette: widthRoulette, options: options),
                          _Ruleta(
                              widthRoulette: widthRoulette,
                              widthIndicator: widthIndicator,
                              heightIndicator: heightIndicator,
                              optionsRoulette: optionsRoulette),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info,
                                color: Colors.blueAccent,
                              ),
                              Text(
                                appLocalizations!.tapOrDragToSpin,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: appLocalizations.reset,
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
                Platform.isAndroid ? const BannerWidget() : Container()
              ],
            );
          }
        }),
      ),
    );
  }
}

class _Ruleta extends StatefulWidget {
  const _Ruleta({
    Key? key,
    required this.widthRoulette,
    required this.widthIndicator,
    required this.heightIndicator,
    required this.optionsRoulette,
  }) : super(key: key);

  final double widthRoulette;
  final double widthIndicator;
  final double heightIndicator;
  final List<RouletteElementModel> optionsRoulette;

  @override
  State<_Ruleta> createState() => _RuletaState();
}

class _RuletaState extends State<_Ruleta> {
  int times = 0;
  InterstitialAd? interstitialAd;
  _event() {
    if (times > 4) {
      setState(() {
        times = 0;
        // _loadAd();
        interstitialAd!.show();
      });
    } else {
      setState(() {
        times++;
      });
    }
  }

  void _loadAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    _loadAd();
    return GestureDetector(
        onTap: _event,
        child: RouletteWidget(
          widthRoulette: widget.widthRoulette,
          widthIndicator: widget.widthIndicator,
          heightIndicator: widget.heightIndicator,
          options: widget.optionsRoulette,
          otherActions: _event,
        ));
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
        Container(
          color: option.color,
          height: 10,
          width: 10,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          option.text,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        )
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
    final OptionsRouletteController optionsRouletteController =
        Get.find<OptionsRouletteController>();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Obx(() => CustomButton(
          onPressed: () => _callDialog(context),
          colorButton: Colors.blueAccent,
          colorText: Colors.white,
          text: optionsRouletteController.options.isNotEmpty
              ? appLocalizations!.addOption
              : appLocalizations!.newRoulette,
          icon: Icons.add_circle,
        ));
  }

  void _callDialog(BuildContext context) {
    final OptionsRouletteController optionsRouletteController =
        Get.find<OptionsRouletteController>();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    optionsRouletteController.optionNameTextController.clear();
    Get.defaultDialog(
      barrierDismissible: false,
      title: appLocalizations!.addOption,
      content: TextField(
        autofocus: true,
        controller: optionsRouletteController.optionNameTextController,
        decoration: InputDecoration(
          label: Text(appLocalizations.optionsName),
        ),
      ),
      textCancel: appLocalizations.cancel,
      textConfirm: appLocalizations.ok,
      onCancel: () => Get.back(),
      onConfirm: () async {
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
            SizedBox(
              height: 15,
            ),
            _YesNoRouletteButton(),
            SizedBox(
              height: 15,
            ),
            _ThreeOptionsButton(),
            SizedBox(
              height: 15,
            ),
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
    final OptionsRouletteController optionsRouletteController =
        Get.find<OptionsRouletteController>();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return CustomButton(
      onPressed: () => optionsRouletteController.callDialog(
          appLocalizations!.addOption,
          appLocalizations.optionsName,
          appLocalizations.cancel,
          appLocalizations.ok),
      colorButton: Colors.blueAccent,
      colorText: Colors.white,
      text: appLocalizations!.newRoulette,
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
    final OptionsRouletteController optionsRouletteController =
        Get.find<OptionsRouletteController>();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return CustomButton(
      onPressed: () => optionsRouletteController.yesNoRoulette(context),
      colorButton: Colors.greenAccent,
      colorText: Colors.black,
      text: appLocalizations!.yesNoRoulette,
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
    final OptionsRouletteController optionsRouletteController =
        Get.find<OptionsRouletteController>();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return CustomButton(
      onPressed: () => optionsRouletteController.threeOptionsRoulette(context),
      colorButton: Colors.redAccent,
      colorText: Colors.white,
      text: appLocalizations!.threeOptionsRoulette,
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
    final OptionsRouletteController optionsRouletteController =
        Get.find<OptionsRouletteController>();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return CustomButton(
      onPressed: () => optionsRouletteController.fourOptionsRoulette(context),
      colorButton: Colors.amberAccent,
      colorText: Colors.black,
      text: appLocalizations!.fourOptionsRoulette,
      icon: Icons.radio_button_checked,
    );
  }
}
