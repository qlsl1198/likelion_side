class Study {
  final int id;
  final String title;
  final String description;
  final String category;
  final String location;
  final int maxParticipants;
  final int currentParticipants;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String studyType;
  final String? meetingLink;
  final String? contactInfo;
  final User leader;
  final List<StudyMember> members;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLeader;
  final bool isMember;

  Study({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.studyType,
    this.meetingLink,
    this.contactInfo,
    required this.leader,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    required this.isLeader,
    required this.isMember,
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      category: json['category'],
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      status: json['status'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      studyType: json['studyType'],
      meetingLink: json['meetingLink'],
      contactInfo: json['contactInfo'],
      leader: User.fromJson(json['leader']),
      members: (json['members'] as List)
          .map((member) => StudyMember.fromJson(member))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isLeader: json['isLeader'] ?? false,
      isMember: json['isMember'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'studyType': studyType,
      'meetingLink': meetingLink,
      'contactInfo': contactInfo,
      'leader': leader.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isLeader': isLeader,
      'isMember': isMember,
    };
  }
  
  bool isFull() {
    return currentParticipants >= maxParticipants;
  }
}

class StudyList {
  final int id;
  final String title;
  final String category;
  final String location;
  final int maxParticipants;
  final int currentParticipants;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String studyType;
  final User leader;
  final DateTime createdAt;

  StudyList({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.studyType,
    required this.leader,
    required this.createdAt,
  });

  factory StudyList.fromJson(Map<String, dynamic> json) {
    return StudyList(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      status: json['status'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      studyType: json['studyType'],
      leader: User.fromJson(json['leader']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'location': location,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'studyType': studyType,
      'leader': leader.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class StudyMember {
  final int id;
  final User user;
  final String role;
  final String status;
  final DateTime joinedAt;

  StudyMember({
    required this.id,
    required this.user,
    required this.role,
    required this.status,
    required this.joinedAt,
  });

  factory StudyMember.fromJson(Map<String, dynamic> json) {
    return StudyMember(
      id: json['id'],
      user: User.fromJson(json['user']),
      role: json['role'],
      status: json['status'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'role': role,
      'status': status,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}

class User {
  final int id;
  final String email;
  final String name;
  final String? nickname;
  final DateTime? birthDate;
  final String? occupation;
  final String? educationLevel;
  final String status;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.nickname,
    this.birthDate,
    this.occupation,
    this.educationLevel,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      nickname: json['nickname'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      occupation: json['occupation'],
      educationLevel: json['educationLevel'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'nickname': nickname,
      'birthDate': birthDate?.toIso8601String(),
      'occupation': occupation,
      'educationLevel': educationLevel,
      'status': status,
    };
  }
}

class StudyCreateRequest {
  final String title;
  final String description;
  final String category;
  final String location;
  final int maxParticipants;
  final DateTime startDate;
  final DateTime endDate;
  final String studyType;
  final String? meetingLink;
  final String? contactInfo;

  StudyCreateRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.maxParticipants,
    required this.startDate,
    required this.endDate,
    required this.studyType,
    this.meetingLink,
    this.contactInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'maxParticipants': maxParticipants,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'studyType': studyType,
      'meetingLink': meetingLink,
      'contactInfo': contactInfo,
    };
  }
}

class StudyUpdateRequest {
  final String? title;
  final String? description;
  final String? category;
  final String? location;
  final int? maxParticipants;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? studyType;
  final String? meetingLink;
  final String? contactInfo;
  final String? status;

  StudyUpdateRequest({
    this.title,
    this.description,
    this.category,
    this.location,
    this.maxParticipants,
    this.startDate,
    this.endDate,
    this.studyType,
    this.meetingLink,
    this.contactInfo,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category;
    if (location != null) data['location'] = location;
    if (maxParticipants != null) data['maxParticipants'] = maxParticipants;
    if (startDate != null) data['startDate'] = startDate!.toIso8601String();
    if (endDate != null) data['endDate'] = endDate!.toIso8601String();
    if (studyType != null) data['studyType'] = studyType;
    if (meetingLink != null) data['meetingLink'] = meetingLink;
    if (contactInfo != null) data['contactInfo'] = contactInfo;
    if (status != null) data['status'] = status;
    return data;
  }
} 