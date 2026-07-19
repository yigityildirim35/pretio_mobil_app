import 'package:flutter/material.dart';
import '../models/category_model.dart';

import 'package:pretio/l10n/app_localizations.dart';

class CategoryCreationDialog extends StatefulWidget {
  final Function(CategoryModel) onCategoryCreated;
  final CategoryModel? initialCategory;

  const CategoryCreationDialog({super.key, required this.onCategoryCreated, this.initialCategory});

  @override
  State<CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  final _nameController = TextEditingController();
  int _selectedIconCode = Icons.category.codePoint;
  int _selectedColorValue = Colors.blue.toARGB32();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _nameController.text = widget.initialCategory!.name;
      _selectedIconCode = widget.initialCategory!.iconCode;
      _selectedColorValue = widget.initialCategory!.colorValue;
    }
  }

  static final List<IconData> _availableIcons = () {
    final icons = <IconData>[
    // --- FİNANS & KRİPTO & YATIRIM ---
    Icons.account_balance_wallet,
    Icons.savings,
    Icons.monetization_on,
    Icons.attach_money,
    Icons.currency_bitcoin,
    Icons.currency_exchange,
    Icons.credit_card,
    Icons.receipt_long,
    Icons.calculate,
    Icons.pie_chart,
    Icons.show_chart,
    Icons.trending_up,
    Icons.bar_chart,
    Icons.diamond,
    Icons.account_balance,

    // --- YEME & İÇME & KEYİF ---
    Icons.restaurant,
    Icons.fastfood,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.local_pizza,
    Icons.ramen_dining,
    Icons.bakery_dining,
    Icons.icecream,
    Icons.cake,
    Icons.lunch_dining,
    Icons.liquor,
    Icons.dinner_dining,
    Icons.kitchen,
    Icons.coffee_maker,

    // --- TEKNOLOJİ & DİJİTAL ---
    Icons.phone_iphone,
    Icons.laptop_mac,
    Icons.headphones,

    Icons.camera_alt,
    Icons.videogame_asset,
    Icons.mouse,
    Icons.keyboard,
    Icons.monitor,
    Icons.developer_mode,
    Icons.wifi,
    Icons.memory,
    Icons.router,
    Icons.sd_storage,

    // --- ULAŞIM & ARAÇ ---
    Icons.directions_car,
    Icons.directions_bus,
    Icons.directions_bike,
    Icons.two_wheeler, // Motor
    Icons.electric_scooter,
    Icons.flight_takeoff,
    Icons.train,
    Icons.directions_boat,
    Icons.subway,
    Icons.local_taxi,
    Icons.local_gas_station,
    Icons.ev_station,
    Icons.garage,

    // --- EV & YAŞAM & FATURALAR ---
    Icons.home,
    Icons.apartment,
    Icons.bed,
    Icons.chair, // Mobilya
    Icons.lightbulb, // Elektrik
    Icons.water_drop, // Su
    Icons.local_fire_department, // Gaz/Isınma
    Icons.cleaning_services,
    Icons.local_laundry_service,
    Icons.build, // Tamirat
    Icons.format_paint, // Dekorasyon
    Icons.yard, // Bahçe
    // --- SAĞLIK & BAKIM & SPOR ---
    Icons.fitness_center,
    Icons.pool,
    Icons.directions_run,
    Icons.self_improvement, // Yoga/Meditasyon
    Icons.spa,
    Icons.content_cut, // Berber/Kuaför
    Icons.face_retouching_natural, // Kozmetik
    Icons.medical_services,
    Icons.local_hospital,
    Icons.healing,
    Icons.monitor_heart,
    Icons.psychology, // Terapi
    // --- ALIŞVERİŞ & GİYİM ---
    Icons.shopping_bag,
    Icons.shopping_cart,
    Icons.checkroom, // Kıyafet
    Icons.watch,
    Icons.accessibility_new,

    Icons.loyalty, // İndirim/Kupon
    Icons.card_giftcard,

    // --- EĞLENCE & HOBİ & SOSYAL ---
    Icons.movie,
    Icons.music_note,
    Icons.theater_comedy,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_esports,
    Icons.palette, // Sanat
    Icons.brush,
    Icons.auto_stories, // Kitap
    Icons.photo_camera,
    Icons.celebration, // Parti
    Icons.festival,
    Icons.nightlife,

    // --- EĞİTİM & İŞ & KİŞİSEL ---
    Icons.school,
    Icons.menu_book,
    Icons.work,
    Icons.business_center,
    Icons.group,
    Icons.pets,
    Icons.child_friendly,
    Icons.card_travel,
    Icons.public, // Seyahat/Dünya
    Icons.map,
    Icons.lock, // Güvenlik
    Icons.shield,
    Icons.verified,
    Icons.bolt, // Enerji
    Icons.auto_awesome, // Diğer/Özel
  ];
  return icons.toSet().toList();
}();

  // --- GENİŞLETİLMİŞ RENK PALETİ ---
  static final List<Color> _availableColors = () {
    final List<MaterialColor> primaries = [
      Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
      Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
      Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
      Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
      Colors.brown, Colors.grey, Colors.blueGrey,
    ];
    
    final List<MaterialAccentColor> accents = [
      Colors.redAccent, Colors.pinkAccent, Colors.purpleAccent, Colors.deepPurpleAccent,
      Colors.indigoAccent, Colors.blueAccent, Colors.lightBlueAccent, Colors.cyanAccent,
      Colors.tealAccent, Colors.greenAccent, Colors.lightGreenAccent, Colors.limeAccent,
      Colors.yellowAccent, Colors.amberAccent, Colors.orangeAccent, Colors.deepOrangeAccent,
    ];

    List<Color> colors = [];
    
    for (int i = 0; i < primaries.length; i++) {
        final p = primaries[i];
        colors.addAll([
            p.shade100, p.shade300, p.shade500, p.shade700, p.shade900
        ]);
        if (i < accents.length) {
            final a = accents[i];
            colors.addAll([
                a.shade100, a.shade400, a.shade700
            ]);
        }
    }
    
    return colors.toSet().toList();
  }();

  void _handleCreate() {
    if (_nameController.text.isNotEmpty) {
      final newCategory = CategoryModel(
        id: widget.initialCategory?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        iconCode: _selectedIconCode,
        colorValue: _selectedColorValue,
        isDefault: widget.initialCategory?.isDefault ?? false,
      );
      widget.onCategoryCreated(newCategory);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialCategory != null ? AppLocalizations.of(context)!.edit : AppLocalizations.of(context)!.newCategory),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.categoryName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.selectIcon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180, // Balanced height
              width: double.maxFinite,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _availableIcons.length,
                itemBuilder: (context, index) {
                  final icon = _availableIcons[index];
                  final isSelected = _selectedIconCode == icon.codePoint;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIconCode = icon.codePoint;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.withValues(alpha: 0.2)
                            : null,
                        border: isSelected
                            ? Border.all(color: Theme.of(context).primaryColor)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.selectColor,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180, // Balanced height
              width: double.maxFinite,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _availableColors.length,
                itemBuilder: (context, index) {
                  final color = _availableColors[index];
                  final isSelected = _selectedColorValue == color.toARGB32();
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColorValue = color.toARGB32();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _handleCreate,
          child: Text(widget.initialCategory != null ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.create),
        ),
      ],
    );
  }
}
