import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // DISCOVER (홈)
            _buildNavItem(
              iconPath: 'assets/icon/tabBar/discoverOn.svg',
              label: 'DISCOVER',
              isSelected: true,
              onTap: () {
                // 홈으로 이동
              },
            ),
            
            // LIKES
            _buildNavItem(
              iconPath: 'assets/icon/tabBar/likesOff.svg',
              label: 'LIKES',
              isSelected: false,
              onTap: () {
                // 좋아요 화면으로 이동
              },
            ),
            
            // DM
            _buildNavItem(
              iconPath: 'assets/icon/tabBar/dmOff.svg',
              label: 'DM',
              isSelected: false,
              onTap: () {
                // DM 화면으로 이동
              },
            ),
            
            // Profile
            _buildProfileItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: isSelected 
                ? null 
                : const ColorFilter.mode(
                    Color(0xFFAAAAAA),
                    BlendMode.srcIn,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem() {
    return GestureDetector(
      onTap: () {
        // 프로필 화면으로 이동
      },
      child: Container(
        width: 50,
        height: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF667BFF),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'DM',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF1E78),
                        shape: BoxShape.circle,
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