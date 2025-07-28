import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/profile_component.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 390.0;

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Stack(
        children: [
          Column(
            children: [
              // StatusBarWidget
              Container(
                width: screenWidth,
                height: 44,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    // Time
                    Positioned(
                      left: 65 * scaleFactor,
                      top: 14,
                      child: SizedBox(
                        width: 54 * scaleFactor,
                        height: 21,
                        child: Center(
                          child: Text(
                            '9:41',
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              fontSize: 17 * scaleFactor,
                              color: const Color(0xFFFFFFFF),
                              letterSpacing: -0.408,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Status icons
                    Positioned(
                      right: 14 * scaleFactor,
                      top: 19,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 17 * scaleFactor, height: 10.7, color: Colors.white),
                          SizedBox(width: 1.5 * scaleFactor),
                          Container(width: 15.3 * scaleFactor, height: 11, color: Colors.white),
                          SizedBox(width: 1.5 * scaleFactor),
                          Container(
                            width: 24.3 * scaleFactor,
                            height: 11.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.65 * scaleFactor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.only(bottom: 80 * scaleFactor),
                    child: Column(
                      children: [
                      // HeaderTabSection
                      Container(
                        width: screenWidth,
                        height: 80,
                        padding: EdgeInsets.fromLTRB(19 * scaleFactor, 20, 19 * scaleFactor, 0),
                        child: Row(
                          children: [
                            // TabWrapper
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    '만남',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22 * scaleFactor,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  SizedBox(width: 16 * scaleFactor),
                                  Text(
                                    '근처',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22 * scaleFactor,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                  SizedBox(width: 16 * scaleFactor),
                                  Text(
                                    '함께',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22 * scaleFactor,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Buttons
                            Container(
                              width: 50 * scaleFactor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 24 * scaleFactor,
                                    height: 24 * scaleFactor,
                                    child: SvgPicture.asset(
                                      'assets/icon/24/bag.svg',
                                      width: 24 * scaleFactor,
                                      height: 24 * scaleFactor,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ProfileCardList with MemberCount
                      Container(
                        width: screenWidth,
                        height: 100,
                        padding: EdgeInsets.fromLTRB(20 * scaleFactor, 0, 32 * scaleFactor, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ProfileWrapper
                            Expanded(
                              child: Container(
                                height: 52 * scaleFactor,
                                child: Stack(
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      Positioned(
                                        left: i * 40.0 * scaleFactor,
                                        child: Container(
                                          width: 52 * scaleFactor,
                                          height: 52 * scaleFactor,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(26 * scaleFactor),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                                                offset: Offset(-10 * scaleFactor, 4 * scaleFactor),
                                                blurRadius: 20 * scaleFactor,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage(
                                                i == 0 ? 'assets/images/discover/profile1.png'
                                                : i == 1 ? 'assets/images/discover/profileSize52.png'
                                                : i == 2 ? 'assets/images/discover/profile2.png'
                                                : i == 3 ? 'assets/images/discover/profileSize30.png'
                                                : 'assets/images/discover/profile3.png'
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12 * scaleFactor),
                            // BottonWrapper
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '520명의 회원',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12 * scaleFactor,
                                    color: const Color(0xFFFFFFFF),
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 8 * scaleFactor),
                                Container(
                                  height: 24 * scaleFactor,
                                  padding: EdgeInsets.fromLTRB(10 * scaleFactor, 0, 6 * scaleFactor, 0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D92F2),
                                    borderRadius: BorderRadius.circular(14 * scaleFactor),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '전체보기',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11 * scaleFactor,
                                          color: const Color(0xFFFFFFFF),
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(width: 2 * scaleFactor),
                                      Container(
                                        width: 12 * scaleFactor,
                                        height: 12 * scaleFactor,
                                        child: SvgPicture.asset(
                                          'assets/icon/12/arrow.svg',
                                          width: 12 * scaleFactor,
                                          height: 12 * scaleFactor,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // KoreanResidentSection
                      Container(
                        width: screenWidth,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          children: [
                            // ContainerHeader
                            Container(
                              height: 60 * scaleFactor,
                              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icon/24/southKorea.png',
                                        width: 24 * scaleFactor,
                                        height: 24 * scaleFactor,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 4 * scaleFactor),
                                      Text(
                                        '한국에 살고있는 그녀',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16 * scaleFactor,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 24 * scaleFactor,
                                    height: 24 * scaleFactor,
                                    child: SvgPicture.asset(
                                      'assets/icon/24/arrowRight.svg',
                                      width: 16 * scaleFactor,
                                      height: 16 * scaleFactor,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // CardList
                            Container(
                              height: 280 * scaleFactor,
                              padding: EdgeInsets.only(left: 20 * scaleFactor),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildFeedCard(_FeedCardData(
                                    imageUrl: 'assets/images/discover/feedImage1.png',
                                    message: '이번주 금요일에 서울 도착했어요:) 홍대 투어 중',
                                    name: 'Jassie',
                                    age: '26',
                                  ), scaleFactor),
                                  _buildFeedCard(_FeedCardData(
                                    imageUrl: 'assets/images/discover/feedImage2.png',
                                    message: '남산타워 진짜 이쁘다...!!',
                                    name: 'Jassie',
                                    age: '26',
                                  ), scaleFactor),
                                  _buildFeedCard(_FeedCardData(
                                    imageUrl: 'assets/images/discover/feedImage3.png',
                                    message: '이번주 금요일에 서울 도착...',
                                    name: 'Jassie',
                                    age: '26',
                                  ), scaleFactor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // TravelPlannerSection
                      Container(
                        width: screenWidth,
                        padding: EdgeInsets.fromLTRB(0, 24 * scaleFactor, 0, 0),
                        child: Column(
                          children: [
                            // ContainerHeader
                            Container(
                              height: 60 * scaleFactor,
                              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icon/24/southKorea.png',
                                        width: 24 * scaleFactor,
                                        height: 24 * scaleFactor,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 4 * scaleFactor),
                                      Text(
                                        '한국 여행 예정인 그녀',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16 * scaleFactor,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 24 * scaleFactor,
                                    height: 24 * scaleFactor,
                                    child: SvgPicture.asset(
                                      'assets/icon/24/arrowRight.svg',
                                      width: 16 * scaleFactor,
                                      height: 16 * scaleFactor,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // TravelVerifiedCardList
                            Container(
                              height: 304 * scaleFactor,
                              padding: EdgeInsets.fromLTRB(20 * scaleFactor, 0, 0, 24 * scaleFactor),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  // VerifiedTravelerBannerCard
                                  Container(
                                    width: 160 * scaleFactor,
                                    height: 280 * scaleFactor,
                                    margin: EdgeInsets.only(right: 8 * scaleFactor),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF58A6EF),
                                      borderRadius: BorderRadius.circular(6 * scaleFactor),
                                    ),
                                    padding: EdgeInsets.all(16 * scaleFactor),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Verified\nTraveler',
                                          style: TextStyle(
                                            fontFamily: 'Funnel Display',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26 * scaleFactor,
                                            color: const Color(0xFFFFFFFF),
                                            height: 1.1,
                                          ),
                                        ),
                                        Container(
                                          width: 116 * scaleFactor,
                                          height: 40 * scaleFactor,
                                          child: SvgPicture.asset(
                                            'assets/images/discover/bannerPlane.svg',
                                            width: 116 * scaleFactor,
                                            height: 40 * scaleFactor,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '항공권을 인증한 그녀에게 메시지를 보내보세요',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12 * scaleFactor,
                                            color: const Color(0xFFFFFFFF),
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // TravelVerifiedProfileCards
                                  _buildTravelVerifiedCard(context, scaleFactor),
                                  _buildTravelVerifiedCard2(context, scaleFactor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // BottomNavigationBar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                child: Container(
                  width: screenWidth,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xB3000000),
                  ),
                  child: Column(
                    children: [
                      // BottomNavItemsRow
                      Container(
                        padding: EdgeInsets.fromLTRB(20 * scaleFactor, 12, 20 * scaleFactor, 0),
                        child: Row(
                          children: [
                            // DiscoverButtonContainer
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 24 * scaleFactor,
                                    height: 24 * scaleFactor,
                                    child: SvgPicture.asset(
                                      'assets/icon/24/discover.svg',
                                      width: 24 * scaleFactor,
                                      height: 24 * scaleFactor,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  SizedBox(height: 4 * scaleFactor),
                                  Text(
                                    'Discover',
                                    style: TextStyle(
                                      fontFamily: 'Funnel Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11 * scaleFactor,
                                      color: const Color(0xFFFFFFFF),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // LikesButtonContainer
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 24 * scaleFactor,
                                    height: 24 * scaleFactor,
                                    child: SvgPicture.asset(
                                      'assets/icon/24/likes.svg',
                                      width: 24 * scaleFactor,
                                      height: 24 * scaleFactor,
                                      color: const Color(0xFF777777),
                                    ),
                                  ),
                                  SizedBox(height: 4 * scaleFactor),
                                  Text(
                                    'LIKES',
                                    style: TextStyle(
                                      fontFamily: 'Funnel Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11 * scaleFactor,
                                      color: const Color(0xFF777777),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // DmButtonContainer
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 24 * scaleFactor,
                                    height: 24 * scaleFactor,
                                    child: SvgPicture.asset(
                                      'assets/icon/24/dmContainer.svg',
                                      width: 24 * scaleFactor,
                                      height: 24 * scaleFactor,
                                      color: const Color(0xFF777777),
                                    ),
                                  ),
                                  SizedBox(height: 4 * scaleFactor),
                                  Text(
                                    'DM',
                                    style: TextStyle(
                                      fontFamily: 'Funnel Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11 * scaleFactor,
                                      color: const Color(0xFF777777),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ProfileButtonContainer
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 30 * scaleFactor,
                                    height: 30 * scaleFactor,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15 * scaleFactor),
                                      image: const DecorationImage(
                                        image: AssetImage('assets/images/discover/profileSize30.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6 * scaleFactor),
                                  Container(
                                    width: 4 * scaleFactor,
                                    height: 4 * scaleFactor,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF777777),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required bool hasFlag,
    required List<_FeedCardData> cards,
    required double scaleFactor,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 24 * scaleFactor, 0, 24 * scaleFactor),
      child: Column(
        children: [
          // ContainerHeader
          Container(
            height: 60 * scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (hasFlag) ...[
                      Image.asset(
                        'assets/icon/24/southKorea.png',
                        width: 24 * scaleFactor,
                        height: 24 * scaleFactor,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 4 * scaleFactor),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        fontSize: 16 * scaleFactor,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 24 * scaleFactor,
                  height: 24 * scaleFactor,
                  child: SvgPicture.asset(
                    'assets/icon/24/arrowRight.svg',
                    width: 16 * scaleFactor,
                    height: 16 * scaleFactor,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // CardList
          Container(
            height: 280 * scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return _buildFeedCard(cards[index], scaleFactor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard(_FeedCardData data, double scaleFactor) {
    return Container(
      width: 160 * scaleFactor,
      margin: EdgeInsets.only(right: 8 * scaleFactor),
      child: Column(
        children: [
          // Profile Image with gradient
          Expanded(
            child: Container(
              width: 160 * scaleFactor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6 * scaleFactor),
                image: DecorationImage(
                  image: AssetImage(data.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6 * scaleFactor),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x14000000),
                      Color(0x99000000),
                    ],
                    stops: [0.6, 1.0],
                  ),
                ),
                padding: EdgeInsets.all(12 * scaleFactor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.message,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 12 * scaleFactor,
                        color: const Color(0xFFFFFFFF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12 * scaleFactor),
          // Profile info
          Row(
            children: [
              Container(
                width: 30 * scaleFactor,
                height: 30 * scaleFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15 * scaleFactor),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/discover/profileSize30.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10 * scaleFactor),
              Row(
                children: [
                  Text(
                    data.name,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 12 * scaleFactor,
                      color: const Color(0xFFFFFFFF),
                      height: 1.4,
                    ),
                  ),
                  Container(
                    width: 2 * scaleFactor,
                    height: 2 * scaleFactor,
                    margin: EdgeInsets.symmetric(horizontal: 4 * scaleFactor),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    data.age,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 12 * scaleFactor,
                      color: const Color(0xFFFFFFFF),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravelVerifiedCard(BuildContext context, double scaleFactor) {
    return Container(
      width: 160 * scaleFactor,
      height: 280 * scaleFactor,
      margin: EdgeInsets.only(right: 8 * scaleFactor),
      child: Column(
        children: [
          // Upper card
          Expanded(
            child: Container(
              width: 160 * scaleFactor,
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(6 * scaleFactor),
              ),
              padding: EdgeInsets.fromLTRB(12 * scaleFactor, 24 * scaleFactor, 12 * scaleFactor, 24 * scaleFactor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 24 * scaleFactor,
                    padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2058),
                      borderRadius: BorderRadius.circular(14 * scaleFactor),
                    ),
                    child: IntrinsicWidth(
                      child: Center(
                        child: Text(
                          '항공권인증',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 11 * scaleFactor,
                            color: const Color(0xFFFFFFFF),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * scaleFactor),
                  Text(
                    '@2025.07.25',
                    style: TextStyle(
                      fontFamily: 'Funnel Display',
                      fontWeight: FontWeight.w700,
                      fontSize: 13 * scaleFactor,
                      color: const Color(0xFFFFFFFF),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12 * scaleFactor),
                  Text(
                    'I\'m traveling to Korea for the first time this August. I\'m so excited',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Funnel Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 13 * scaleFactor,
                      color: const Color(0xFF999999),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(
            height: 2,
            width: 160 * scaleFactor,
            child: SvgPicture.asset(
              'assets/images/discover/divider.svg',
              width: 160 * scaleFactor,
              height: 2,
              fit: BoxFit.fill,
            ),
          ),
          // Lower card
          Container(
            height: 72 * scaleFactor,
            width: 160 * scaleFactor,
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(6 * scaleFactor),
            ),
            padding: EdgeInsets.all(12 * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30 * scaleFactor,
                      height: 30 * scaleFactor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15 * scaleFactor),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/discover/profileSize30.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Text(
                      'Jassie',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12 * scaleFactor,
                        color: const Color(0xFFFFFFFF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 16 * scaleFactor,
                  height: 16 * scaleFactor,
                  child: SvgPicture.asset(
                    'assets/icon/24/dm.svg',
                    width: 16 * scaleFactor,
                    height: 16 * scaleFactor,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelVerifiedCard2(BuildContext context, double scaleFactor) {
    return Container(
      width: 160 * scaleFactor,
      height: 280 * scaleFactor,
      margin: EdgeInsets.only(right: 8 * scaleFactor),
      child: Column(
        children: [
          // Upper card
          Expanded(
            child: Container(
              width: 160 * scaleFactor,
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(6 * scaleFactor),
              ),
              padding: EdgeInsets.fromLTRB(12 * scaleFactor, 24 * scaleFactor, 12 * scaleFactor, 24 * scaleFactor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 24 * scaleFactor,
                    padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2058),
                      borderRadius: BorderRadius.circular(14 * scaleFactor),
                    ),
                    child: IntrinsicWidth(
                      child: Center(
                        child: Text(
                          '항공권인증',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 11 * scaleFactor,
                            color: const Color(0xFFFFFFFF),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * scaleFactor),
                  Text(
                    '@2025.07.25',
                    style: TextStyle(
                      fontFamily: 'Funnel Display',
                      fontWeight: FontWeight.w700,
                      fontSize: 13 * scaleFactor,
                      color: const Color(0xFFFFFFFF),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12 * scaleFactor),
                  Text(
                    'I\'m traveling to Korea for the first time this August. I\'m so excited',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Funnel Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 13 * scaleFactor,
                      color: const Color(0xFF999999),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(
            height: 2,
            width: 160 * scaleFactor,
            child: SvgPicture.asset(
              'assets/images/discover/divider.svg',
              width: 160 * scaleFactor,
              height: 2,
              fit: BoxFit.fill,
            ),
          ),
          // Lower card
          Container(
            height: 72 * scaleFactor,
            width: 160 * scaleFactor,
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(6 * scaleFactor),
            ),
            padding: EdgeInsets.all(12 * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30 * scaleFactor,
                      height: 30 * scaleFactor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15 * scaleFactor),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/discover/profileSize30.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Text(
                      'Jassie',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12 * scaleFactor,
                        color: const Color(0xFFFFFFFF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 16 * scaleFactor,
                  height: 16 * scaleFactor,
                  child: SvgPicture.asset(
                    'assets/icon/24/dmContainer.svg',
                    width: 16 * scaleFactor,
                    height: 16 * scaleFactor,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedCardData {
  final String imageUrl;
  final String message;
  final String name;
  final String age;

  _FeedCardData({
    required this.imageUrl,
    required this.message,
    required this.name,
    required this.age,
  });
}