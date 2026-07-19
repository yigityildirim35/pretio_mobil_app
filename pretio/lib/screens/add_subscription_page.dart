import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import '../models/subscription.dart';
import 'select_icon_page.dart';
import '../features/brand_search/presentation/widgets/brand_logo_avatar.dart';
import 'package:pretio/l10n/app_localizations.dart';

class AddSubscriptionPage extends StatefulWidget {
  final bool isEditing;
  final Subscription? subscription;

  const AddSubscriptionPage({
    super.key,
    this.isEditing = false,
    this.subscription,
  });

  @override
  State<AddSubscriptionPage> createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _cycle = 'Aylık';
  IconData? _selectedIcon;
  Color? _selectedColor;
  String? _selectedLogoUrl;
  String _necessity = 'need'; // need, want, or necessity
  String _emotion = 'neutral'; // happy, neutral, regret

  String _getCycleText(String cycle, AppLocalizations l10n) {
    if (cycle == 'Aylık') return l10n.monthly;
    if (cycle == 'Yıllık') return l10n.yearly;
    return cycle;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.subscription != null) {
      _nameController.text = widget.subscription!.name;
      final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
      final rawPrice = double.tryParse(widget.subscription!.price) ?? 0.0;
      final displayPrice = currencyProvider.convertFromBase(rawPrice, currencyProvider.currency);
      _priceController.text = displayPrice % 1 == 0 
          ? displayPrice.toInt().toString() 
          : displayPrice.toStringAsFixed(2);
      _dateController.text = widget.subscription!.date;
      _cycle = widget.subscription!.cycle;
      _selectedIcon = widget.subscription!.icon;
      _selectedColor = widget.subscription!.color;
      _selectedLogoUrl = widget.subscription!.logoUrl;
      _necessity = widget.subscription!.necessity;
      _emotion = widget.subscription!.emotion;
      if (_emotion == 'sad') {
        _emotion = 'regret';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final cardBgColor = isDark ? theme.cardColor : Colors.white;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final mutedColor = isDark ? Colors.white54 : const Color(0xFF9CA3AF);
    final borderColor = isDark
        ? theme.dividerColor.withValues(alpha: 0.1)
        : const Color(0xFFE5E7EB);
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
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          widget.isEditing ? l10n.editSubscription : l10n.newSubscription,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // Icon Picker Section
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Center(
                        child: _selectedLogoUrl != null
                            ? (_selectedLogoUrl!.startsWith('http')
                                  ? BrandLogoAvatar(
                                      networkLogoUrl: _selectedLogoUrl,
                                      domain: '',
                                      size: 80,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.file(
                                        File(_selectedLogoUrl!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                            : Icon(
                                _selectedIcon ?? Icons.category_outlined,
                                size: 40,
                                color:
                                    _selectedColor ?? const Color(0xFFD1D5DB),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectIconPage(),
                            ),
                          );
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            setState(() {
                              if (result['icon'] != null) {
                                _selectedIcon = result['icon'];
                              }
                              if (result['color'] != null) {
                                _selectedColor = result['color'];
                              }
                              if (result['logoUrl'] != null) {
                                _selectedLogoUrl = result['logoUrl'];
                              } else {
                                // If they picked a local icon, clear logo
                                _selectedLogoUrl = null;
                              }
                              if (result['name'] != null &&
                                  _nameController.text.isEmpty) {
                                _nameController.text = result['name'];
                              }
                            });
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: cardBgColor, width: 3),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.serviceIconLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: mutedColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildInputField(
              label: l10n.serviceNameLabel,
              child: TextFormField(
                controller: _nameController,
                cursorColor: primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                decoration: _inputDecoration(
                  hintText: l10n.serviceNameHint,
                  borderColor: borderColor,
                  cardBgColor: cardBgColor,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _nameController.text = 'Netflix';
                              _selectedIcon = Icons.movie;
                              _selectedColor = const Color(0xFFE50914);
                              _selectedLogoUrl = null;
                            });
                          },
                          child: _buildPresetIcon(
                            Icons.movie,
                            const Color(0xFFE50914),
                            borderColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _nameController.text = 'Spotify';
                              _selectedIcon = Icons.music_note;
                              _selectedColor = const Color(0xFF1DB954);
                              _selectedLogoUrl = null;
                            });
                          },
                          child: _buildPresetIcon(
                            Icons.music_note,
                            const Color(0xFF1DB954),
                            borderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: l10n.monthlyFeeLabel,
                    child: TextFormField(
                      controller: _priceController,
                      cursorColor: primaryColor,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      decoration: _inputDecoration(
                        hintText: '0.00',
                        borderColor: borderColor,
                        cardBgColor: cardBgColor,
                        isDark: isDark,
                        primaryColor: primaryColor,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: Text(
                            Provider.of<CurrencyProvider>(context).currency,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: l10n.paymentCycleLabel,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _cycle,
                      icon: Icon(Icons.keyboard_arrow_down, color: mutedColor),
                      dropdownColor: cardBgColor,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      decoration: _inputDecoration(
                        borderColor: borderColor,
                        cardBgColor: cardBgColor,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      items: ['Aylık', 'Yıllık']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(_getCycleText(e, l10n), overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _cycle = val);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: l10n.wantNeedLabel,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _necessity,
                      icon: Icon(Icons.keyboard_arrow_down, color: mutedColor),
                      dropdownColor: cardBgColor,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      decoration: _inputDecoration(
                        borderColor: borderColor,
                        cardBgColor: cardBgColor,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'need',
                          child: Text(l10n.needItem, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: 'want',
                          child: Text(l10n.wantItem, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: 'necessity',
                          child: Text(l10n.necessityItem, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _necessity = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: l10n.moodLabel,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _emotion,
                      icon: Icon(Icons.keyboard_arrow_down, color: mutedColor),
                      dropdownColor: cardBgColor,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      decoration: _inputDecoration(
                        borderColor: borderColor,
                        cardBgColor: cardBgColor,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'happy',
                          child: Text(l10n.happyItem, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: 'neutral',
                          child: Text(l10n.neutralItem, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: 'regret',
                          child: Text(l10n.regretItem, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _emotion = val);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildInputField(
              label: l10n.nextPaymentDateLabel,
              child: TextFormField(
                controller: _dateController,
                cursorColor: primaryColor,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _dateController.text =
                          "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
                    });
                  }
                },
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                decoration: _inputDecoration(
                  hintText: l10n.dateHint,
                  borderColor: borderColor,
                  cardBgColor: cardBgColor,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: mutedColor,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: Provider.of<ThemeProvider>(context).is3DEnabled
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.5),
                          offset: const Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  final val = double.tryParse(_priceController.text) ?? 0.0;
                  if (val < 0.01) return; // Prevent 0 or practically zero price

                  final newSub = Subscription(
                    id: widget.isEditing
                        ? widget.subscription!.id
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text.isEmpty
                        ? l10n.unnamed
                        : _nameController.text,
                    price: () {
                      final val = double.tryParse(_priceController.text) ?? 0.0;
                      final baseAmount = Provider.of<CurrencyProvider>(context, listen: false)
                          .convertToBase(val, Provider.of<CurrencyProvider>(context, listen: false).currency);
                      return baseAmount.toString();
                    }(),
                    date: _dateController.text.isEmpty
                        ? l10n.notSpecified
                        : _dateController.text,
                    cycle: _cycle,
                    icon: _selectedIcon ?? Icons.category_outlined,
                    color: _selectedColor ?? Colors.grey,
                    necessity: _necessity,
                    emotion: _emotion,
                    logoUrl: _selectedLogoUrl,
                  );

                  if (widget.isEditing) {
                    context.read<SubscriptionProvider>().updateSubscription(
                      widget.subscription!.id,
                      newSub,
                    );
                  } else {
                    context.read<SubscriptionProvider>().addSubscription(
                      newSub,
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  widget.isEditing
                      ? l10n.saveChanges
                      : l10n.saveSubscription,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            if (widget.isEditing) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(
                      color: theme.colorScheme.error.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    if (widget.subscription != null) {
                      context.read<SubscriptionProvider>().deleteSubscription(
                        widget.subscription!.id,
                      );
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: Text(
                    l10n.deleteSubscription,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedColor = isDark ? Colors.white54 : const Color(0xFF6B7280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: mutedColor,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildPresetIcon(IconData icon, Color color, Color borderColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    required Color borderColor,
    required Color cardBgColor,
    required bool isDark,
    required Color primaryColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white30 : const Color(0xFFD1D5DB),
      ),
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: cardBgColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}
