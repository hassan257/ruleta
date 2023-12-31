part of 'banner_widget.dart';

class BannerInlineWidget extends StatefulWidget {
  const BannerInlineWidget({Key? key}) : super(key: key);

  @override
  State<BannerInlineWidget> createState() => _BannerInlineWidgetState();
}

class _BannerInlineWidgetState extends State<BannerInlineWidget> {
  // static final _kAdIndex = 4;

  late BannerAd _ad;

  bool _isAdLoaded = false;

  // int _getDestinationItemIndex(int rawIndex) {
  //   if (rawIndex >= _kAdIndex && _isAdLoaded) {
  //     return rawIndex - 1;
  //   }
  //   return rawIndex;
  // }

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          // ignore: avoid_print
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_isAdLoaded && index == _kAdIndex) {
    if (_isAdLoaded) {
      return Container(
        // color: Colors.red,
        width: _ad.size.width.toDouble(),
        height: 72.0,
        alignment: Alignment.center,
        // color: Colors.red,
        child: AdWidget(ad: _ad),
      );
    } else {
      // final item = widget.entries[_getDestinationItemIndex(index)];

      return const SizedBox(
        height: 72,
        width: double.infinity,
        // color: Colors.red,
      );
    }
  }
}