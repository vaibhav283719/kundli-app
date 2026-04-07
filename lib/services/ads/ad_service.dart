import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  AdService._internal();
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;

  // Ad unit IDs (Android)
  static const _bannerAdUnitId = 'ca-app-pub-3821574975461985/7983613630';
  static const _interstitialAdUnitId = 'ca-app-pub-3821574975461985/3786617244';
  static const _rewardedAdUnitId = 'ca-app-pub-3821574975461985/2441949249';

  static const _firstOpenKey = 'ad_first_open_timestamp';

  // Interstitial cooldown: once every 5 minutes after grace period
  static const _interstitialCooldownMinutes = 5;
  // Grace period: no interstitial/rewarded in first 30 minutes
  static const _gracePeriodMinutes = 30;

  DateTime? _firstOpenTime;
  DateTime? _lastInterstitialShownTime;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _interstitialLoading = false;
  bool _rewardedLoading = false;

  /// Call once at app startup.
  Future<void> initialize() async {
    await MobileAds.instance.initialize();

    final prefs = await SharedPreferences.getInstance();
    final savedMs = prefs.getInt(_firstOpenKey);
    if (savedMs == null) {
      _firstOpenTime = DateTime.now();
      await prefs.setInt(_firstOpenKey, _firstOpenTime!.millisecondsSinceEpoch);
    } else {
      _firstOpenTime = DateTime.fromMillisecondsSinceEpoch(savedMs);
    }

    _loadInterstitialAd();
    _loadRewardedAd();
  }

  /// True once the 30-minute new-user grace period has passed.
  bool get isGracePeriodOver {
    if (_firstOpenTime == null) return false;
    return DateTime.now().difference(_firstOpenTime!).inMinutes >=
        _gracePeriodMinutes;
  }

  /// True if an interstitial can be shown (grace period over + cooldown respected).
  bool get canShowInterstitial {
    if (!isGracePeriodOver) return false;
    if (_lastInterstitialShownTime == null) return true;
    return DateTime.now().difference(_lastInterstitialShownTime!).inMinutes >=
        _interstitialCooldownMinutes;
  }

  // ── Banner ────────────────────────────────────────────────────────────────

  /// Create a new banner ad (caller is responsible for load + dispose).
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  // ── Interstitial ──────────────────────────────────────────────────────────

  void _loadInterstitialAd() {
    if (_interstitialLoading) return;
    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  /// Show the pre-loaded interstitial if eligible. Returns true if shown.
  Future<bool> showInterstitialAd() async {
    if (!canShowInterstitial || _interstitialAd == null) return false;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
    _lastInterstitialShownTime = DateTime.now();
    return true;
  }

  // ── Rewarded ──────────────────────────────────────────────────────────────

  void _loadRewardedAd() {
    if (_rewardedLoading) return;
    _rewardedLoading = true;
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          _rewardedLoading = false;
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  /// True when a rewarded ad is ready to be shown.
  bool get isRewardedAdReady => isGracePeriodOver && _rewardedAd != null;

  /// Show the rewarded ad. [onRewarded] is called only when the user earns the reward.
  Future<void> showRewardedAd({
    required void Function(RewardItem reward) onRewarded,
  }) async {
    if (!isGracePeriodOver || _rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
    );

    await _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      onRewarded(reward);
    });
  }
}
