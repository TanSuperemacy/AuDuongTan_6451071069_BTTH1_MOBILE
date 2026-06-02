class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  // In-Memory tables for Chrome Web fallback
  Map<String, dynamic>? _webProfile;
  List<Map<String, dynamic>>? _webWorkExperiences;
  List<Map<String, dynamic>>? _webEducations;
  List<Map<String, dynamic>>? _webSkills;
  List<Map<String, dynamic>>? _webLanguages;
  List<Map<String, dynamic>>? _webAppreciations;
  int _webIdCounter = 100;

  DatabaseHelper._init() {
    _initWebDatabase();
  }

  void _initWebDatabase() {
    // Seed mock data matching your UI design specs
    _webProfile = {
      'id': 1,
      'name': 'Nguyễn Văn A',
      'email': 'fithou@agent.etc.vn',
      'location': 'California, USA',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
      'followers': '120k',
      'following': '23k',
      'about_me': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lectus id commodo egestas metus interdum dolor. Ut cursus pulvinar elementum placerat.',
    };

    _webWorkExperiences = [
      {
        'id': 1,
        'role': 'Manager',
        'company': 'Amazon Inc',
        'start_date': 'Jan 2015',
        'end_date': 'Feb 2022',
        'duration': '7 years',
      }
    ];

    _webEducations = [
      {
        'id': 1,
        'field': 'Information Technology',
        'school': 'University of Oxford',
        'start_date': 'Sep 2013',
        'end_date': 'Aug 2015',
        'duration': '2 years',
      }
    ];

    _webSkills = [
      {'id': 1, 'name': 'Leadership'},
      {'id': 2, 'name': 'Teamwork'},
      {'id': 3, 'name': 'Visioner'},
      {'id': 4, 'name': 'Target oriented'},
      {'id': 5, 'name': 'Consistent'},
    ];

    _webLanguages = [
      {'id': 1, 'name': 'English'},
      {'id': 2, 'name': 'German'},
      {'id': 3, 'name': 'Spanish'},
      {'id': 4, 'name': 'Mandarin'},
      {'id': 5, 'name': 'Italy'},
    ];

    _webAppreciations = [
      {
        'id': 1,
        'title': 'Wireless Symposium (RWS)',
        'award': 'Young Scientist',
        'year': '2014',
      }
    ];
  }

  // --- CRUD Operations for Profile ---

  Future<Map<String, dynamic>?> getProfile() async {
    return _webProfile;
  }

  Future<int> updateProfile(Map<String, dynamic> row) async {
    final updated = Map<String, dynamic>.from(_webProfile!);
    row.forEach((key, value) {
      updated[key] = value;
    });
    _webProfile = updated;
    return 1;
  }

  // --- CRUD Operations for Work Experience ---

  Future<List<Map<String, dynamic>>> getWorkExperiences() async {
    return List<Map<String, dynamic>>.from(_webWorkExperiences!.reversed);
  }

  Future<int> addWorkExperience(Map<String, dynamic> row) async {
    _webIdCounter++;
    final newRow = Map<String, dynamic>.from(row);
    newRow['id'] = _webIdCounter;
    _webWorkExperiences!.add(newRow);
    return _webIdCounter;
  }

  Future<int> updateWorkExperience(int id, Map<String, dynamic> row) async {
    final index = _webWorkExperiences!.indexWhere((m) => m['id'] == id);
    if (index != -1) {
      final updatedRow = Map<String, dynamic>.from(row);
      updatedRow['id'] = id;
      _webWorkExperiences![index] = updatedRow;
      return 1;
    }
    return 0;
  }

  Future<int> deleteWorkExperience(int id) async {
    final before = _webWorkExperiences!.length;
    _webWorkExperiences!.removeWhere((m) => m['id'] == id);
    return before - _webWorkExperiences!.length;
  }

  // --- CRUD Operations for Education ---

  Future<List<Map<String, dynamic>>> getEducations() async {
    return List<Map<String, dynamic>>.from(_webEducations!.reversed);
  }

  Future<int> addEducation(Map<String, dynamic> row) async {
    _webIdCounter++;
    final newRow = Map<String, dynamic>.from(row);
    newRow['id'] = _webIdCounter;
    _webEducations!.add(newRow);
    return _webIdCounter;
  }

  Future<int> updateEducation(int id, Map<String, dynamic> row) async {
    final index = _webEducations!.indexWhere((m) => m['id'] == id);
    if (index != -1) {
      final updatedRow = Map<String, dynamic>.from(row);
      updatedRow['id'] = id;
      _webEducations![index] = updatedRow;
      return 1;
    }
    return 0;
  }

  Future<int> deleteEducation(int id) async {
    final before = _webEducations!.length;
    _webEducations!.removeWhere((m) => m['id'] == id);
    return before - _webEducations!.length;
  }

  // --- CRUD Operations for Skills ---

  Future<List<Map<String, dynamic>>> getSkills() async {
    return List<Map<String, dynamic>>.from(_webSkills!);
  }

  Future<int> addSkill(String name) async {
    final exists = _webSkills!.any((s) => s['name'] == name);
    if (!exists) {
      _webIdCounter++;
      _webSkills!.add({'id': _webIdCounter, 'name': name});
      return _webIdCounter;
    }
    return 0;
  }

  Future<int> deleteSkill(int id) async {
    final before = _webSkills!.length;
    _webSkills!.removeWhere((s) => s['id'] == id);
    return before - _webSkills!.length;
  }

  // --- CRUD Operations for Languages ---

  Future<List<Map<String, dynamic>>> getLanguages() async {
    return List<Map<String, dynamic>>.from(_webLanguages!);
  }

  Future<int> addLanguage(String name) async {
    final exists = _webLanguages!.any((l) => l['name'] == name);
    if (!exists) {
      _webIdCounter++;
      _webLanguages!.add({'id': _webIdCounter, 'name': name});
      return _webIdCounter;
    }
    return 0;
  }

  Future<int> deleteLanguage(int id) async {
    final before = _webLanguages!.length;
    _webLanguages!.removeWhere((l) => l['id'] == id);
    return before - _webLanguages!.length;
  }

  // --- CRUD Operations for Appreciation ---

  Future<List<Map<String, dynamic>>> getAppreciations() async {
    return List<Map<String, dynamic>>.from(_webAppreciations!.reversed);
  }

  Future<int> addAppreciation(Map<String, dynamic> row) async {
    _webIdCounter++;
    final newRow = Map<String, dynamic>.from(row);
    newRow['id'] = _webIdCounter;
    _webAppreciations!.add(newRow);
    return _webIdCounter;
  }

  Future<int> updateAppreciation(int id, Map<String, dynamic> row) async {
    final index = _webAppreciations!.indexWhere((m) => m['id'] == id);
    if (index != -1) {
      final updatedRow = Map<String, dynamic>.from(row);
      updatedRow['id'] = id;
      _webAppreciations![index] = updatedRow;
      return 1;
    }
    return 0;
  }

  Future<int> deleteAppreciation(int id) async {
    final before = _webAppreciations!.length;
    _webAppreciations!.removeWhere((m) => m['id'] == id);
    return before - _webAppreciations!.length;
  }
}
