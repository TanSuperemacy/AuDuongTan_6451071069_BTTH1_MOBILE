import 'package:flutter/foundation.dart';
import '../../data/models/profile_models.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final List<WorkExperienceModel> workExperiences;
  final List<EducationModel> educations;
  final List<SkillModel> skills;
  final List<LanguageModel> languages;
  final List<AppreciationModel> appreciations;

  ProfileLoaded({
    required this.profile,
    required this.workExperiences,
    required this.educations,
    required this.skills,
    required this.languages,
    required this.appreciations,
  });

  ProfileLoaded copyWith({
    ProfileModel? profile,
    List<WorkExperienceModel>? workExperiences,
    List<EducationModel>? educations,
    List<SkillModel>? skills,
    List<LanguageModel>? languages,
    List<AppreciationModel>? appreciations,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      workExperiences: workExperiences ?? this.workExperiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      appreciations: appreciations ?? this.appreciations,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
