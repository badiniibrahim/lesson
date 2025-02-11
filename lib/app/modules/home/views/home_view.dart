import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesson/app/config/app_colors.dart';
import 'package:lesson/app/core/di/service_locator.dart';
import 'package:lesson/app/modules/home/widgets/course_detail.dart';
import 'package:lesson/app/routes/app_pages.dart';
import 'package:lesson/data/models/course.dart';
import 'package:lesson/domain/usecase/generate_usecase.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  final controller = Get.put(
      HomeController(generateTopicUsecase: getIt<GenerateTopicUsecase>()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildWelcomeSection(),
                    _buildQuickStats(),
                    _buildCourseSection(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: CirclePatternPainter(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          'home_title'.tr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home_helle'.tr,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'home_message'.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                FluentIcons.book_24_filled,
                controller.state.courseList.length.toString(),
                'home_total'.tr,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStatItem(
                FluentIcons.timer_24_filled,
                '${controller.state.courseList.length * 2}h',
                'home_time'.tr,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStatItem(
                FluentIcons.trophy_24_filled,
                '${controller.state.courseList.length * 10}%',
                'home_prog'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseSection() {
    if (controller.state.courseList.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes cours',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(FluentIcons.arrow_sort_24_regular),
                label: const Text('Trier'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.state.courseList.length,
            itemBuilder: (context, index) {
              final course = controller.state.courseList[index];
              return _buildCourseCard(course);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return GestureDetector(
      onTap: () => Get.to(
        () => CourseDetailView(course: course),
        transition: Transition.fadeIn,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1499856871958-5b9627545d1a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3MDE5MTZ8MHwxfHNlYXJjaHwxfHxwYXJpc3xlbnwwfHx8fDE3Mzg3NzExNTV8MA&ixlib=rb-4.0.3&q=80&w=1080",
                      //course.bannerImage,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          course.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildCourseMetric(
                        FluentIcons.book_24_regular,
                        '${course.chapters.length} chapitres',
                        Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildCourseMetric(
                        FluentIcons.timer_24_regular,
                        '${course.chapters.length * 30} min',
                        Colors.orange,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          FluentIcons.play_24_filled,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseMetric(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FluentIcons.book_24_filled,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'home_empty_title'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'home_empty_message'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.CREATE_COURSE_GENERATE_TOPIC),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'home_create'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(Routes.CREATE_COURSE_GENERATE_TOPIC),
      backgroundColor: AppColors.primary,
      icon: const Icon(FluentIcons.add_24_filled),
      label: Text(
        'home_new'.tr,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 5; i++) {
      final radius = (i + 1) * 30.0;
      canvas.drawCircle(
        Offset(size.width - 50, 50),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
