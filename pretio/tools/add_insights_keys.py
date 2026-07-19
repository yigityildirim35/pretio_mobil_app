import json
import os

langs = {
    'en': {
        'insightsTitle': 'Predictive Insights',
        'goalUnreachable': 'Your current spending rate prevents you from saving. Goal is unreachable!',
        'goalReachableDesc': 'At your current spending rate, you will reach your goal in approximately {days} days.',
        '@goalReachableDesc': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetEmptyWarning': 'Warning: At this spending rate, your budget will run out in {days} days!',
        '@budgetEmptyWarning': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetSafe': 'Your budget is safe at the current spending rate.'
    },
    'tr': {
        'insightsTitle': 'Gelecek Öngörüleri',
        'goalUnreachable': 'Mevcut harcama hızınız tasarruf etmenizi engelliyor. Hedefinize ulaşılamıyor!',
        'goalReachableDesc': 'Mevcut harcama hızınızla, hedefinize yaklaşık {days} gün içinde ulaşacaksınız.',
        '@goalReachableDesc': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetEmptyWarning': 'Uyarı: Bu harcama hızında bütçeniz {days} gün içinde tükenecek!',
        '@budgetEmptyWarning': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetSafe': 'Mevcut harcama hızınızda bütçeniz güvende.'
    },
    'fr': {
        'insightsTitle': 'Aperçus Prédictifs',
        'goalUnreachable': 'Votre rythme de dépense actuel vous empêche d\'économiser. Objectif inatteignable !',
        'goalReachableDesc': 'À votre rythme de dépense actuel, vous atteindrez votre objectif dans environ {days} jours.',
        '@goalReachableDesc': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetEmptyWarning': 'Attention : À ce rythme de dépense, votre budget sera épuisé dans {days} jours !',
        '@budgetEmptyWarning': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetSafe': 'Votre budget est en sécurité au rythme de dépense actuel.'
    },
    'de': {
        'insightsTitle': 'Vorausschauende Einblicke',
        'goalUnreachable': 'Ihre aktuelle Ausgabenrate verhindert, dass Sie sparen. Ziel ist unerreichbar!',
        'goalReachableDesc': 'Bei Ihrer aktuellen Ausgabenrate erreichen Sie Ihr Ziel in etwa {days} Tagen.',
        '@goalReachableDesc': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetEmptyWarning': 'Warnung: Bei dieser Ausgabenrate ist Ihr Budget in {days} Tagen aufgebraucht!',
        '@budgetEmptyWarning': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetSafe': 'Ihr Budget ist bei der aktuellen Ausgabenrate sicher.'
    },
    'es': {
        'insightsTitle': 'Perspectivas Predictivas',
        'goalUnreachable': 'Tu tasa de gasto actual impide que ahorres. ¡La meta es inalcanzable!',
        'goalReachableDesc': 'A tu tasa de gasto actual, alcanzarás tu meta en aproximadamente {days} días.',
        '@goalReachableDesc': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetEmptyWarning': 'Advertencia: ¡A esta tasa de gasto, tu presupuesto se agotará en {days} días!',
        '@budgetEmptyWarning': {
            'placeholders': {
                'days': {'type': 'int'}
            }
        },
        'budgetSafe': 'Tu presupuesto está a salvo con la tasa de gasto actual.'
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
print("Keys injected and flutter gen-l10n ran.")
