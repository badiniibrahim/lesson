import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesson/app/config/app_colors.dart';
import 'package:lesson/app/modules/explore/views/explore_view.dart';
import 'package:lesson/app/modules/home/views/home_view.dart';
import 'package:lesson/app/modules/profile/views/profile_view.dart';
import 'package:lesson/app/modules/progress/views/progress_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: IndexedStack(
            index: controller.selectedIndex,
            children: [
              HomeView(),
              ExploreView(),
              ProgressView(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(controller),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                iconOutlined: Icons.home_outlined,
                label: 'dashboard_home'.tr,
                isSelected: controller.selectedIndex == 0,
                onTap: () => controller.onItemTapped(0),
              ),
              _buildNavItem(
                icon: Icons.explore_rounded,
                iconOutlined: Icons.explore_outlined,
                label: 'dashboard_explore'.tr,
                isSelected: controller.selectedIndex == 1,
                onTap: () => controller.onItemTapped(1),
              ),
              _buildNavItem(
                icon: Icons.bar_chart_rounded,
                iconOutlined: Icons.bar_chart_outlined,
                label: 'dashboard_progress'.tr,
                isSelected: controller.selectedIndex == 2,
                onTap: () => controller.onItemTapped(2),
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                iconOutlined: Icons.person_outline_rounded,
                label: 'dashboard_profile'.tr,
                isSelected: controller.selectedIndex == 3,
                onTap: () => controller.onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData iconOutlined,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? icon : iconOutlined,
              color: isSelected ? AppColors.primary : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
