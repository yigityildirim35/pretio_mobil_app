import json
import os

langs = {
    'en': {
        'obligationWarning': "This is a mandatory expense. It doesn't affect your daily limit, only deducted from your main balance.",
        'tapForDetails': "Tap for details"
    },
    'tr': {
        'obligationWarning': "Bu zorunlu bir harcamadır. Günlük limitinizi etkilemedi, yalnızca kalan ana bakiyenizden düşüldü.",
        'tapForDetails': "Detaylar için dokunun"
    },
    'fr': {
        'obligationWarning': "C'est une dépense obligatoire. Elle n'affecte pas votre limite quotidienne, déduite uniquement de votre solde principal.",
        'tapForDetails': "Appuyez pour plus de détails"
    },
    'de': {
        'obligationWarning': "Dies ist eine obligatorische Ausgabe. Sie wirkt sich nicht auf Ihr Tageslimit aus, sondern wird nur von Ihrem Hauptguthaben abgezogen.",
        'tapForDetails': "Tippen für Details"
    },
    'es': {
        'obligationWarning': "Este es un gasto obligatorio. No afecta su límite diario, solo se deduce de su saldo principal.",
        'tapForDetails': "Toque para ver detalles"
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
