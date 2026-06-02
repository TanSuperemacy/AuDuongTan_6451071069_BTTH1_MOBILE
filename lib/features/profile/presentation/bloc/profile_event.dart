import 'package:flutter/foundation.dart';
import '../../data/models/profile_models.dart';

@immutable
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileHeaderEvent extends ProfileEvent {
  final String name;
  final String email;
  final String location;
  final String avatar;

  UpdateProfileHeaderEvent({
    required this.name,
    required this.email,
    required this.location,
    required this.avatar,
  });
}

class UpdateAboutMeEvent extends ProfileEvent {
  final String aboutMe;

  UpdateAboutMeEvent({required this.aboutMe});
}

// Work Experience
class AddWorkExperienceEvent extends ProfileEvent {
  final WorkExperienceModel experience;
  AddWorkExperienceEvent(this.experience);
}

class UpdateWorkExperienceEvent extends ProfileEvent {
  final WorkExperienceModel experience;
  UpdateWorkExperienceEvent(this.experience);
}

class DeleteWorkExperienceEvent extends ProfileEvent {
  final int id;
  DeleteWorkExperienceEvent(this.id);
}

// Education
class AddEducationEvent extends ProfileEvent {
  final EducationModel education;
  AddEducationEvent(this.education);
}

class UpdateEducationEvent extends ProfileEvent {
  final EducationModel education;
  UpdateEducationEvent(this.education);
}

class DeleteEducationEvent extends ProfileEvent {
  final int id;
  DeleteEducationEvent(this.id);
}

// Skills
class AddSkillEvent extends ProfileEvent {
  final String name;
  AddSkillEvent(this.name);
}

class DeleteSkillEvent extends ProfileEvent {
  final int id;
  DeleteSkillEvent(this.id);
}

// Languages
class AddLanguageEvent extends ProfileEvent {
  final String name;
  AddLanguageEvent(this.name);
}

class DeleteLanguageEvent extends ProfileEvent {
  final int id;
  DeleteLanguageEvent(this.id);
}

// Appreciation
class AddAppreciationEvent extends ProfileEvent {
  final AppreciationModel appreciation;
  AddAppreciationEvent(this.appreciation);
}

class UpdateAppreciationEvent extends ProfileEvent {
  final AppreciationModel appreciation;
  UpdateAppreciationEvent(this.appreciation);
}

class DeleteAppreciationEvent extends ProfileEvent {
  final int id;
  DeleteAppreciationEvent(this.id);
}
