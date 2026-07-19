import json
import os

langs = {
    'en': {
        'shadowItemHint': 'e.g. Coffee, headphones...'
    },
    'tr': {
        'shadowItemHint': 'Örn: Kahve, kulaklık...'
    },
    'fr': {
        'shadowItemHint': 'ex: Café, écouteurs...'
    },
    'de': {
        'shadowItemHint': 'z.B. Kaffee, Kopfhörer...'
    },
    'es': {
        'shadowItemHint': 'p. ej. Café, auriculares...'
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
print("Shadow item hint localizations injected!")
