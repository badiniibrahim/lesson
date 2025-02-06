import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:lesson/app/config/app_colors.dart';
import 'package:lesson/data/models/course.dart';

class FlashcardsView extends StatefulWidget {
  final Course course;

  const FlashcardsView({
    super.key,
    required this.course,
  });

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  int _currentCardIndex = 0;
  bool _isBackVisible = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.isAnimating) return;

    if (_flipController.status == AnimationStatus.completed) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {
          _isBackVisible = _flipController.status == AnimationStatus.completed;
        });
      }
    });
  }

  void _nextCard() {
    if (_currentCardIndex < widget.course.flashcards.length - 1) {
      if (_isBackVisible) {
        _flipCard();
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousCard() {
    if (_currentCardIndex > 0) {
      if (_isBackVisible) {
        _flipCard();
      }
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentCardIndex = index;
                    _isBackVisible = false;
                  });
                },
                itemCount: widget.course.flashcards.length,
                itemBuilder: (context, index) {
                  return _buildFlashcard(widget.course.flashcards[index]);
                },
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                FluentIcons.arrow_left_24_regular,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flashcards',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.course.courseTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentCardIndex + 1}/${widget.course.flashcards.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: (_currentCardIndex + 1) / widget.course.flashcards.length,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildFlashcard(Flashcard flashcard) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final angle = _flipAnimation.value * 3.14159;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: angle < 3.14159 / 2
                    ? _buildCardFace(
                        flashcard.front,
                        FluentIcons.lightbulb_24_filled,
                        'Question',
                        true,
                      )
                    : Transform(
                        transform: Matrix4.identity()..rotateY(3.14159),
                        alignment: Alignment.center,
                        child: _buildCardFace(
                          flashcard.back,
                          FluentIcons.checkmark_circle_24_filled,
                          'Réponse',
                          false,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardFace(
      String content, IconData icon, String label, bool isFront) {
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFront
              ? [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary,
                ]
              : [
                  Colors.green.shade400,
                  Colors.green.shade600,
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                (isFront ? AppColors.primary : Colors.green).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            content,
            style: const TextStyle(
              fontSize: 24,
              height: 1.5,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (isFront)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.arrow_sync_24_regular,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Touchez pour retourner',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentCardIndex > 0 ? _previousCard : null,
            icon: Icon(
              FluentIcons.arrow_left_24_filled,
              color:
                  _currentCardIndex > 0 ? AppColors.primary : Colors.grey[300],
            ),
            style: IconButton.styleFrom(
              backgroundColor: _currentCardIndex > 0
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey[100],
              padding: const EdgeInsets.all(16),
            ),
          ),
          Text(
            '${_currentCardIndex + 1} / ${widget.course.flashcards.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: _currentCardIndex < widget.course.flashcards.length - 1
                ? _nextCard
                : null,
            icon: Icon(
              FluentIcons.arrow_right_24_filled,
              color: _currentCardIndex < widget.course.flashcards.length - 1
                  ? AppColors.primary
                  : Colors.grey[300],
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  _currentCardIndex < widget.course.flashcards.length - 1
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey[100],
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
