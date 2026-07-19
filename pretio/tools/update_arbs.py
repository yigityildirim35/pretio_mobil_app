import json
import os

langs = {
    'en': {'cancel': 'Cancel', 'no': 'No'},
    'tr': {'cancel': 'İptal', 'no': 'Hayır'},
    'fr': {'cancel': 'Annuler', 'no': 'Non'},
    'de': {'cancel': 'Abbrechen', 'no': 'Nein'},
    'es': {'cancel': 'Cancelar', 'no': 'No'}
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
        
print("Updated ARB files.")
