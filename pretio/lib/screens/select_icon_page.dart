import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../features/brand_search/presentation/widgets/brand_search_field.dart';
import '../features/brand_search/presentation/widgets/brand_search_results.dart';
import 'package:pretio/l10n/app_localizations.dart';

class SelectIconPage extends StatefulWidget {
  const SelectIconPage({super.key});

  @override
  State<SelectIconPage> createState() => _SelectIconPageState();
}

class _SelectIconPageState extends State<SelectIconPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickAndCropImage() async {
    final theme = Theme.of(context);
    final picker = ImagePicker();

    // 1. Pick Image
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    // 2. Crop Image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ), // Square aspect ratio
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.editMyIcon,
          toolbarColor: theme.cardColor,
          toolbarWidgetColor: theme.textTheme.bodyLarge?.color,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true, // Clean UI just for 1:1 square
        ),
        IOSUiSettings(
          title: AppLocalizations.of(context)!.editMyIcon,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      if (!mounted) return;
      // 3. Return local path as logoUrl
      Navigator.pop(context, {
        'icon': Icons.image, // Fallback icon
        'color': theme.colorScheme.primary, // Fallback color
        'name': AppLocalizations.of(context)!.customIcon,
        'logoUrl': croppedFile.path,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final cardBgColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final mutedColor = textColor.withValues(alpha: 0.5);
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final primaryColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: borderColor,
                        offset: const Offset(0, 2),
                        blurRadius: 0,
                      ),
                    ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          l10n.selectIconTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 56), // Balance the leading button
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: borderColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            const BrandSearchField(),
            BrandSearchResults(
              onSelect: (name, logoUrl) {
                Navigator.pop(context, {
                  'icon': Icons.public,
                  'color': primaryColor,
                  'name': name,
                  'logoUrl': logoUrl,
                });
              },
            ),
            const SizedBox(height: 24),

            // Upload Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: mutedColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _pickAndCropImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, color: mutedColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        l10n.uploadIcon,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: mutedColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildCategorySection(
              title: l10n.popularCategory,
              mutedColor: mutedColor,
              children: [
                _buildColoredIconItem(
                  context: context,
                  icon: Icons.movie,
                  iconColor: Colors.white,
                  bgColor: Colors.red.shade600,
                  name: 'Netflix',
                  resultColor: Colors.red.shade600,
                ),
                _buildColoredIconItem(
                  context: context,
                  icon: Icons.music_note,
                  iconColor: Colors.white,
                  bgColor: const Color(0xFF1DB954),
                  name: 'Spotify',
                  resultColor: const Color(0xFF1DB954),
                ),
                _buildColoredIconItem(
                  context: context,
                  icon: Icons.play_arrow,
                  iconColor: Colors.white,
                  bgColor: Colors.red.shade600,
                  name: 'YouTube Premium',
                  resultColor: Colors.red.shade600,
                ),
                _buildColoredIconItem(
                  context: context,
                  icon: Icons.cloud,
                  iconColor: Colors.white,
                  bgColor: Colors.blue.shade500,
                  borderRadius: 8.0,
                  name: 'iCloud+',
                  resultColor: Colors.blue.shade500,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Finance Category
            _buildCategorySection(
              title: l10n.financeCategory,
              mutedColor: mutedColor,
              children: [
                _buildIconItem(
                  context: context,
                  icon: Icons.account_balance,
                  iconColor: Colors.blue.shade600,
                  name: l10n.bankWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.shield,
                  iconColor: Colors.amber.shade500,
                  name: l10n.insuranceWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.credit_card,
                  iconColor: Colors.teal.shade500,
                  name: l10n.creditCardWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.payments,
                  iconColor: Colors.indigo.shade500,
                  name: l10n.creditWord,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Education Category
            _buildCategorySection(
              title: l10n.educationCategory,
              mutedColor: mutedColor,
              children: [
                _buildIconItem(
                  context: context,
                  icon: Icons.school,
                  iconColor: Colors.orange.shade500,
                  name: l10n.schoolWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.menu_book,
                  iconColor: Colors.teal.shade500,
                  name: l10n.bookMagazineWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.psychology,
                  iconColor: Colors.purple.shade500,
                  name: l10n.personalDevWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.history_edu,
                  iconColor: Colors.pink.shade500,
                  name: l10n.courseWord,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Entertainment Category
            _buildCategorySection(
              title: l10n.entertainmentCategory,
              mutedColor: mutedColor,
              children: [
                _buildIconItem(
                  context: context,
                  icon: Icons.sports_esports,
                  iconColor: Colors.red.shade500,
                  name: l10n.gameWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.movie,
                  iconColor: Colors.blue.shade400,
                  name: l10n.cinemaSeriesWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.music_note,
                  iconColor: Colors.purple.shade600,
                  name: l10n.musicWord,
                ),
                _buildIconItem(
                  context: context,
                  icon: Icons.theater_comedy,
                  iconColor: Colors.yellow.shade500,
                  name: l10n.eventActivityWord,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required Color mutedColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: mutedColor,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ],
    );
  }

  Widget _buildIconItem({
    required BuildContext context,
    bool isImage = false,
    String? imageUrl,
    IconData? icon,
    Color? iconColor,
    String? name,
  }) {
    final theme = Theme.of(context);
    final cardBgColor = theme.cardColor;
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (!isImage && icon != null) {
          Navigator.pop(context, {
            'icon': icon,
            'color': iconColor ?? Colors.grey,
            'name': name,
          });
        }
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: borderColor,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: isImage && imageUrl != null
              ? Image.network(
                  imageUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                )
              : Icon(icon, color: iconColor, size: 32),
        ),
      ),
    );
  }

  Widget _buildColoredIconItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    double borderRadius = 20.0,
    String? name,
    Color? resultColor,
  }) {
    final theme = Theme.of(context);
    final cardBgColor = theme.cardColor;
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, {
          'icon': icon,
          'color': resultColor ?? bgColor,
          'name': name,
        });
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: borderColor,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ),
      ),
    );
  }
}
