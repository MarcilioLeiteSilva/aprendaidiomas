import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/models.dart';
import '../services/database_helper.dart';
import '../services/ad_helper.dart';
import '../theme/app_theme.dart';
import '../services/tts_helper.dart';

class FlashcardScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String type; // 'words' or 'phrases'
  final String language;

  const FlashcardScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.language,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final dbHelper = DatabaseHelper();
  final FlutterTts flutterTts = FlutterTts();
  final PageController _pageController = PageController();
  List<dynamic> items = [];
  bool isLoading = true;
  int _currentPage = 0;

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _initTts().then((_) {
      if (mounted) {
        _loadData();
      }
    });
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _pageController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await TtsHelper.initTts(flutterTts);
  }

  void _speak(String text) async {
    debugPrint("TTS speaking: $text");
    await flutterTts.speak(text);
  }


  Future<void> _loadData() async {
    List<dynamic> data;
    if (widget.type == 'words') {
      data = await dbHelper.getWordsByCategoryId(widget.categoryId);
    } else {
      data = await dbHelper.getPhrasesByCategoryId(widget.categoryId);
    }

    setState(() {
      items = data;
      isLoading = false;
      if (items.isNotEmpty) {
        final item = items.first;
        final String target = item is LearnWord ? item.getByLanguage(widget.language) : (item as LearnPhrase).getByLanguage(widget.language);
        _speak(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: Column(
          children: [
            if (_isBannerAdReady && _bannerAd != null)
              SafeArea(
                bottom: false,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const Center(child: Text("Nenhum item encontrado nesta categoria."))
                      : Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: items.length,
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                  final item = items[index];
                                  final String target = item is LearnWord ? item.getByLanguage(widget.language) : (item as LearnPhrase).getByLanguage(widget.language);
                                  _speak(target);
                                },
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final String nativeWord = item is LearnWord ? item.portuguese : (item as LearnPhrase).portuguese;
                                  final String target = item is LearnWord ? item.getByLanguage(widget.language) : (item as LearnPhrase).getByLanguage(widget.language);

                                  return _FlashcardItem(
                                    nativeWord: nativeWord,
                                    translated: target,
                                    index: index + 1,
                                    totalCount: items.length,
                                    onReplay: () => _speak(target),
                                  );
                                },
                              ),
                            ),
                            // Page dot indicator
                            if (items.length > 1)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    items.length > 8 ? 8 : items.length,
                                    (i) {
                                      // Show dots for up to 8 cards; if more, show compact version
                                      final bool isActive = i == (_currentPage > 7 ? 7 : _currentPage);
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        height: 8,
                                        width: isActive ? 24 : 8,
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? AppTheme.accentColor
                                              : Colors.white.withAlpha(50),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashcardItem extends StatefulWidget {
  final String nativeWord;
  final String translated;
  final int index;
  final int totalCount;
  final VoidCallback onReplay;

  const _FlashcardItem({
    required this.nativeWord,
    required this.translated,
    required this.index,
    required this.totalCount,
    required this.onReplay,
  });

  @override
  State<_FlashcardItem> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<_FlashcardItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  void _toggle() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => isFront = !isFront);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _controller.value * 3.14159265;
            final isBack = angle > 1.570796;

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: isBack
                  ? Transform(
                      transform: Matrix4.identity()..rotateY(3.14159265),
                      alignment: Alignment.center,
                      // The back of the card shows the native Portuguese translation
                      child: _buildCardContent(widget.nativeWord, true),
                    )
                  // The front shows the language they are learning (English)
                  : _buildCardContent(widget.translated, false),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContent(String text, bool isTranslation) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Card surface
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isTranslation ? AppTheme.accentColor.withAlpha(50) : Colors.white.withAlpha(15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isTranslation ? AppTheme.accentColor : AppTheme.primaryColor).withAlpha(30),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Index text
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "${widget.index} / ${widget.totalCount}",
              style: TextStyle(color: AppTheme.textHintColor, fontSize: 13),
            ),
          ),
          // Side indicator and replay button
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isTranslation)
                  GestureDetector(
                    onTap: widget.onReplay,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.volume_up_rounded, color: AppTheme.textColor, size: 28),
                    ),
                  ),
                const SizedBox(width: 4),
                Text(
                  isTranslation ? "VERIFIQUE" : "TAP TO REVEAL",
                  style: TextStyle(
                    color: isTranslation ? AppTheme.accentColor : AppTheme.textHintColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Main text
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isTranslation ? AppTheme.accentColor : AppTheme.textColor,
              ),
            ),
          ),
        ].reversed.toList(), // Reversed to keep stacks correct on flip back
      ),
    );
  }
}
