class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String location;
  final String avatar;
  final String followers;
  final String following;
  final String aboutMe;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.avatar,
    required this.followers,
    required this.following,
    required this.aboutMe,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? 1,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      avatar: map['avatar'] ?? '',
      followers: map['followers'] ?? '0',
      following: map['following'] ?? '0',
      aboutMe: map['about_me'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'location': location,
      'avatar': avatar,
      'followers': followers,
      'following': following,
      'about_me': aboutMe,
    };
  }

  ProfileModel copyWith({
    int? id,
    String? name,
    String? email,
    String? location,
    String? avatar,
    String? followers,
    String? following,
    String? aboutMe,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      avatar: avatar ?? this.avatar,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      aboutMe: aboutMe ?? this.aboutMe,
    );
  }
}

class WorkExperienceModel {
  final int? id;
  final String role;
  final String company;
  final String startDate;
  final String endDate;
  final String duration;

  WorkExperienceModel({
    this.id,
    required this.role,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.duration,
  });

  factory WorkExperienceModel.fromMap(Map<String, dynamic> map) {
    return WorkExperienceModel(
      id: map['id'],
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      duration: map['duration'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'role': role,
      'company': company,
      'start_date': startDate,
      'end_date': endDate,
      'duration': duration,
    };
    if (id != null) {
      map['id'] = id as String; // sqlite will parse keys correctly or dynamic mapping
    }
    return map;
  }

  Map<String, dynamic> toSqliteMap() {
    return {
      if (id != null) 'id': id,
      'role': role,
      'company': company,
      'start_date': startDate,
      'end_date': endDate,
      'duration': duration,
    };
  }
}

class EducationModel {
  final int? id;
  final String field;
  final String school;
  final String startDate;
  final String endDate;
  final String duration;

  EducationModel({
    this.id,
    required this.field,
    required this.school,
    required this.startDate,
    required this.endDate,
    required this.duration,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      id: map['id'],
      field: map['field'] ?? '',
      school: map['school'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      duration: map['duration'] ?? '',
    );
  }

  Map<String, dynamic> toSqliteMap() {
    return {
      if (id != null) 'id': id,
      'field': field,
      'school': school,
      'start_date': startDate,
      'end_date': endDate,
      'duration': duration,
    };
  }
}

class SkillModel {
  final int id;
  final String name;

  SkillModel({
    required this.id,
    required this.name,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class LanguageModel {
  final int id;
  final String name;

  LanguageModel({
    required this.id,
    required this.name,
  });

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class AppreciationModel {
  final int? id;
  final String title;
  final String award;
  final String year;

  AppreciationModel({
    this.id,
    required this.title,
    required this.award,
    required this.year,
  });

  factory AppreciationModel.fromMap(Map<String, dynamic> map) {
    return AppreciationModel(
      id: map['id'],
      title: map['title'] ?? '',
      award: map['award'] ?? '',
      year: map['year'] ?? '',
    );
  }

  Map<String, dynamic> toSqliteMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'award': award,
      'year': year,
    };
  }
}
