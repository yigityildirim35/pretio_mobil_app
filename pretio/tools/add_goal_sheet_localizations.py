import json
import os

langs = {
    'en': {
        'goalUpdateGoalTitle': 'Update Goal',
        'goalNameInputLabel': 'Item Name',
        'goalTargetPrice': 'Target Price',
        'goalSaveBtn': 'Save',
        'goalUpdateGoalsTitle': 'Update Goals',
        'goalMonthlySavingsTarget': 'Monthly Savings Target'
    },
    'tr': {
        'goalUpdateGoalTitle': 'Hedefi Güncelle',
        'goalNameInputLabel': 'Alınacak Şeyin Adı',
        'goalTargetPrice': 'Hedef Fiyat',
        'goalSaveBtn': 'Kaydet',
        'goalUpdateGoalsTitle': 'Hedefleri Güncelle',
        'goalMonthlySavingsTarget': 'Aylık Birikim Hedefi'
    },
    'fr': {
        'goalUpdateGoalTitle': 'Mettre à jour l\'objectif',
        'goalNameInputLabel': 'Nom de l\'article',
        'goalTargetPrice': 'Prix cible',
        'goalSaveBtn': 'Enregistrer',
        'goalUpdateGoalsTitle': 'Mettre à jour les objectifs',
        'goalMonthlySavingsTarget': 'Objectif d\'épargne mensuel'
    },
    'de': {
        'goalUpdateGoalTitle': 'Ziel aktualisieren',
        'goalNameInputLabel': 'Artikelname',
        'goalTargetPrice': 'Zielpreis',
        'goalSaveBtn': 'Speichern',
        'goalUpdateGoalsTitle': 'Ziele aktualisieren',
        'goalMonthlySavingsTarget': 'Monatliches Sparziel'
    },
    'es': {
        'goalUpdateGoalTitle': 'Actualizar Objetivo',
        'goalNameInputLabel': 'Nombre del Artículo',
        'goalTargetPrice': 'Precio Objetivo',
        'goalSaveBtn': 'Guardar',
        'goalUpdateGoalsTitle': 'Actualizar Objetivos',
        'goalMonthlySavingsTarget': 'Objetivo de Ahorro Mensual'
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
print("Goal Sheet localizations injected!")
