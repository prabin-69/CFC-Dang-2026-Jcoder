import 'package:flutter/material.dart';
import '../models/professional_model.dart';
import '../core/utils.dart';

/// Action types the AI assistant can present to the user.
enum AiActionType { viewProfessionals, createRequest, viewBookings, none }

/// A structured action (button) attached to an AI message.
class AiAction {
  final AiActionType type;
  final String label;
  final String? payload;

  const AiAction({required this.type, required this.label, this.payload});
}

/// A single chat message in the AI assistant conversation.
class AiChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<AiAction> actions;
  final List<ProfessionalModel>? recommendedProfessionals;
  final String? suggestedCategory;
  final String? suggestedTitle;
  final String? suggestedDescription;
  final bool isTyping;

  const AiChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actions = const [],
    this.recommendedProfessionals,
    this.suggestedCategory,
    this.suggestedTitle,
    this.suggestedDescription,
    this.isTyping = false,
  });

  AiChatMessage copyWith({bool? isTyping}) {
    return AiChatMessage(
      text: text,
      isUser: isUser,
      timestamp: timestamp,
      actions: actions,
      recommendedProfessionals: recommendedProfessionals,
      suggestedCategory: suggestedCategory,
      suggestedTitle: suggestedTitle,
      suggestedDescription: suggestedDescription,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

/// Knowledge base entry for a service category.
class _CategoryInfo {
  final String name;
  final List<String> keywords;
  final double minPrice;
  final double maxPrice;
  final List<String> causes;
  final List<String> followUps;
  final List<String> tips;
  final String description;

  const _CategoryInfo({
    required this.name,
    required this.keywords,
    required this.minPrice,
    required this.maxPrice,
    required this.causes,
    required this.followUps,
    required this.tips,
    required this.description,
  });
}

/// The WorkLink AI Assistant engine.
///
/// This is a rule-based conversational engine designed for the MVP. It
/// understands problems, detects service categories, asks intelligent
/// follow-up questions, estimates costs, ranks professional recommendations,
/// and always ends with an actionable next step.
class AIAssistantService extends ChangeNotifier {
  final List<AiChatMessage> _messages = [];
  final Map<String, _CategoryInfo> _categories = {};
  final Set<String> _askedQuestions = {};

  String? _detectedCategory;
  bool _isTyping = false;
  int _followUpCount = 0;

  List<AiChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  bool get awaitingInput => _messages.isNotEmpty && !_messages.last.isUser;

  static const List<String> quickSuggestions = [
    'My kitchen sink is leaking',
    'My AC is not cooling',
    'Estimate cost for painting',
    'Show me plumbers',
    'Maintenance tips',
  ];

  AIAssistantService() {
    _buildKnowledgeBase();
    _messages.add(
      AiChatMessage(
        text:
            'Namaste! 👋 I\'m the WorkLink Assistant, your smart service guide.\n\n'
            'Describe any problem you\'re facing and I\'ll help you:\n'
            '• Detect the right service category\n'
            '• Estimate a fair price range\n'
            '• Recommend verified professionals nearby\n'
            '• Create a service request in one tap\n\n'
            'Try saying: "My kitchen sink is leaking"',
        isUser: false,
        timestamp: DateTime.now(),
        actions: _suggestedActions,
      ),
    );
  }

  List<AiAction> get _suggestedActions => const [
    AiAction(type: AiActionType.createRequest, label: 'Create Service Request'),
    AiAction(
      type: AiActionType.viewProfessionals,
      label: 'Browse Professionals',
    ),
    AiAction(type: AiActionType.viewBookings, label: 'My Bookings'),
  ];

  void _buildKnowledgeBase() {
    _categories.addAll({
      'Plumbing': const _CategoryInfo(
        name: 'Plumbing',
        keywords: [
          'leak',
          'leaking',
          'pipe',
          'tap',
          'sink',
          'toilet',
          'drain',
          'water heater',
          'bathroom',
          'faucet',
          'shower',
          'sewage',
          'blockage',
          'plumb',
        ],
        minPrice: 1000,
        maxPrice: 3000,
        causes: [
          'Worn-out pipe joints or seals',
          'Blockage in the drain line',
          'Faulty water heater element',
          'Loose tap fittings',
        ],
        followUps: [
          'Is the leak continuous, or only when water is running?',
          'Can you share a photo of the affected area?',
        ],
        tips: [
          'Check visible pipes for damp spots monthly',
          'Never pour oil or grease down the drain',
          'Insulate pipes before winter to prevent freezing',
        ],
        description:
            'Plumbing covers pipe repair, drain cleaning, water heaters, bathroom fittings, and tap repair.',
      ),
      'Electrical': const _CategoryInfo(
        name: 'Electrical',
        keywords: [
          'wiring',
          'wire',
          'switch',
          'electric',
          'electricity',
          'short circuit',
          'power',
          'light',
          'fan',
          'voltage',
          'socket',
          'breaker',
          'fuse',
          'shock',
          'spark',
          'dim',
          'electrical',
        ],
        minPrice: 1500,
        maxPrice: 5000,
        causes: [
          'Loose wiring connections',
          'Overloaded circuit',
          'Faulty switch or socket',
          'Old or damaged wiring',
        ],
        followUps: [
          'Is the power completely out, or just in one area?',
          'Did this start after a recent appliance installation?',
        ],
        tips: [
          'Never overload a single socket with multiple high-power devices',
          'Replace damaged wires immediately',
          'Schedule an annual electrical inspection',
        ],
        description:
            'Electrical services include house wiring, switchboards, fan installation, and appliance wiring.',
      ),
      'Carpentry': const _CategoryInfo(
        name: 'Carpentry',
        keywords: [
          'furniture',
          'wood',
          'wooden',
          'cabinet',
          'shelf',
          'wardrobe',
          'door',
          'window frame',
          'carpenter',
          'table',
          'chair',
          'bed',
          'kitchen cabinet',
          'carpentry',
        ],
        minPrice: 2000,
        maxPrice: 6000,
        causes: [
          'Loose joints or screws',
          'Wood swelling due to moisture',
          'Worn-out hinges or handles',
          'Termite damage in wood',
        ],
        followUps: [
          'Is the item damaged structurally or cosmetically?',
          'What type of wood or material is it?',
        ],
        tips: [
          'Keep wooden furniture away from direct moisture',
          'Apply polish periodically to protect the finish',
          'Tighten loose screws before they cause more damage',
        ],
        description:
            'Carpentry covers custom furniture, cabinets, wood repair, and restoration.',
      ),
      'Cleaning': const _CategoryInfo(
        name: 'Cleaning',
        keywords: [
          'clean',
          'cleaning',
          'house cleaning',
          'office cleaning',
          'deep clean',
          'carpet',
          'window cleaning',
          'bathroom cleaning',
          'kitchen cleaning',
          'sanitize',
          'dust',
          'maid',
        ],
        minPrice: 1000,
        maxPrice: 4000,
        causes: [
          'Accumulated dust and allergens',
          'Stubborn stains and grime',
          'Mold or mildew buildup',
        ],
        followUps: [
          'Which area needs cleaning — home, office, or a specific room?',
          'Do you need deep cleaning or regular cleaning?',
        ],
        tips: [
          'Vacuum and mop high-traffic areas weekly',
          'Use eco-friendly cleaners to protect surfaces',
          'Schedule a deep cleaning every 3-4 months',
        ],
        description:
            'Cleaning services include home, office, deep cleaning, and carpet cleaning.',
      ),
      'Painting': const _CategoryInfo(
        name: 'Painting',
        keywords: [
          'paint',
          'painting',
          'wall',
          'walls',
          'color',
          'texture',
          'waterproofing',
          'interior',
          'exterior',
          'ceiling',
          'repaint',
          'wallpaper',
          'painter',
        ],
        minPrice: 5000,
        maxPrice: 15000,
        causes: [
          'Old or faded paint',
          'Cracks and dampness on walls',
          'Uneven wall surface',
          'Water seepage stains',
        ],
        followUps: [
          'Is this for interior or exterior painting?',
          'What is the approximate room size?',
        ],
        tips: [
          'Repair wall cracks before painting for a smooth finish',
          'Use waterproof paint for exterior walls',
          'Always prime walls before the final coat',
        ],
        description:
            'Painting services include interior, exterior, texture finish, and waterproofing.',
      ),
      'Appliance Repair': const _CategoryInfo(
        name: 'Appliance Repair',
        keywords: [
          'ac',
          'air conditioner',
          'cooling',
          'refrigerator',
          'fridge',
          'washing machine',
          'microwave',
          'oven',
          'water purifier',
          'geyser',
          'appliance',
          'freezer',
          'cooler',
          'not cooling',
          'not working',
        ],
        minPrice: 1500,
        maxPrice: 5000,
        causes: [
          'Dirty air filters',
          'Low refrigerant gas',
          'Compressor or motor failure',
          'Faulty thermostat or timer',
        ],
        followUps: [
          'Which appliance is having the issue?',
          'Is the appliance still under warranty?',
        ],
        tips: [
          'Clean AC filters every month for better cooling',
          'Defrost your refrigerator periodically',
          'Don\'t overload the washing machine',
        ],
        description:
            'Appliance repair covers AC, refrigerator, washing machine, microwave, and more.',
      ),
      'Gardening': const _CategoryInfo(
        name: 'Gardening',
        keywords: [
          'garden',
          'gardening',
          'lawn',
          'plant',
          'tree',
          'grass',
          'hedge',
          'landscape',
          'irrigation',
          'watering',
        ],
        minPrice: 1500,
        maxPrice: 5000,
        causes: [
          'Improper watering schedule',
          'Pest infestation',
          'Poor soil quality',
        ],
        followUps: [
          'Is this for a home garden or a larger area?',
          'Are the plants turning yellow or wilting?',
        ],
        tips: [
          'Water plants early morning or late evening',
          'Add compost to enrich soil',
          'Prune regularly for healthy growth',
        ],
        description:
            'Gardening services cover lawn care, landscaping, and plant maintenance.',
      ),
      'Pest Control': const _CategoryInfo(
        name: 'Pest Control',
        keywords: [
          'pest',
          'pests',
          'insect',
          'termite',
          'cockroach',
          'rat',
          'mice',
          'mosquito',
          'ant',
          'bed bug',
          'fumigation',
          'bug',
        ],
        minPrice: 2000,
        maxPrice: 8000,
        causes: [
          'Food residue and unsealed gaps',
          'Moisture buildup',
          'Cracks in walls and floors',
        ],
        followUps: [
          'Which pest are you dealing with?',
          'How severe is the infestation?',
        ],
        tips: [
          'Seal food containers and dispose of waste daily',
          'Fix leaking taps that attract pests',
          'Seal entry points around doors and windows',
        ],
        description:
            'Pest control covers termites, cockroaches, rats, and general fumigation.',
      ),
      'Security System': const _CategoryInfo(
        name: 'Security System',
        keywords: [
          'security',
          'camera',
          'cctv',
          'alarm',
          'lock',
          'safe',
          'surveillance',
          'doorbell',
          'intercom',
          'access control',
        ],
        minPrice: 5000,
        maxPrice: 15000,
        causes: [
          'Outdated security equipment',
          'Poor camera placement',
          'Network or wiring issues',
        ],
        followUps: [
          'Is this for a home or a business?',
          'Do you need remote viewing on your phone?',
        ],
        tips: [
          'Place cameras at entry points and blind spots',
          'Keep firmware updated on security cameras',
          'Use strong passwords for surveillance systems',
        ],
        description:
            'Security services include CCTV installation, alarms, and access control.',
      ),
      'Moving & Shifting': const _CategoryInfo(
        name: 'Moving & Shifting',
        keywords: [
          'move',
          'moving',
          'shift',
          'shifting',
          'pack',
          'packing',
          'transport',
          'relocation',
          'delivery',
          'shifting home',
        ],
        minPrice: 3000,
        maxPrice: 10000,
        causes: [
          'Fragile items needing careful packing',
          'Large furniture requiring dismantling',
        ],
        followUps: [
          'Are you moving a home or an office?',
          'Do you need packing services as well?',
        ],
        tips: [
          'Book movers at least a week in advance',
          'Label all boxes clearly',
          'Pack fragile items with proper cushioning',
        ],
        description:
            'Moving services cover home/office relocation, packing, and transport.',
      ),
    });
  }

  /// Sends a text message and generates an intelligent AI reply.
  Future<void> sendMessage(
    String input, {
    List<ProfessionalModel>? professionals,
  }) async {
    final text = input.trim();
    if (text.isEmpty) return;

    _messages.add(
      AiChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    );
    _isTyping = true;
    notifyListeners();

    // Simulate thinking latency (replaced with a real AI call in production).
    await Future.delayed(Duration(milliseconds: 900 + (text.length % 3) * 250));

    final reply = _generateReply(text, professionals ?? []);
    _isTyping = false;
    _messages.add(reply);
    notifyListeners();
  }

  /// Handles a photo attachment from the user.
  Future<void> sendImageMessage(
    String imagePath, {
    List<ProfessionalModel>? professionals,
  }) async {
    _messages.add(
      AiChatMessage(
        text: '📷 [Photo attached]',
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    _isTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1400));

    final category = _detectedCategory;
    final reply = AiChatMessage(
      text: category == null
          ? 'Thanks for sharing the photo! 📸\n\n'
                'I\'m analyzing it now. Could you also briefly describe the problem in words? '
                'That will help me recommend the right professional.'
          : 'Thanks for the photo! 📸\n\n'
                'Based on what I\'ve gathered, this relates to a $category concern. '
                'Tap below to see recommended experts or create a service request:',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedCategory: category,
      actions: category == null ? const [] : _actionsFor(category),
    );

    _isTyping = false;
    _messages.add(reply);
    notifyListeners();
  }

  AiChatMessage _generateReply(
    String text,
    List<ProfessionalModel> professionals,
  ) {
    final lower = text.toLowerCase();

    if (_isGreeting(lower)) return _greetingReply();
    if (_isThanks(lower)) return _thanksReply();
    if (_isTipRequest(lower)) return _tipsReply();
    if (_isCostQuestion(lower)) return _costReply(lower);
    if (_isCreateRequest(lower)) return _createRequestReply(lower);
    if (_isProRequest(lower)) return _prosReply(lower, professionals);

    // Treat as a problem description.
    final category = _detectedCategory ?? _detectCategory(lower);
    if (category == null) {
      _detectedCategory = null;
      _followUpCount = 0;
      return _askClarification();
    }

    _detectedCategory = category;
    final info = _categories[category]!;

    if (_followUpCount < 2) {
      final question = _nextQuestion(info);
      if (question != null) {
        _followUpCount++;
        _askedQuestions.add(question);
        return AiChatMessage(
          text:
              'I\'ve identified this as a ${info.name} issue. 🛠️\n\n'
              'Common causes include:\n'
              '${info.causes.map((c) => '• $c').join('\n')}\n\n'
              '$question\n\n'
              'While you answer, here\'s how I can help:',
          isUser: false,
          timestamp: DateTime.now(),
          suggestedCategory: info.name,
          actions: _actionsFor(info.name),
        );
      }
    }

    return _fullRecommendation(info, professionals);
  }

  AiChatMessage _fullRecommendation(
    _CategoryInfo info,
    List<ProfessionalModel> professionals,
  ) {
    final recommended = _recommendProfessionals(professionals, info.name);
    final priceText =
        '${AppUtils.formatCurrency(info.minPrice)} – ${AppUtils.formatCurrency(info.maxPrice)}';

    final buffer = StringBuffer()
      ..writeln('Here\'s my analysis for your ${info.name} concern:\n')
      ..writeln('Common causes:')
      ..writeln(info.causes.map((c) => '• $c').join('\n'))
      ..writeln()
      ..writeln('Estimated cost range: $priceText')
      ..writeln(
        '(This is an approximate estimate. The final price depends on complexity, materials, and the professional you choose.)',
      );

    if (recommended.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(
        'I\'ve ranked ${recommended.length} recommended ${info.name.toLowerCase()} professional(s) nearby by trust score:',
      );
    }

    return AiChatMessage(
      text: buffer.toString(),
      isUser: false,
      timestamp: DateTime.now(),
      recommendedProfessionals: recommended.isEmpty ? null : recommended,
      suggestedCategory: info.name,
      actions: _actionsFor(info.name),
    );
  }

  AiChatMessage _askClarification() {
    return AiChatMessage(
      text:
          'I want to make sure I recommend the right professional. 🤔\n\n'
          'Could you tell me a bit more about the problem? For example:\n'
          '• "My water heater is leaking"\n'
          '• "The AC is not cooling"\n'
          '• "I need my walls painted"\n\n'
          'Or tap one of the quick options below:',
      isUser: false,
      timestamp: DateTime.now(),
      actions: _suggestedActions,
    );
  }

  AiChatMessage _greetingReply() {
    return AiChatMessage(
      text:
          'Hello! 😊 I\'m the WorkLink Assistant, here to help you solve home and professional service problems.\n\n'
          'Tell me what\'s going on — for example:\n'
          '• "My AC is not cooling"\n'
          '• "Kitchen sink leaking"\n'
          '• "I need help painting my room"',
      isUser: false,
      timestamp: DateTime.now(),
      actions: _suggestedActions,
    );
  }

  AiChatMessage _thanksReply() {
    return AiChatMessage(
      text:
          'You\'re most welcome! 🙏\n\n'
          'If you need anything else — finding a professional, estimating costs, '
          'or creating a service request — just let me know!',
      isUser: false,
      timestamp: DateTime.now(),
      actions: _suggestedActions,
    );
  }

  AiChatMessage _costReply(String text) {
    final category = _detectedCategory ?? _detectCategory(text);
    if (category == null) {
      return AiChatMessage(
        text:
            'I can give you a cost estimate for different services. 💰\n\n'
            'Which service are you interested in? For example:\n'
            '• Plumbing repair\n'
            '• Electrical work\n'
            '• House painting\n'
            '• AC repair',
        isUser: false,
        timestamp: DateTime.now(),
        actions: _suggestedActions,
      );
    }

    final info = _categories[category]!;
    return AiChatMessage(
      text:
          'For $category services, typical costs range between '
          '${AppUtils.formatCurrency(info.minPrice)} and '
          '${AppUtils.formatCurrency(info.maxPrice)}.\n\n'
          'This is an approximate estimate — the final price depends on the complexity, '
          'materials, and the professional you choose. 📊',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedCategory: category,
      actions: _actionsFor(category),
    );
  }

  AiChatMessage _prosReply(String text, List<ProfessionalModel> professionals) {
    final category = _detectedCategory ?? _detectCategory(text);
    if (category == null) {
      return AiChatMessage(
        text:
            'Sure! I can recommend professionals based on rating, verification, '
            'experience, and availability. 👍\n\n'
            'Which service do you need?',
        isUser: false,
        timestamp: DateTime.now(),
        actions: _suggestedActions,
      );
    }

    final recommended = _recommendProfessionals(professionals, category);
    final info = _categories[category]!;
    final buffer = StringBuffer()
      ..writeln(
        'Here are the top ${info.name.toLowerCase()} professionals near you, ranked by trust score:',
      );

    if (recommended.isEmpty) {
      buffer.write(
        'No exact matches found yet, but you can still create a service request to get quotations.',
      );
    }

    return AiChatMessage(
      text: buffer.toString(),
      isUser: false,
      timestamp: DateTime.now(),
      recommendedProfessionals: recommended.isEmpty ? null : recommended,
      suggestedCategory: category,
      actions: _actionsFor(category),
    );
  }

  AiChatMessage _createRequestReply(String text) {
    final category = _detectedCategory ?? _detectCategory(text);
    if (category == null) {
      return AiChatMessage(
        text:
            'I\'ll help you create a service request! 📝\n\n'
            'First, could you describe the problem you\'re facing? '
            'For example: "My bathroom tap is leaking".',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }

    final info = _categories[category]!;
    return AiChatMessage(
      text:
          'Great! Let\'s create a $category service request. 🛠️\n\n'
          'I\'ll pre-fill the category for you. Nearby verified professionals will '
          'receive your request and send you quotations to compare.\n\n'
          'Tap the button below to continue:',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedCategory: category,
      suggestedTitle: info.name,
      actions: [
        AiAction(
          type: AiActionType.createRequest,
          label: 'Create $category Request',
          payload: category,
        ),
      ],
    );
  }

  AiChatMessage _tipsReply() {
    final category = _detectedCategory;
    if (category != null) {
      final tips = _categories[category]!.tips;
      return AiChatMessage(
        text:
            'Here are some maintenance tips for $category: 💡\n\n'
            '${tips.map((t) => '• $t').join('\n')}',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedCategory: category,
        actions: _actionsFor(category),
      );
    }

    return AiChatMessage(
      text:
          'Here are some general home maintenance tips: 💡\n\n'
          '• Inspect plumbing and electrical systems every 6 months\n'
          '• Clean AC filters monthly for better performance\n'
          '• Check for water leaks to avoid structural damage\n'
          '• Seal cracks and gaps to keep pests away\n\n'
          'Tell me which area you\'d like specific tips for — plumbing, electrical, '
          'painting, or appliances.',
      isUser: false,
      timestamp: DateTime.now(),
      actions: _suggestedActions,
    );
  }

  List<AiAction> _actionsFor(String category) => [
    AiAction(
      type: AiActionType.viewProfessionals,
      label: 'View $category Experts',
      payload: category,
    ),
    AiAction(
      type: AiActionType.createRequest,
      label: 'Create Service Request',
      payload: category,
    ),
  ];

  String? _nextQuestion(_CategoryInfo info) {
    for (final q in info.followUps) {
      if (!_askedQuestions.contains(q)) return q;
    }
    return null;
  }

  String? _detectCategory(String text) {
    String? best;
    var bestScore = 0;
    _categories.forEach((name, info) {
      var score = 0;
      for (final keyword in info.keywords) {
        if (text.contains(keyword)) {
          score++;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = name;
      }
    });
    return bestScore > 0 ? best : null;
  }

  List<ProfessionalModel> _recommendProfessionals(
    List<ProfessionalModel> all,
    String category,
  ) {
    final lower = category.toLowerCase();
    final matches = all.where((p) {
      final pc = p.category.toLowerCase();
      return pc == lower ||
          pc.contains(lower) ||
          p.skills.any((s) => s.toLowerCase().contains(lower)) ||
          p.subCategories.any((s) => s.toLowerCase().contains(lower));
    }).toList();

    matches.sort((a, b) => _trustScore(b).compareTo(_trustScore(a)));
    return matches.take(3).toList();
  }

  int _trustScore(ProfessionalModel p) {
    var score = 0;
    score += (p.rating * 10).round();
    if (p.isVerified) score += 30;
    if (p.isAvailable) score += 15;
    if (p.isOnline) score += 10;
    if (p.jobCount > 100) {
      score += 20;
    } else if (p.jobCount > 10) {
      score += 10;
    } else {
      score += 5;
    }
    return score;
  }

  bool _isGreeting(String t) {
    return RegExp(
      r'^(hello|hi|hey|namaste|good\s+(morning|afternoon|evening))\b',
    ).hasMatch(t);
  }

  bool _isThanks(String t) {
    return RegExp(r'^(thank|thanks|thx|dhanyabad)\b').hasMatch(t);
  }

  bool _isTipRequest(String t) {
    return t.contains('tip') ||
        t.contains('maintenance') ||
        t.contains('prevent') ||
        t.contains('how to care') ||
        t.contains('advice');
  }

  bool _isCostQuestion(String t) {
    return t.contains('cost') ||
        t.contains('price') ||
        t.contains('rate') ||
        t.contains('how much') ||
        t.contains('estimate') ||
        t.contains('charge') ||
        t.contains('budget') ||
        t.contains('fees');
  }

  bool _isCreateRequest(String t) {
    return t.contains('create request') ||
        t.contains('post request') ||
        t.contains('make request') ||
        t.contains('publish request') ||
        t.contains('hire');
  }

  bool _isProRequest(String t) {
    return t.contains('find') ||
        t.contains('show') ||
        t.contains('recommend') ||
        t.contains('near me') ||
        t.contains('looking for') ||
        t.contains('need a') ||
        t.contains('who can') ||
        t.contains('book');
  }
}
