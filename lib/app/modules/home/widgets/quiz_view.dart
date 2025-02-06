import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:lesson/app/config/app_colors.dart';
import 'package:lesson/app/modules/home/controllers/home_controller.dart';
import 'package:lesson/data/models/course.dart';

class QuizView extends StatefulWidget {
  final Course course;

  const QuizView({
    super.key,
    required this.course,
  });

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late HomeController _courseController;

  int _currentQuestionIndex = 0;
  List<String?> _userAnswers = [];
  bool _hasAnswered = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userAnswers = List.filled(widget.course.quiz.length, null);
    _courseController = Get.find<HomeController>();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer(String selectedAnswer) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _userAnswers[_currentQuestionIndex] = selectedAnswer;

      if (selectedAnswer ==
          widget.course.quiz[_currentQuestionIndex].correctAns) {
        _score++;
      }
    });

    _animationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < widget.course.quiz.length - 1) {
        _nextQuestion();
      } else {
        _showResults();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _hasAnswered = false;
      _currentQuestionIndex++;
    });

    _animationController.reset();

    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showResults() async {
    // Mettre à jour le score dans la base de données
    await _courseController.updateQuizScore(widget.course.id, _score);

    final double percentage = _score / widget.course.quiz.length * 100;
    final bool isPassed = percentage >= 50;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête avec gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPassed
                        ? [
                            const Color(0xFF4CAF50).withOpacity(0.1),
                            const Color(0xFF81C784).withOpacity(0.1),
                          ]
                        : [
                            const Color(0xFFFF9800).withOpacity(0.1),
                            const Color(0xFFFFB74D).withOpacity(0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isPassed
                      ? FluentIcons.trophy_24_filled
                      : FluentIcons.book_24_filled,
                  size: 64,
                  color: isPassed
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 24),

              // Titre
              Text(
                isPassed ? 'Félicitations ! 🎉' : 'Continuez vos efforts ! 💪',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Score circulaire
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _score / widget.course.quiz.length,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPassed
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF9800),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${percentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '$_score/${widget.course.quiz.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Message de motivation
              Text(
                isPassed
                    ? 'Excellent travail ! Vous avez maîtrisé ce quiz.'
                    : 'Vous y êtes presque ! Réessayez pour améliorer votre score.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Quitter',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        setState(() {
                          _currentQuestionIndex = 0;
                          _userAnswers =
                              List.filled(widget.course.quiz.length, null);
                          _hasAnswered = false;
                          _score = 0;
                        });
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPassed
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF9800),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Réessayer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
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
                itemCount: widget.course.quiz.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                    _hasAnswered = false;
                  });
                },
                itemBuilder: (context, index) {
                  final quiz = widget.course.quiz[index];
                  return _buildQuestionCard(quiz);
                },
              ),
            ),
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
      child: Column(
        children: [
          Row(
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
                      'Quiz',
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
                  '${_currentQuestionIndex + 1}/${widget.course.quiz.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
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
          value: (_currentQuestionIndex + 1) / widget.course.quiz.length,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Quiz quiz) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        FluentIcons.brain_circuit_24_filled,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Question ${_currentQuestionIndex + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  quiz.question,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...quiz.options.map((option) => _buildOptionCard(option, quiz)),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String option, Quiz quiz) {
    final isSelected = _userAnswers[_currentQuestionIndex] == option;
    final isCorrect = option == quiz.correctAns;
    final showResult = _hasAnswered;

    Color getBackgroundColor() {
      if (!showResult) {
        return isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white;
      }
      if (isCorrect) return Colors.green[50]!;
      if (isSelected && !isCorrect) return Colors.red[50]!;
      return Colors.white;
    }

    Color getBorderColor() {
      if (!showResult) {
        return isSelected ? AppColors.primary : Colors.grey[200]!;
      }
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
      return Colors.grey[200]!;
    }

    return GestureDetector(
      onTap: () => _hasAnswered ? null : _checkAnswer(option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: getBorderColor(),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      showResult && isCorrect ? Colors.green : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (showResult && (isCorrect || isSelected)) ...[
              const SizedBox(width: 12),
              Icon(
                isCorrect
                    ? FluentIcons.checkmark_circle_24_filled
                    : FluentIcons.dismiss_circle_24_filled,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
