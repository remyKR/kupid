import 'package:flutter/material.dart';

enum ProfileSize {
  size30,
  size52,
}

class ProfileComponent extends StatelessWidget {
  final ProfileSize size;
  final String? imageUrl;
  
  const ProfileComponent({
    super.key,
    this.size = ProfileSize.size52,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return _buildProfile();
  }

  Widget _buildProfile() {
    switch (size) {
      case ProfileSize.size30:
        return _buildSize30();
      case ProfileSize.size52:
        return _buildSize52();
    }
  }

  Widget _buildSize30() {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: imageUrl != null
            ? DecorationImage(
                image: AssetImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/default_profile_30.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildSize52() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.7),
            offset: Offset(-10, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        image: imageUrl != null
            ? DecorationImage(
                image: AssetImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/default_profile_52.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

// 사용 예시 위젯
class ProfileExample extends StatelessWidget {
  const ProfileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Size 52 (기본값)
        ProfileComponent(),
        
        SizedBox(height: 20),
        
        // Size 30
        ProfileComponent(size: ProfileSize.size30),
        
        SizedBox(height: 20),
        
        // 커스텀 이미지 URL
        ProfileComponent(
          size: ProfileSize.size52,
          imageUrl: 'https://example.com/profile.jpg',
        ),
      ],
    );
  }
}