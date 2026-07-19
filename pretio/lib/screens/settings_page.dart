import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/profile_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/transaction_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/theme_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

import 'app_purpose_page.dart';
import 'about_app_page.dart';
import 'creators_page.dart';
import 'boot_screen.dart';
import '../services/local_storage_service.dart';
import '../providers/subscription_provider.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;

  late FocusNode _nameFocusNode;

  bool _isNeedsWantsEnabled = true;
  bool _isEmotionsEnabled = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _balanceController = TextEditingController();

    _nameFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      _loadLocalPreferences();
    });
  }

  void _loadInitialData() {
    final profileProv = Provider.of<ProfileProvider>(context, listen: false);
    final txProv = Provider.of<TransactionProvider>(context, listen: false);
    final currencyProv = Provider.of<CurrencyProvider>(context, listen: false);

    _nameController.text = profileProv.name;
    
    // Convert base TRY initialBalance to current currency for display
    final convertedBalance = currencyProv.convertFromBase(txProv.initialBalance, currencyProv.currency);
    _balanceController.text = convertedBalance.toStringAsFixed(0);
  }

  Future<void> _loadLocalPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNeedsWantsEnabled = prefs.getBool('settings_needs_enabled') ?? true;
      _isEmotionsEnabled = prefs.getBool('settings_emotions_enabled') ?? true;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();

    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null && mounted) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: AppLocalizations.of(context)!.editPhoto,
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true,
            ),
            IOSUiSettings(
              title: AppLocalizations.of(context)!.editPhoto,
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
            ),
          ],
        );

        if (croppedFile != null && mounted) {
          await Provider.of<ProfileProvider>(
            context,
            listen: false,
          ).updatePickedImage(croppedFile.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  void _showAvatarSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.selectAvatar,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 10,
                  itemBuilder: (_, index) {
                    if (index == 9) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }

                    final assetPath = 'assets/Avatars/${index + 1}.png';
                    final provider = Provider.of<ProfileProvider>(context);
                    final isSelected =
                        provider.selectedAvatarAsset == assetPath;

                    return GestureDetector(
                      onTap: () async {
                        await Provider.of<ProfileProvider>(
                          context,
                          listen: false,
                        ).updateAvatar(assetPath);
                        if (mounted) Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final cardBgColor = theme.cardColor;
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final textColor = theme.colorScheme.onSurface;
    final mutedColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final inputBgColor = theme.canvasColor;

    final primaryColor = Theme.of(context).colorScheme.primary;
    final blueColor = const Color(0xFF1cb0f6);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mutedColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsAndPreferences.toUpperCase(),
          style: TextStyle(
            color: mutedColor,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: borderColor, height: 2),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HESAP SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  l10n.account,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: borderColor, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Profil İsmi
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileNameLabel.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: mutedColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBgColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  onSubmitted: (val) {
                                    Provider.of<ProfileProvider>(
                                      context,
                                      listen: false,
                                    ).updateName(val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.edit, color: mutedColor),
                                onPressed: () => _nameFocusNode.requestFocus(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // Avatar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.avatarLabel.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.personalizeCharacter,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _showAvatarSelectionDialog,
                            style:
                                ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ).copyWith(
                                  side: const WidgetStatePropertyAll(
                                    BorderSide(color: Colors.transparent),
                                  ),
                                ),
                            child: Text(
                              l10n.changeAvatar.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // FINANSAL AYARLAR SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  l10n.balanceAndFinance,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: borderColor, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Başlangıç Bakiyesi
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                             l10n.balanceInfoLabel.toUpperCase(),
                             style: TextStyle(
                               fontSize: 10,
                               fontWeight: FontWeight.w900,
                               color: mutedColor,
                               letterSpacing: 1.0,
                             ),
                           ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _balanceController,
                            obscureText: Provider.of<CurrencyProvider>(context).isPrivacyModeEnabled,
                            obscuringCharacter: '*',
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputBgColor,
                              prefixIcon: Center(
                                widthFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    Provider.of<CurrencyProvider>(
                                      context,
                                    ).currency,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: mutedColor,
                                    ),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (val) {
                              final amount = double.tryParse(val);
                              if (amount != null) {
                                final txProv = Provider.of<TransactionProvider>(
                                  context,
                                  listen: false,
                                );
                                final currencyProv = Provider.of<CurrencyProvider>(
                                  context,
                                  listen: false,
                                );
                                
                                // Convert input from active currency to base (TRY) before saving
                                final baseAmount = currencyProv.convertToBase(amount, currencyProv.currency);
                                
                                txProv.updateInitialBalance(baseAmount);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currentNetBalance.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: mutedColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: TextEditingController(
                              text: Provider.of<CurrencyProvider>(context).convertFromBase(Provider.of<TransactionProvider>(context).currentBalance, Provider.of<CurrencyProvider>(context).currency).toStringAsFixed(0)
                            ),
                            readOnly: true,
                            obscureText: Provider.of<CurrencyProvider>(context).isPrivacyModeEnabled,
                            obscuringCharacter: '*',
                            onTap: () => _showBalanceOptionsDialog(context),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputBgColor,
                              prefixIcon: Center(
                                widthFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    Provider.of<CurrencyProvider>(context).currency,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: mutedColor,
                                    ),
                                  ),
                                ),
                              ),
                              suffixIcon: Icon(Icons.ads_click, color: mutedColor, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // Para Birimi
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currencyLabel.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: mutedColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: inputBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: 2),
                            ),
                            child: Consumer<CurrencyProvider>(
                              builder: (context, currencyProv, _) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: currencyProv.currency,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: mutedColor,
                                    ),
                                    dropdownColor: cardBgColor,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    onChanged: (String? val) {
                                      if (val != null) {
                                        currencyProv.setCurrency(val);
                                        
                                        // Update balance controller with new currency value
                                        final txProv = Provider.of<TransactionProvider>(context, listen: false);
                                        final convertedBalance = currencyProv.convertFromBase(txProv.initialBalance, val);
                                        _balanceController.text = convertedBalance.toStringAsFixed(0);
                                      }
                                    },
                                    items: <String>['TRY', 'USD', 'EUR']
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          String label = 'TRY (₺)';
                                          if (value == 'USD') {
                                            label = 'USD (\$)';
                                          } else if (value == 'EUR') {
                                            label = 'EUR (€)';
                                          }
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(label),
                                          );
                                        })
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // GÖRÜNÜM SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  l10n.appearance,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: borderColor, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Dil Seçimi
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.languageSelectionLabel.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: mutedColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: inputBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: 2),
                            ),
                            child: Consumer<LocaleProvider>(
                              builder: (context, localeProv, _) {
                                String currentVal = 'Türkçe';
                                if (localeProv.locale?.languageCode == 'en') {
                                  currentVal = 'English';
                                } else if (localeProv.locale?.languageCode == 'fr') {
                                  currentVal = 'Français';
                                } else if (localeProv.locale?.languageCode == 'de') {
                                  currentVal = 'Deutsch';
                                } else if (localeProv.locale?.languageCode == 'es') {
                                  currentVal = 'Español';
                                }

                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: currentVal,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: mutedColor,
                                    ),
                                    dropdownColor: cardBgColor,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        String code = 'tr';
                                        if (newValue == 'English') {
                                          code = 'en';
                                        } else if (newValue == 'Français') {
                                          code = 'fr';
                                        } else if (newValue == 'Deutsch') {
                                          code = 'de';
                                        } else if (newValue == 'Español') {
                                          code = 'es';
                                        }

                                        localeProv.setLocale(Locale(code));
                                      }
                                    },
                                    items:
                                        <String>[
                                          'Türkçe',
                                          'English',
                                          'Français',
                                          'Deutsch',
                                          'Español',
                                        ].map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // Temalar Seçimi
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.themesLabel.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: mutedColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildThemeButton(
                                  0,
                                  l10n.themeLight,
                                  Icons.light_mode,
                                  const Color(0xFFF6F8F7),
                                  Colors.black87,
                                  themeProvider,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildThemeButton(
                                  1,
                                  l10n.themeForest,
                                  Icons.forest,
                                  const Color.fromARGB(255, 8, 71, 32),
                                  Colors.white,
                                  themeProvider,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildThemeButton(
                                  4,
                                  l10n.themeCottonCandy,
                                  Icons.auto_awesome,
                                  const Color(0xFFFFB6C1),
                                  Colors.white,
                                  themeProvider,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildThemeButton(
                                  5,
                                  l10n.themeSunset,
                                  Icons.wb_twilight,
                                  const Color.fromARGB(153, 197, 149, 5),
                                  Colors.white,
                                  themeProvider,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildThemeButton(
                                  2,
                                  l10n.themeProfileDark,
                                  Icons.cloud,
                                  const Color.fromARGB(255, 16, 43, 54),
                                  Colors.white,
                                  themeProvider,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildThemeButton(
                                  3,
                                  l10n.themeAmoled,
                                  Icons.nightlight_round,
                                  const Color.fromARGB(239, 0, 0, 0),
                                  Colors.white,
                                  themeProvider,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // TERCİHLER SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  l10n.preferences,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: borderColor, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Parayı Gizle
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.hideSpentMoney.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.privacyMode,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: mutedColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildSwitch(currencyProvider.isPrivacyModeEnabled, (
                            val,
                          ) {
                            currencyProvider.setPrivacyModeEnabled(val);
                          }, isDark),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),

                    // İstek/İhtiyaç Seçici
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.needWantModule.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.showWhenAddingNew,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: mutedColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildSwitch(_isNeedsWantsEnabled, (val) {
                            setState(() => _isNeedsWantsEnabled = val);
                            _savePreference('settings_needs_enabled', val);
                            themeProvider.setNeedWantModuleEnabled(val);
                          }, isDark),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // Ruh Hali Seçici
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.emotionModule.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.showWhenAddingNew,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: mutedColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildSwitch(_isEmotionsEnabled, (val) {
                            setState(() => _isEmotionsEnabled = val);
                            _savePreference('settings_emotions_enabled', val);
                            themeProvider.setEmotionModuleEnabled(val);
                          }, isDark),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // 3D Görünüm
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.view3D.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.addEmbossEffect,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: mutedColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildSwitch(themeProvider.is3DEnabled, (val) {
                            themeProvider.set3DEnabled(val);
                          }, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // SIFIRLA SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  l10n.reset,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: borderColor, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.deleteAll.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.deletePermanently,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _showResetConfirmationDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withValues(alpha: 0.1),
                              foregroundColor: Colors.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).copyWith(
                              side: const WidgetStatePropertyAll(
                                BorderSide(color: Colors.transparent),
                              ),
                            ),
                            child: Text(
                              l10n.buttonDelete.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // HAKKINDA SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  l10n.about,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: borderColor, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Uygulama Amacı
                    _buildAboutTile(
                      context,
                      l10n.appPurpose.toUpperCase(),
                      l10n.whyAreWeHere,
                      Icons.info_outline,
                      const AppPurposePage(),
                      mutedColor,
                      textColor,
                      primaryColor,
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // Uygulama Hakkında
                    _buildAboutTile(
                      context,
                      l10n.aboutApp.toUpperCase(),
                      l10n.versionAndDetails,
                      Icons.phone_android,
                      const AboutAppPage(),
                      mutedColor,
                      textColor,
                      primaryColor,
                    ),
                    Divider(height: 1, thickness: 2, color: borderColor),
                    // Yapımcılar
                    _buildAboutTile(
                      context,
                      l10n.creators.toUpperCase(),
                      l10n.whoDevelopedIt,
                      Icons.people_outline,
                      const CreatorsPage(),
                      mutedColor,
                      textColor,
                      primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton(
    int index,
    String title,
    IconData icon,
    Color bgColor,
    Color contentColor,
    ThemeProvider themeProvider,
  ) {
    final isSelected = themeProvider.themeIndex == index;
    return GestureDetector(
      onTap: () => themeProvider.setTheme(index),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: contentColor, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged, bool isDark) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value
              ? Theme.of(context).colorScheme.primary
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          border: Border.all(
            color: value
                ? Theme.of(context).colorScheme.primary
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 2,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget page,
    Color mutedColor,
    Color textColor,
    Color primaryColor,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, color: primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: mutedColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: mutedColor),
          ],
        ),
      ),
    );
  }
  void _showBalanceOptionsDialog(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.accountOperations, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.green),
              title: Text(l10n.addIncome, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.unexpectedMoney),
              onTap: () {
                Navigator.pop(context);
                _showAddIncomeDialog(context, provider, currencyProvider);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.blue),
              title: Text(l10n.editTotalBalance),
              subtitle: Text(l10n.resetInitialBalance),
              onTap: () {
                Navigator.pop(context);
                _showEditBalanceDialog(context, provider, currencyProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIncomeDialog(BuildContext context, TransactionProvider provider, CurrencyProvider currencyProvider) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(l10n.addIncome),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.enterAmount,
            suffixText: currencyProvider.currency,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val >= 0.01) {
                final baseAmount = currencyProvider.convertToBase(val, currencyProvider.currency);
                provider.addBonusIncome(baseAmount, l10n.income, l10n.income);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.buttonAdd),
          ),
        ],
      ),
    );
  }

  void _showEditBalanceDialog(BuildContext context, TransactionProvider provider, CurrencyProvider currencyProvider) {
    final displayValue = currencyProvider.convertFromBase(provider.initialBalance, currencyProvider.currency);
    final controller = TextEditingController(text: displayValue.toStringAsFixed(0));
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(l10n.updateBalance),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(suffixText: currencyProvider.currency),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                final baseBalance = currencyProvider.convertToBase(val, currencyProvider.currency);
                provider.updateInitialBalance(baseBalance);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.buttonUpdate),
          ),
        ],
      ),
    );
  }
  void _showResetConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(l10n.areYouSure),
        content: Text(l10n.deleteWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.no, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalResetCountdownDialog(context);
            },
            child: Text(l10n.yesContinue, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showFinalResetCountdownDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return _ResetCountdownDialogContent(
            onReset: () async {
              await _performFullReset();
            },
          );
        },
      ),
    );
  }

  Future<void> _performFullReset() async {
    final storage = LocalStorageService();
    await storage.clearAllData();

    if (!mounted) return;

    // Reset all providers in memory
    final txProv = Provider.of<TransactionProvider>(context, listen: false);
    final profileProv = Provider.of<ProfileProvider>(context, listen: false);
    final currencyProv = Provider.of<CurrencyProvider>(context, listen: false);
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    final localeProv = Provider.of<LocaleProvider>(context, listen: false);
    final subProv = Provider.of<SubscriptionProvider>(context, listen: false);

    // Some providers might need manual triggers to reload from empty state
    await txProv.loadData();
    await profileProv.loadProfileData();
    await currencyProv.init();
    await themeProv.loadTheme();
    await localeProv.loadLocale();
    await subProv.loadSubscriptions(); 

    // Final navigation to splash/boot screen
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BootScreen()),
        (route) => false,
      );
    }
  }
}

class _ResetCountdownDialogContent extends StatefulWidget {
  final VoidCallback onReset;
  const _ResetCountdownDialogContent({required this.onReset});

  @override
  State<_ResetCountdownDialogContent> createState() => _ResetCountdownDialogContentState();
}

class _ResetCountdownDialogContentState extends State<_ResetCountdownDialogContent> {
  int _secondsRemaining = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _secondsRemaining == 0;
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(l10n.finalConfirmation),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.pressToClearData),
          if (!isReady)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                l10n.secondsRemaining(_secondsRemaining),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: isReady ? widget.onReset : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isReady ? Colors.red : Colors.grey.shade300,
            foregroundColor: Colors.white,
          ),
          child: Text(isReady ? l10n.deleteNow : l10n.waiting),
        ),
      ],
    );
  }
}

