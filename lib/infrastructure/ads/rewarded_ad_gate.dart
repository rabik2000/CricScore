import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Shows a rewarded ad and completes when the user earns the reward.
///
/// Note: Replace [rewardedAdUnitId] with your own unit id for production.
class RewardedAdGate {
  RewardedAdGate();

  /// Rewarded ad unit id for production.
  ///
  /// For Play Store builds, set:
  /// `--dart-define=ADMOB_REWARDED_AD_UNIT_ID=ca-app-pub-.../...`
  /// During local development you can keep the default test id.
  static const String rewardedAdUnitId = String.fromEnvironment(
    'ADMOB_REWARDED_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-3940256099942544/5224354917',
  );

  static bool _initialized = false;

  Future<void> showRewardedAd() async {
    if (!_initialized) {
      MobileAds.instance.initialize();
      _initialized = true;
    }

    final completer = Completer<void>();

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              if (!completer.isCompleted) completer.completeError(err);
            },
          );

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (!completer.isCompleted) completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }
}

