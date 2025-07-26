class User {
  // 기본 정보 (1단계)
  final String nickname;
  final String birthdate;
  final DateTime selectedDate;
  final String phoneNumber;
  final bool phoneVerified;
  final String gender; // 'male', 'female'
  
  // 프로필 사진 (2단계)
  final List<String> profilePhotos;
  final bool faceVerified;
  
  // 자기소개 (3단계)
  final String height;
  final String bodyType;
  final String nationality;
  final String? mbti;
  final List<String> languages;
  final String greeting;
  final bool hasVoiceGreeting;
  
  // 인증 관련
  final String uid;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // 외국인 여성 전용 필드
  final String? travelStatus; // 'scheduled', 'traveling_unverified', 'traveling_verified'
  final String? airlineTicketPath;
  final DateTime? scheduledArrivalDate;
  final DateTime? lastLocationVerified;
  
  // 프로필 상태
  final bool isActive;
  final bool isProfileComplete;

  const User({
    required this.nickname,
    required this.birthdate,
    required this.selectedDate,
    required this.phoneNumber,
    required this.phoneVerified,
    required this.gender,
    required this.profilePhotos,
    required this.faceVerified,
    required this.height,
    required this.bodyType,
    required this.nationality,
    this.mbti,
    required this.languages,
    required this.greeting,
    required this.hasVoiceGreeting,
    required this.uid,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.travelStatus,
    this.airlineTicketPath,
    this.scheduledArrivalDate,
    this.lastLocationVerified,
    required this.isActive,
    required this.isProfileComplete,
  });

  // 나이 계산
  int get age {
    final now = DateTime.now();
    int age = now.year - selectedDate.year;
    if (now.month < selectedDate.month || 
        (now.month == selectedDate.month && now.day < selectedDate.day)) {
      age--;
    }
    return age;
  }

  // 한국인 남성 여부 확인
  bool get isKoreanMale {
    return nationality == '대한민국' && gender == 'male';
  }

  // 외국인 여성 여부 확인
  bool get isForeignFemale {
    return nationality != '대한민국' && gender == 'female';
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'birthdate': birthdate,
      'selectedDate': selectedDate.toIso8601String(),
      'phoneNumber': phoneNumber,
      'phoneVerified': phoneVerified,
      'gender': gender,
      'profilePhotos': profilePhotos,
      'faceVerified': faceVerified,
      'height': height,
      'bodyType': bodyType,
      'nationality': nationality,
      'mbti': mbti,
      'languages': languages,
      'greeting': greeting,
      'hasVoiceGreeting': hasVoiceGreeting,
      'uid': uid,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'travelStatus': travelStatus,
      'airlineTicketPath': airlineTicketPath,
      'scheduledArrivalDate': scheduledArrivalDate?.toIso8601String(),
      'lastLocationVerified': lastLocationVerified?.toIso8601String(),
      'isActive': isActive,
      'isProfileComplete': isProfileComplete,
    };
  }

  // JSON 역직렬화
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'] as String,
      birthdate: json['birthdate'] as String,
      selectedDate: DateTime.parse(json['selectedDate'] as String),
      phoneNumber: json['phoneNumber'] as String,
      phoneVerified: json['phoneVerified'] as bool,
      gender: json['gender'] as String,
      profilePhotos: List<String>.from(json['profilePhotos'] as List),
      faceVerified: json['faceVerified'] as bool,
      height: json['height'] as String,
      bodyType: json['bodyType'] as String,
      nationality: json['nationality'] as String,
      mbti: json['mbti'] as String?,
      languages: List<String>.from(json['languages'] as List),
      greeting: json['greeting'] as String,
      hasVoiceGreeting: json['hasVoiceGreeting'] as bool,
      uid: json['uid'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      travelStatus: json['travelStatus'] as String?,
      airlineTicketPath: json['airlineTicketPath'] as String?,
      scheduledArrivalDate: json['scheduledArrivalDate'] != null 
          ? DateTime.parse(json['scheduledArrivalDate'] as String)
          : null,
      lastLocationVerified: json['lastLocationVerified'] != null
          ? DateTime.parse(json['lastLocationVerified'] as String)
          : null,
      isActive: json['isActive'] as bool,
      isProfileComplete: json['isProfileComplete'] as bool,
    );
  }

  // copyWith 메서드
  User copyWith({
    String? nickname,
    String? birthdate,
    DateTime? selectedDate,
    String? phoneNumber,
    bool? phoneVerified,
    String? gender,
    List<String>? profilePhotos,
    bool? faceVerified,
    String? height,
    String? bodyType,
    String? nationality,
    String? mbti,
    List<String>? languages,
    String? greeting,
    bool? hasVoiceGreeting,
    String? uid,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? travelStatus,
    String? airlineTicketPath,
    DateTime? scheduledArrivalDate,
    DateTime? lastLocationVerified,
    bool? isActive,
    bool? isProfileComplete,
  }) {
    return User(
      nickname: nickname ?? this.nickname,
      birthdate: birthdate ?? this.birthdate,
      selectedDate: selectedDate ?? this.selectedDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      gender: gender ?? this.gender,
      profilePhotos: profilePhotos ?? this.profilePhotos,
      faceVerified: faceVerified ?? this.faceVerified,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      nationality: nationality ?? this.nationality,
      mbti: mbti ?? this.mbti,
      languages: languages ?? this.languages,
      greeting: greeting ?? this.greeting,
      hasVoiceGreeting: hasVoiceGreeting ?? this.hasVoiceGreeting,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      travelStatus: travelStatus ?? this.travelStatus,
      airlineTicketPath: airlineTicketPath ?? this.airlineTicketPath,
      scheduledArrivalDate: scheduledArrivalDate ?? this.scheduledArrivalDate,
      lastLocationVerified: lastLocationVerified ?? this.lastLocationVerified,
      isActive: isActive ?? this.isActive,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'User(uid: $uid, nickname: $nickname, gender: $gender, nationality: $nationality, age: $age)';
  }
}