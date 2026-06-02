import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/models/profile_models.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = sl<ProfileBloc>()..add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFE5E5E5), // Matches user UI Background: #E5E5E5
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryNavy),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _profileBloc.add(LoadProfileEvent()),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              return _buildProfileContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    final profile = state.profile;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeaderCard(context, profile),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildAboutMeSection(context, profile.aboutMe),
                const SizedBox(height: 16),
                _buildWorkExperienceSection(context, state.workExperiences),
                const SizedBox(height: 16),
                _buildEducationSection(context, state.educations),
                const SizedBox(height: 16),
                _buildSkillsSection(context, state.skills),
                const SizedBox(height: 16),
                _buildLanguagesSection(context, state.languages),
                const SizedBox(height: 16),
                _buildApprecationsSection(context, state.appreciations),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Curved Gradient Header Card ────────────────────────────────────────
  Widget _buildHeaderCard(BuildContext context, ProfileModel profile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3E1B73), // Deep premium purple wave
            Color(0xFF130160), // App primaryNavy
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 28, left: 24, right: 24),
      child: Column(
        children: [
          // Header Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Text(
                'Profile',
                style: AppTextStyles.logoText.copyWith(fontSize: 18),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white, size: 22),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          // Circular Avatar with Premium Golden Ring
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.orangeAccent, width: 2.5),
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: AppColors.accentLightPurple,
              backgroundImage: profile.avatar.isNotEmpty
                  ? NetworkImage(profile.avatar) as ImageProvider
                  : null,
              child: profile.avatar.isEmpty
                  ? const Icon(Icons.person, size: 50, color: AppColors.primaryNavy)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            profile.name,
            style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 4),
          // Subtitle / Location / Email
          Text(
            profile.email,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            profile.location,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 20),
          // Statistics & Edit Profile Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('${profile.followers} Follower'),
              Container(width: 1, height: 24, color: Colors.white24),
              _buildStatColumn('${profile.following} Following'),
              Container(width: 1, height: 24, color: Colors.white24),
              // Edit Profile Button
              GestureDetector(
                onTap: () => _showEditHeaderSheet(context, profile),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Edit profile',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.edit_square, color: AppColors.orangeAccent, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
    );
  }

  // ── 2. About Me Section Card ──────────────────────────────────────────────
  Widget _buildAboutMeSection(BuildContext context, String text) {
    return _buildSectionWrapper(
      title: 'About me',
      onEditPressed: () => _showAboutMeDialog(context, text),
      child: Text(
        text.isNotEmpty ? text : 'Tell us something about yourself...',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }

  // ── 3. Work Experience Section Card ───────────────────────────────────────
  Widget _buildWorkExperienceSection(BuildContext context, List<WorkExperienceModel> list) {
    return _buildSectionWrapper(
      title: 'Work experience',
      onAddPressed: () => _showWorkExperienceSheet(context, null),
      child: list.isEmpty
          ? const Text('Chưa có thông tin kinh nghiệm làm việc.', style: TextStyle(color: Colors.grey, fontSize: 13))
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 24),
              itemBuilder: (context, index) {
                final exp = list[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accentLightPurple.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.business_center_rounded, color: AppColors.primaryNavy, size: 22),
                    ),
                    const SizedBox(width: 14),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.role, style: AppTextStyles.label.copyWith(fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(exp.company, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            '${exp.startDate} - ${exp.endDate} • ${exp.duration}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons (Edit & Delete)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.orangeAccent, size: 20),
                          onPressed: () => _showWorkExperienceSheet(context, exp),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                          onPressed: () => _confirmDelete(
                            context,
                            'Xóa kinh nghiệm',
                            'Bạn có chắc chắn muốn xóa kinh nghiệm tại ${exp.company}?',
                            () => _profileBloc.add(DeleteWorkExperienceEvent(exp.id!)),
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  // ── 4. Education Section Card ─────────────────────────────────────────────
  Widget _buildEducationSection(BuildContext context, List<EducationModel> list) {
    return _buildSectionWrapper(
      title: 'Education',
      onAddPressed: () => _showEducationSheet(context, null),
      child: list.isEmpty
          ? const Text('Chưa có thông tin học vấn.', style: TextStyle(color: Colors.grey, fontSize: 13))
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 24),
              itemBuilder: (context, index) {
                final edu = list[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accentLightPurple.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded, color: AppColors.primaryNavy, size: 22),
                    ),
                    const SizedBox(width: 14),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(edu.field, style: AppTextStyles.label.copyWith(fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(edu.school, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            '${edu.startDate} - ${edu.endDate} • ${edu.duration}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons (Edit & Delete)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.orangeAccent, size: 20),
                          onPressed: () => _showEducationSheet(context, edu),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                          onPressed: () => _confirmDelete(
                            context,
                            'Xóa học vấn',
                            'Bạn có chắc muốn xóa quá trình học tại ${edu.school}?',
                            () => _profileBloc.add(DeleteEducationEvent(edu.id!)),
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  // ── 5. Skills Section Card ────────────────────────────────────────────────
  Widget _buildSkillsSection(BuildContext context, List<SkillModel> list) {
    return _buildSectionWrapper(
      title: 'Skill',
      onEditPressed: () => _showSkillsEditSheet(context, list),
      child: list.isEmpty
          ? const Text('Chưa có kỹ năng.', style: TextStyle(color: Colors.grey, fontSize: 13))
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: list.map((skill) {
                return Chip(
                  backgroundColor: AppColors.accentLightPurple.withOpacity(0.4),
                  label: Text(skill.name, style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, color: AppColors.textPrimary)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
    );
  }

  // ── 6. Languages Section Card ─────────────────────────────────────────────
  Widget _buildLanguagesSection(BuildContext context, List<LanguageModel> list) {
    return _buildSectionWrapper(
      title: 'Language',
      onEditPressed: () => _showLanguagesEditSheet(context, list),
      child: list.isEmpty
          ? const Text('Chưa có ngôn ngữ.', style: TextStyle(color: Colors.grey, fontSize: 13))
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: list.map((lang) {
                return Chip(
                  backgroundColor: Colors.white,
                  label: Text(lang.name, style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, color: AppColors.textPrimary)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                );
              }).toList(),
            ),
    );
  }

  // ── 7. Appreciation Section Card ──────────────────────────────────────────
  Widget _buildApprecationsSection(BuildContext context, List<AppreciationModel> list) {
    return _buildSectionWrapper(
      title: 'Appreciation',
      onAddPressed: () => _showAppreciationSheet(context, null),
      child: list.isEmpty
          ? const Text('Chưa có giải thưởng.', style: TextStyle(color: Colors.grey, fontSize: 13))
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 24),
              itemBuilder: (context, index) {
                final app = list[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accentLightPurple.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.emoji_events_rounded, color: AppColors.orangeAccent, size: 22),
                    ),
                    const SizedBox(width: 14),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(app.title, style: AppTextStyles.label.copyWith(fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${app.award} • ${app.year}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    // Actions
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.orangeAccent, size: 20),
                          onPressed: () => _showAppreciationSheet(context, app),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                          onPressed: () => _confirmDelete(
                            context,
                            'Xóa giải thưởng',
                            'Bạn có chắc chắn muốn xóa giải thưởng ${app.title}?',
                            () => _profileBloc.add(DeleteAppreciationEvent(app.id!)),
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  // ── Auxiliary Section Layout Wrapper ──────────────────────────────────────
  Widget _buildSectionWrapper({
    required String title,
    VoidCallback? onEditPressed,
    VoidCallback? onAddPressed,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.heading3.copyWith(fontSize: 16, color: AppColors.textPrimary),
              ),
              if (onEditPressed != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.orangeAccent, size: 20),
                  onPressed: onEditPressed,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              if (onAddPressed != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.orangeAccent, size: 22),
                  onPressed: onAddPressed,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ── Confirmation Modal ───────────────────────────────────────────────────
  void _confirmDelete(BuildContext context, String title, String body, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 18)),
        content: Text(body, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM SHEET SHEETS / DIALOGS (CRUD INTERACTION) ──────────────────────

  // Sheet: Edit Header Information
  void _showEditHeaderSheet(BuildContext context, ProfileModel profile) {
    final nameCtrl = TextEditingController(text: profile.name);
    final emailCtrl = TextEditingController(text: profile.email);
    final locCtrl = TextEditingController(text: profile.location);
    final avatarCtrl = TextEditingController(text: profile.avatar);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Header Profile', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              _buildSheetTextField('Full Name', nameCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('Email/Sub', emailCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('Location', locCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('Avatar Image URL', avatarCtrl),
              const SizedBox(height: 24),
              _buildSaveCloseButtons(context, () {
                _profileBloc.add(UpdateProfileHeaderEvent(
                  name: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  location: locCtrl.text.trim(),
                  avatar: avatarCtrl.text.trim(),
                ));
                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog: Edit About Me
  void _showAboutMeDialog(BuildContext context, String currentText) {
    final textCtrl = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('About me', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
        content: TextField(
          controller: textCtrl,
          maxLines: 5,
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Tell me about you...',
            hintStyle: AppTextStyles.hint,
            filled: true,
            fillColor: Color(0xFFF3F2F8),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryNavy,
                    side: const BorderSide(color: AppColors.primaryNavy),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('CLOSE'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _profileBloc.add(UpdateAboutMeEvent(aboutMe: textCtrl.text.trim()));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SAVE'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Sheet: Add/Edit Work Experience
  void _showWorkExperienceSheet(BuildContext context, WorkExperienceModel? model) {
    final roleCtrl = TextEditingController(text: model?.role);
    final compCtrl = TextEditingController(text: model?.company);
    final startCtrl = TextEditingController(text: model?.startDate);
    final endCtrl = TextEditingController(text: model?.endDate);
    final durCtrl = TextEditingController(text: model?.duration);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model == null ? 'Add Work Experience' : 'Edit Work Experience',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              _buildSheetTextField('Role / Position', roleCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('Company', compCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildSheetTextField('Start Date (e.g. Jan 2015)', startCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSheetTextField('End Date (e.g. Feb 2022)', endCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _buildSheetTextField('Duration (e.g. 7 years)', durCtrl),
              const SizedBox(height: 24),
              _buildSaveCloseButtons(context, () {
                final role = roleCtrl.text.trim();
                final comp = compCtrl.text.trim();
                final start = startCtrl.text.trim();
                final end = endCtrl.text.trim();
                final dur = durCtrl.text.trim();

                if (role.isEmpty || comp.isEmpty) return;

                final exp = WorkExperienceModel(
                  id: model?.id,
                  role: role,
                  company: comp,
                  startDate: start,
                  endDate: end,
                  duration: dur,
                );

                if (model == null) {
                  _profileBloc.add(AddWorkExperienceEvent(exp));
                } else {
                  _profileBloc.add(UpdateWorkExperienceEvent(exp));
                }
                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Sheet: Add/Edit Education
  void _showEducationSheet(BuildContext context, EducationModel? model) {
    final fieldCtrl = TextEditingController(text: model?.field);
    final schoolCtrl = TextEditingController(text: model?.school);
    final startCtrl = TextEditingController(text: model?.startDate);
    final endCtrl = TextEditingController(text: model?.endDate);
    final durCtrl = TextEditingController(text: model?.duration);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model == null ? 'Add Education' : 'Edit Education',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              _buildSheetTextField('Field of Study', fieldCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('School / University', schoolCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildSheetTextField('Start Date', startCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSheetTextField('End Date', endCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _buildSheetTextField('Duration', durCtrl),
              const SizedBox(height: 24),
              _buildSaveCloseButtons(context, () {
                final field = fieldCtrl.text.trim();
                final school = schoolCtrl.text.trim();
                final start = startCtrl.text.trim();
                final end = endCtrl.text.trim();
                final dur = durCtrl.text.trim();

                if (field.isEmpty || school.isEmpty) return;

                final edu = EducationModel(
                  id: model?.id,
                  field: field,
                  school: school,
                  startDate: start,
                  endDate: end,
                  duration: dur,
                );

                if (model == null) {
                  _profileBloc.add(AddEducationEvent(edu));
                } else {
                  _profileBloc.add(UpdateEducationEvent(edu));
                }
                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog-Sheet: Add/Delete Skills
  void _showSkillsEditSheet(BuildContext context, List<SkillModel> currentSkills) {
    final skillCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit Skills', style: AppTextStyles.heading3),
                    const SizedBox(height: 16),
                    // Display Active Skills with Delete Action
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currentSkills.map((skill) {
                        return Chip(
                          backgroundColor: AppColors.accentLightPurple.withOpacity(0.5),
                          label: Text(skill.name, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide.none,
                          onDeleted: () {
                            _profileBloc.add(DeleteSkillEvent(skill.id));
                            setSheetState(() {
                              currentSkills.removeWhere((item) => item.id == skill.id);
                            });
                          },
                          deleteIconColor: AppColors.error,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // New Skill Input Field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: skillCtrl,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Enter new skill...',
                              filled: true,
                              fillColor: Color(0xFFF3F2F8),
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final name = skillCtrl.text.trim();
                            if (name.isNotEmpty) {
                              _profileBloc.add(AddSkillEvent(name));
                              skillCtrl.clear();
                              Navigator.pop(context); // Close sheet to let it rebuild with new state
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CLOSE', style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog-Sheet: Add/Delete Languages
  void _showLanguagesEditSheet(BuildContext context, List<LanguageModel> currentLangs) {
    final langCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit Languages', style: AppTextStyles.heading3),
                    const SizedBox(height: 16),
                    // Display Active Languages with Delete Action
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currentLangs.map((lang) {
                        return Chip(
                          backgroundColor: Colors.white,
                          label: Text(lang.name, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: AppColors.borderLight),
                          ),
                          onDeleted: () {
                            _profileBloc.add(DeleteLanguageEvent(lang.id));
                            setSheetState(() {
                              currentLangs.removeWhere((item) => item.id == lang.id);
                            });
                          },
                          deleteIconColor: AppColors.error,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // New Language Input Field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: langCtrl,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Enter new language...',
                              filled: true,
                              fillColor: Color(0xFFF3F2F8),
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final name = langCtrl.text.trim();
                            if (name.isNotEmpty) {
                              _profileBloc.add(AddLanguageEvent(name));
                              langCtrl.clear();
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CLOSE', style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Sheet: Add/Edit Appreciation
  void _showAppreciationSheet(BuildContext context, AppreciationModel? model) {
    final titleCtrl = TextEditingController(text: model?.title);
    final awardCtrl = TextEditingController(text: model?.award);
    final yearCtrl = TextEditingController(text: model?.year);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model == null ? 'Add Appreciation' : 'Edit Appreciation',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              _buildSheetTextField('Award Name', titleCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('Category / Award Title', awardCtrl),
              const SizedBox(height: 12),
              _buildSheetTextField('Year (e.g. 2014)', yearCtrl),
              const SizedBox(height: 24),
              _buildSaveCloseButtons(context, () {
                final title = titleCtrl.text.trim();
                final award = awardCtrl.text.trim();
                final year = yearCtrl.text.trim();

                if (title.isEmpty) return;

                final app = AppreciationModel(
                  id: model?.id,
                  title: title,
                  award: award,
                  year: year,
                );

                if (model == null) {
                  _profileBloc.add(AddAppreciationEvent(app));
                } else {
                  _profileBloc.add(UpdateAppreciationEvent(app));
                }
                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Form Utility Widgets
  Widget _buildSheetTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontSize: 13, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFF3F2F8),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveCloseButtons(BuildContext context, VoidCallback onSave) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryNavy,
              side: const BorderSide(color: AppColors.primaryNavy),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('CLOSE'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('SAVE'),
          ),
        ),
      ],
    );
  }
}
