import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../helpers/ad_helper.dart';

part 'banner_inline_widget.dart';


class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        child: BannerInlineWidget(),
      ),
    );
  }
}