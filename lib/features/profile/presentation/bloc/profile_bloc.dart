import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/database_helper.dart';
import '../../data/models/profile_models.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileHeaderEvent>(_onUpdateProfileHeader);
    on<UpdateAboutMeEvent>(_onUpdateAboutMe);

    // Work Experience
    on<AddWorkExperienceEvent>(_onAddWorkExperience);
    on<UpdateWorkExperienceEvent>(_onUpdateWorkExperience);
    on<DeleteWorkExperienceEvent>(_onDeleteWorkExperience);

    // Education
    on<AddEducationEvent>(_onAddEducation);
    on<UpdateEducationEvent>(_onUpdateEducation);
    on<DeleteEducationEvent>(_onDeleteEducation);

    // Skills
    on<AddSkillEvent>(_onAddSkill);
    on<DeleteSkillEvent>(_onDeleteSkill);

    // Languages
    on<AddLanguageEvent>(_onAddLanguage);
    on<DeleteLanguageEvent>(_onDeleteLanguage);

    // Appreciation
    on<AddAppreciationEvent>(_onAddAppreciation);
    on<UpdateAppreciationEvent>(_onUpdateAppreciation);
    on<DeleteAppreciationEvent>(_onDeleteAppreciation);
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể tải thông tin cá nhân: $e'));
    }
  }

  Future<void> _onUpdateProfileHeader(UpdateProfileHeaderEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.updateProfile({
        'name': event.name,
        'email': event.email,
        'location': event.location,
        'avatar': event.avatar,
      });
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể cập nhật thông tin chung: $e'));
    }
  }

  Future<void> _onUpdateAboutMe(UpdateAboutMeEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.updateProfile({
        'about_me': event.aboutMe,
      });
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể cập nhật thông tin giới thiệu: $e'));
    }
  }

  // Work Experience
  Future<void> _onAddWorkExperience(AddWorkExperienceEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.addWorkExperience(event.experience.toSqliteMap());
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể thêm kinh nghiệm làm việc: $e'));
    }
  }

  Future<void> _onUpdateWorkExperience(UpdateWorkExperienceEvent event, Emitter<ProfileState> emit) async {
    try {
      if (event.experience.id != null) {
        await _dbHelper.updateWorkExperience(event.experience.id!, event.experience.toSqliteMap());
        final data = await _fetchFullProfile();
        emit(data);
      }
    } catch (e) {
      emit(ProfileError('Không thể cập nhật kinh nghiệm làm việc: $e'));
    }
  }

  Future<void> _onDeleteWorkExperience(DeleteWorkExperienceEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.deleteWorkExperience(event.id);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể xóa kinh nghiệm làm việc: $e'));
    }
  }

  // Education
  Future<void> _onAddEducation(AddEducationEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.addEducation(event.education.toSqliteMap());
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể thêm học vấn: $e'));
    }
  }

  Future<void> _onUpdateEducation(UpdateEducationEvent event, Emitter<ProfileState> emit) async {
    try {
      if (event.education.id != null) {
        await _dbHelper.updateEducation(event.education.id!, event.education.toSqliteMap());
        final data = await _fetchFullProfile();
        emit(data);
      }
    } catch (e) {
      emit(ProfileError('Không thể cập nhật học vấn: $e'));
    }
  }

  Future<void> _onDeleteEducation(DeleteEducationEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.deleteEducation(event.id);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể xóa học vấn: $e'));
    }
  }

  // Skills
  Future<void> _onAddSkill(AddSkillEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.addSkill(event.name);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể thêm kỹ năng: $e'));
    }
  }

  Future<void> _onDeleteSkill(DeleteSkillEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.deleteSkill(event.id);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể xóa kỹ năng: $e'));
    }
  }

  // Languages
  Future<void> _onAddLanguage(AddLanguageEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.addLanguage(event.name);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể thêm ngôn ngữ: $e'));
    }
  }

  Future<void> _onDeleteLanguage(DeleteLanguageEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.deleteLanguage(event.id);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể xóa ngôn ngữ: $e'));
    }
  }

  // Appreciation
  Future<void> _onAddAppreciation(AddAppreciationEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.addAppreciation(event.appreciation.toSqliteMap());
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể thêm giải thưởng/chứng nhận: $e'));
    }
  }

  Future<void> _onUpdateAppreciation(UpdateAppreciationEvent event, Emitter<ProfileState> emit) async {
    try {
      if (event.appreciation.id != null) {
        await _dbHelper.updateAppreciation(event.appreciation.id!, event.appreciation.toSqliteMap());
        final data = await _fetchFullProfile();
        emit(data);
      }
    } catch (e) {
      emit(ProfileError('Không thể cập nhật giải thưởng/chứng nhận: $e'));
    }
  }

  Future<void> _onDeleteAppreciation(DeleteAppreciationEvent event, Emitter<ProfileState> emit) async {
    try {
      await _dbHelper.deleteAppreciation(event.id);
      final data = await _fetchFullProfile();
      emit(data);
    } catch (e) {
      emit(ProfileError('Không thể xóa giải thưởng/chứng nhận: $e'));
    }
  }

  // Private Helper to Fetch all details & wrap in ProfileLoaded state
  Future<ProfileLoaded> _fetchFullProfile() async {
    final profileMap = await _dbHelper.getProfile();
    final profile = ProfileModel.fromMap(profileMap ?? {
      'id': 1,
      'name': 'Nguyễn Văn A',
      'email': 'fithou@agent.etc.vn',
      'location': 'California, USA',
      'avatar': '',
      'followers': '120k',
      'following': '23k',
      'about_me': '',
    });

    final experiencesMaps = await _dbHelper.getWorkExperiences();
    final experiences = experiencesMaps.map((m) => WorkExperienceModel.fromMap(m)).toList();

    final educationMaps = await _dbHelper.getEducations();
    final educations = educationMaps.map((m) => EducationModel.fromMap(m)).toList();

    final skillsMaps = await _dbHelper.getSkills();
    final skills = skillsMaps.map((m) => SkillModel.fromMap(m)).toList();

    final languageMaps = await _dbHelper.getLanguages();
    final languages = languageMaps.map((m) => LanguageModel.fromMap(m)).toList();

    final appreciationMaps = await _dbHelper.getAppreciations();
    final appreciations = appreciationMaps.map((m) => AppreciationModel.fromMap(m)).toList();

    return ProfileLoaded(
      profile: profile,
      workExperiences: experiences,
      educations: educations,
      skills: skills,
      languages: languages,
      appreciations: appreciations,
    );
  }
}
