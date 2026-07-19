import json
import os

langs = {
    'en': {
        'accountActions': 'Account Actions',
        'addIncome': 'Add Income',
        'addIncomeDesc': 'Did you receive unexpected money?',
        'enterAmount': 'Enter amount',
        'noNoteAttached': 'No note attached',
        'categoryDistribution': 'Category Distribution',
        'balanceSummary': 'Balance Summary',
        'remainingBalanceText': 'Remaining Balance',
        'categoryBudgetShare': 'Category Share: {percentage}%',
        '@categoryBudgetShare': {
            'placeholders': {
                'percentage': {'type': 'String'}
            }
        }
    },
    'tr': {
        'accountActions': 'Hesap İşlemleri',
        'addIncome': 'Gelir Ekle',
        'addIncomeDesc': 'Beklenmedik bir para mı geldi?',
        'enterAmount': 'Miktar girin',
        'noNoteAttached': 'Not eklenmemiş',
        'categoryDistribution': 'Kategori Dağılımı',
        'balanceSummary': 'Bakiye Özeti',
        'remainingBalanceText': 'Kalan Bakiye',
        'categoryBudgetShare': 'Bütçe Payı: %{percentage}',
        '@categoryBudgetShare': {
            'placeholders': {
                'percentage': {'type': 'String'}
            }
        }
    },
    'fr': {
        'accountActions': 'Actions du Compte',
        'addIncome': 'Ajouter un Revenu',
        'addIncomeDesc': 'Avez-vous reçu de l\'argent inattendu ?',
        'enterAmount': 'Entrez le montant',
        'noNoteAttached': 'Aucune note',
        'categoryDistribution': 'Répartition par Catégorie',
        'balanceSummary': 'Résumé du Solde',
        'remainingBalanceText': 'Solde Restant',
        'categoryBudgetShare': 'Part du Budget : {percentage}%',
        '@categoryBudgetShare': {
            'placeholders': {
                'percentage': {'type': 'String'}
            }
        }
    },
    'de': {
        'accountActions': 'Kontoaktionen',
        'addIncome': 'Einkommen Hinzufügen',
        'addIncomeDesc': 'Haben Sie unerwartetes Geld erhalten?',
        'enterAmount': 'Betrag eingeben',
        'noNoteAttached': 'Keine Notiz',
        'categoryDistribution': 'Kategorienverteilung',
        'balanceSummary': 'Kontostandszusammenfassung',
        'remainingBalanceText': 'Verbleibender Saldo',
        'categoryBudgetShare': 'Budgetanteil: {percentage}%',
        '@categoryBudgetShare': {
            'placeholders': {
                'percentage': {'type': 'String'}
            }
        }
    },
    'es': {
        'accountActions': 'Acciones de Cuenta',
        'addIncome': 'Añadir Ingresos',
        'addIncomeDesc': '¿Recibiste dinero inesperado?',
        'enterAmount': 'Ingrese la cantidad',
        'noNoteAttached': 'Sin nota',
        'categoryDistribution': 'Distribución por Categoría',
        'balanceSummary': 'Resumen de Saldo',
        'remainingBalanceText': 'Saldo Restante',
        'categoryBudgetShare': 'Parte del Presupuesto: {percentage}%',
        '@categoryBudgetShare': {
            'placeholders': {
                'percentage': {'type': 'String'}
            }
        }
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
print("Phase 2 Keys injected and flutter gen-l10n ran.")
