import 'dart:io';
import 'dart:convert';

void main() {
  final l10nDir = Directory('lib/l10n');
  final files = l10nDir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  for (var file in files) {
    final content = file.readAsStringSync();
    final Map<String, dynamic> jsonMap = jsonDecode(content);

    final lang = file.path.split('_').last.replaceAll('.arb', '');

    if (lang == 'tr') {
      jsonMap['insightProjectionGood'] = 'Bu hızla harcarsanız ay sonunda hedefinizden %{percent} daha fazla birikim yapacaksınız.';
      jsonMap['@insightProjectionGood'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightProjectionBad'] = 'Bu hızla harcarsanız ay sonunda hedefinizden %{percent} daha az birikim yapacaksınız.';
      jsonMap['@insightProjectionBad'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightCategoryAlert'] = 'Bu ay en çok {category} kategorisinde harcama yaptınız.';
      jsonMap['@insightCategoryAlert'] = {
        'placeholders': {'category': {'type': 'String'}}
      };
      jsonMap['insightStreak'] = 'Harika! {days} gündür hiç harcama yapmadınız.';
      jsonMap['@insightStreak'] = {
        'placeholders': {'days': {'type': 'int'}}
      };
    } else if (lang == 'de') {
      jsonMap['insightProjectionGood'] = 'Bei diesem Tempo werden Sie am Monatsende {percent}% mehr als Ihr Ziel sparen.';
      jsonMap['@insightProjectionGood'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightProjectionBad'] = 'Bei diesem Tempo werden Sie am Monatsende {percent}% weniger als Ihr Ziel sparen.';
      jsonMap['@insightProjectionBad'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightCategoryAlert'] = 'Sie haben in diesem Monat am meisten in {category} ausgegeben.';
      jsonMap['@insightCategoryAlert'] = {
        'placeholders': {'category': {'type': 'String'}}
      };
      jsonMap['insightStreak'] = 'Großartig! Sie haben {days} Tage lang nichts ausgegeben.';
      jsonMap['@insightStreak'] = {
        'placeholders': {'days': {'type': 'int'}}
      };
    } else if (lang == 'es') {
      jsonMap['insightProjectionGood'] = 'A este ritmo, ahorrarás un {percent}% más que tu objetivo al final del mes.';
      jsonMap['@insightProjectionGood'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightProjectionBad'] = 'A este ritmo, ahorrarás un {percent}% menos que tu objetivo al final del mes.';
      jsonMap['@insightProjectionBad'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightCategoryAlert'] = 'Este mes gastaste más en la categoría {category}.';
      jsonMap['@insightCategoryAlert'] = {
        'placeholders': {'category': {'type': 'String'}}
      };
      jsonMap['insightStreak'] = '¡Genial! No has gastado nada durante {days} días.';
      jsonMap['@insightStreak'] = {
        'placeholders': {'days': {'type': 'int'}}
      };
    } else if (lang == 'fr') {
      jsonMap['insightProjectionGood'] = 'À ce rythme, vous économiserez {percent} % de plus que votre objectif à la fin du mois.';
      jsonMap['@insightProjectionGood'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightProjectionBad'] = 'À ce rythme, vous économiserez {percent} % de moins que votre objectif à la fin du mois.';
      jsonMap['@insightProjectionBad'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightCategoryAlert'] = 'Vous avez dépensé le plus dans la catégorie {category} ce mois-ci.';
      jsonMap['@insightCategoryAlert'] = {
        'placeholders': {'category': {'type': 'String'}}
      };
      jsonMap['insightStreak'] = 'Super ! Vous n\'avez rien dépensé pendant {days} jours.';
      jsonMap['@insightStreak'] = {
        'placeholders': {'days': {'type': 'int'}}
      };
    } else {
      // Default to English
      jsonMap['insightProjectionGood'] = 'At this rate, you will save {percent}% more than your target by month end.';
      jsonMap['@insightProjectionGood'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightProjectionBad'] = 'At this rate, you will save {percent}% less than your target by month end.';
      jsonMap['@insightProjectionBad'] = {
        'placeholders': {'percent': {'type': 'String'}}
      };
      jsonMap['insightCategoryAlert'] = 'You spent the most in the {category} category this month.';
      jsonMap['@insightCategoryAlert'] = {
        'placeholders': {'category': {'type': 'String'}}
      };
      jsonMap['insightStreak'] = 'Great! You haven\'t spent anything for {days} days.';
      jsonMap['@insightStreak'] = {
        'placeholders': {'days': {'type': 'int'}}
      };
    }

    final encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(jsonMap));
  }
}
