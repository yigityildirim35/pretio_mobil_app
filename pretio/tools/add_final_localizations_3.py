import json
import os

langs = {
    'en': {
        'transactionCount': '{count} Transactions',
        '@transactionCount': { 'placeholders': { 'count': { 'type': 'String' } } },
        'noRecordsToday': 'No records for this day.'
    },
    'tr': {
        'transactionCount': '{count} İşlem',
        '@transactionCount': { 'placeholders': { 'count': { 'type': 'String' } } },
        'noRecordsToday': 'Bu gün için kayıt yok.'
    },
    'fr': {
        'transactionCount': '{count} Transactions',
        '@transactionCount': { 'placeholders': { 'count': { 'type': 'String' } } },
        'noRecordsToday': 'Aucun enregistrement pour ce jour.'
    },
    'de': {
        'transactionCount': '{count} Transaktionen',
        '@transactionCount': { 'placeholders': { 'count': { 'type': 'String' } } },
        'noRecordsToday': 'Keine Einträge für diesen Tag.'
    },
    'es': {
        'transactionCount': '{count} Transacciones',
        '@transactionCount': { 'placeholders': { 'count': { 'type': 'String' } } },
        'noRecordsToday': 'No hay registros para este día.'
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
print("Final localizations 3 injected!")
