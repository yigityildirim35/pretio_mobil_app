import 'package:flutter/material.dart';
import 'dart:io';
import '../services/local_storage_service.dart';
import '../models/user_badge_progress.dart';
import '../data/badge_engine.dart';
import '../data/badge_repository.dart';
import 'transaction_provider.dart';
import 'subscription_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  String _name = 'Alex Morgan';
  String? _selectedAvatarAsset;
  File? _pickedImage;
  List<UserBadgeProgress> _badges = [];

  String get name => _name;
  String? get selectedAvatarAsset => _selectedAvatarAsset;
  File? get pickedImage => _pickedImage;
  List<UserBadgeProgress> get badges => _badges;

  // Initial Load
  Future<void> loadProfileData() async {
    final name = await _storageService.getProfileName();
    final avatarAsset = await _storageService.getSelectedAvatar();
    final pickedPath = await _storageService.getPickedImagePath();
    final storedBadges = await _storageService.loadBadges();

    if (name != null) _name = name;
    _selectedAvatarAsset = avatarAsset;
    if (pickedPath != null) {
      _pickedImage = File(pickedPath);
    }

    if (storedBadges.isNotEmpty) {
      _badges = storedBadges;
    } else {
      _initDefaultBadges();
    }

    notifyListeners();
  }

  void _initDefaultBadges() {
    _badges = BadgeRepository.badges
        .map((def) => UserBadgeProgress.initial(def.id))
        .toList();
  }

  // Update Methods
  Future<void> updateName(String newName) async {
    _name = newName;
    notifyListeners();
    await _storageService.saveProfileName(newName);
  }

  Future<void> updateAvatar(String? assetPath) async {
    _selectedAvatarAsset = assetPath;
    _pickedImage = null; // Clear picked image if avatar is selected
    notifyListeners();
    await _storageService.saveSelectedAvatar(assetPath);
    await _storageService.savePickedImagePath(null);
  }

  Future<void> updatePickedImage(String path) async {
    _pickedImage = File(path);
    _selectedAvatarAsset = null; // Clear avatar if image is picked
    notifyListeners();
    await _storageService.savePickedImagePath(path);
    await _storageService.saveSelectedAvatar(null);
  }

  void evaluateBadges(
    TransactionProvider txProvider,
    SubscriptionProvider subProvider,
  ) {
    // Map current list to Map for engine
    Map<String, UserBadgeProgress> currentMap = {
      for (var b in _badges) b.badgeId: b,
    };

    final newMap = BadgeEngine.evaluateAll(
      currentProgresses: currentMap,
      txProv: txProvider,
      subProv: subProvider,
    );

    _badges = newMap.values.toList();
    _storageService.saveBadges(_badges);
    notifyListeners();
  }
}
