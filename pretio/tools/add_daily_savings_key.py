import json
import os

langs = {
    'en': {'dailyAverageSavings': 'Daily Average Savings'},
    'tr': {'dailyAverageSavings': 'Günlük Ortalama Birikim'},
    'fr': {'dailyAverageSavings': 'Épargne Moyenne Quotidienne'},
    'de': {'dailyAverageSavings': 'Durchschnittliche Tägliche Ersparnisse'},
    'es': {'dailyAverageSavings': 'Ahorro Promedio Diario'}
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
print("Keys injected and flutter gen-l10n ran.")
