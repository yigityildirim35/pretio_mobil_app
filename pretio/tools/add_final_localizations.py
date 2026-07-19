import json
import os

langs = {
    'en': {
        'spentAmount': 'Spent',
        'lastMonthPlus': 'Last month: +{diff}%',
        '@lastMonthPlus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'lastMonthMinus': 'Last month: {diff}%',
        '@lastMonthMinus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'sameAsLastMonth': 'Same as last month',
        'newData': 'New Data'
    },
    'tr': {
        'spentAmount': 'Harcanan',
        'lastMonthPlus': 'Geçen ay: +%{diff}',
        '@lastMonthPlus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'lastMonthMinus': 'Geçen ay: %{diff}',
        '@lastMonthMinus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'sameAsLastMonth': 'Geçen ay ile aynı',
        'newData': 'Yeni Veri'
    },
    'fr': {
        'spentAmount': 'Dépensé',
        'lastMonthPlus': 'Mois dernier: +{diff}%',
        '@lastMonthPlus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'lastMonthMinus': 'Mois dernier: {diff}%',
        '@lastMonthMinus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'sameAsLastMonth': 'Identique au mois dernier',
        'newData': 'Nouvelles données'
    },
    'de': {
        'spentAmount': 'Ausgegeben',
        'lastMonthPlus': 'Letzter Monat: +{diff}%',
        '@lastMonthPlus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'lastMonthMinus': 'Letzter Monat: {diff}%',
        '@lastMonthMinus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'sameAsLastMonth': 'Gleich wie im letzten Monat',
        'newData': 'Neue Daten'
    },
    'es': {
        'spentAmount': 'Gastado',
        'lastMonthPlus': 'Mes pasado: +{diff}%',
        '@lastMonthPlus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'lastMonthMinus': 'Mes pasado: {diff}%',
        '@lastMonthMinus': { 'placeholders': { 'diff': { 'type': 'String' } } },
        'sameAsLastMonth': 'Igual que el mes pasado',
        'newData': 'Nuevos datos'
    }
}

base_dir = r"c:\Users\yyild\Desktop\y\pretio\lib\l10n"

for lang, keys in langs.items():
    path = os.path.join(base_dir, f'app_{lang}.arb')
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in keys.items():
        data[k] = v
        
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        
os.system("(cd c:\\Users\\yyild\\Desktop\\y\\pretio && flutter gen-l10n)")
print("Final localizations injected!")
