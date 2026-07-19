import json
import os

langs = {
    'en': {
        'goalCurrentGoal': 'Current Goal',
        'goalTotalSavings': 'Total Savings (In Vault)',
        'goalThisMonthTask': "This Month's Task (Protected)",
        'goalRemainingNet': 'Remaining Goal (Net)',
        'goalIfProtected': 'If Protected This Month',
        'goalUpdateBtn': 'Update',
        'goalAddBtn': 'Add',
        'goalBalanceAction': 'Balance Action',
        'goalWithdrawMoney': 'Withdraw',
        'goalEnterAmountHint': 'Enter amount (e.g. 500)',
        'goalWithdrawBtn': 'Withdraw',
        'goalSpendingPower': 'Spending Power',
        'goalDailyLimit': 'Daily Limit',
        'goalOnTarget': 'On Daily Target',
        'goalLimitExceeded': 'Limit Exceeded',
        'goalEditPlan': 'Edit Financial Plan',
        'goalDistributable': 'Distributable',
        'goalMonthlyTarget': 'Monthly Target',
        'goalDaily': 'Daily',
        'goalResetTitle': 'Reset Goal?',
        'goalResetDesc': "Are you sure you want to reset your current goal and everything you've saved? This action cannot be undone.",
        'goalCancelBtn': 'Cancel',
        'goalResetSuccessMsg': 'Goal and savings reset.',
        'goalResetBtn': 'Reset'
    },
    'tr': {
        'goalCurrentGoal': 'Şu anki Hedef',
        'goalTotalSavings': 'Toplam Birikim (Kasadaki)',
        'goalThisMonthTask': 'Bu Ayki Görev (Korunan)',
        'goalRemainingNet': 'Kalan Hedef (Net)',
        'goalIfProtected': 'Bu Ay Korunursa',
        'goalUpdateBtn': 'Güncelle',
        'goalAddBtn': 'Ekle',
        'goalBalanceAction': 'Bakiye İşlemi',
        'goalWithdrawMoney': 'Para Çek',
        'goalEnterAmountHint': 'Miktar girin (örn. 500)',
        'goalWithdrawBtn': 'Çek',
        'goalSpendingPower': 'Harcama Gücü',
        'goalDailyLimit': 'Günlük Limit',
        'goalOnTarget': 'Günlük Hedefte',
        'goalLimitExceeded': 'Limit Aşıldı',
        'goalEditPlan': 'Finansal Planı Düzenle',
        'goalDistributable': 'Harcanabilir',
        'goalMonthlyTarget': 'Aylık Hedef',
        'goalDaily': 'Günlük',
        'goalResetTitle': 'Hedefi Sıfırla?',
        'goalResetDesc': 'Mevcut hedefinizi ve biriktirdiğiniz tüm tutarı sıfırlamak istediğinize emin misiniz? Bu işlem geri alınamaz.',
        'goalCancelBtn': 'İptal',
        'goalResetSuccessMsg': 'Hedef ve birikimler sıfırlandı.',
        'goalResetBtn': 'Sıfırla'
    },
    'fr': {
        'goalCurrentGoal': 'Objectif Actuel',
        'goalTotalSavings': 'Économies Totales (En Coffre)',
        'goalThisMonthTask': 'Tâche du Mois (Protégée)',
        'goalRemainingNet': 'Objectif Restant (Net)',
        'goalIfProtected': 'Si Protégé Ce Mois-ci',
        'goalUpdateBtn': 'Mettre à jour',
        'goalAddBtn': 'Ajouter',
        'goalBalanceAction': 'Action de Solde',
        'goalWithdrawMoney': 'Retirer',
        'goalEnterAmountHint': 'Entrez le montant (ex. 500)',
        'goalWithdrawBtn': 'Retirer',
        'goalSpendingPower': 'Pouvoir d\'Achat',
        'goalDailyLimit': 'Limite Quotidienne',
        'goalOnTarget': 'Objectif Quotidien Atteint',
        'goalLimitExceeded': 'Limite Dépassée',
        'goalEditPlan': 'Modifier le Plan Financier',
        'goalDistributable': 'Distribuable',
        'goalMonthlyTarget': 'Objectif Mensuel',
        'goalDaily': 'Quotidien',
        'goalResetTitle': 'Réinitialiser l\'Objectif ?',
        'goalResetDesc': 'Êtes-vous sûr de vouloir réinitialiser votre objectif actuel et tout ce que vous avez économisé ? Cette action ne peut être annulée.',
        'goalCancelBtn': 'Annuler',
        'goalResetSuccessMsg': 'Objectif et économies réinitialisés.',
        'goalResetBtn': 'Réinitialiser'
    },
    'de': {
        'goalCurrentGoal': 'Aktuelles Ziel',
        'goalTotalSavings': 'Gesamtersparnisse (Im Tresor)',
        'goalThisMonthTask': 'Aufgabe dieses Monats (Geschützt)',
        'goalRemainingNet': 'Verbleibendes Ziel (Netto)',
        'goalIfProtected': 'Wenn in diesem Monat geschützt',
        'goalUpdateBtn': 'Aktualisieren',
        'goalAddBtn': 'Hinzufügen',
        'goalBalanceAction': 'Kontobewegung',
        'goalWithdrawMoney': 'Abheben',
        'goalEnterAmountHint': 'Betrag eingeben (z. B. 500)',
        'goalWithdrawBtn': 'Abheben',
        'goalSpendingPower': 'Kaufkraft',
        'goalDailyLimit': 'Tageslimit',
        'goalOnTarget': 'Im Tagesziel',
        'goalLimitExceeded': 'Limit überschritten',
        'goalEditPlan': 'Finanzplan bearbeiten',
        'goalDistributable': 'Verteilbar',
        'goalMonthlyTarget': 'Monatsziel',
        'goalDaily': 'Täglich',
        'goalResetTitle': 'Ziel zurücksetzen?',
        'goalResetDesc': 'Möchten Sie Ihr aktuelles Ziel und alle Ersparnisse wirklich zurücksetzen? Diese Aktion kann nicht rückgängig gemacht werden.',
        'goalCancelBtn': 'Abbrechen',
        'goalResetSuccessMsg': 'Ziel und Ersparnisse zurückgesetzt.',
        'goalResetBtn': 'Zurücksetzen'
    },
    'es': {
        'goalCurrentGoal': 'Objetivo Actual',
        'goalTotalSavings': 'Ahorros Totales (En Bóveda)',
        'goalThisMonthTask': 'Tarea de Este Mes (Protegida)',
        'goalRemainingNet': 'Objetivo Restante (Neto)',
        'goalIfProtected': 'Si se Protege Este Mes',
        'goalUpdateBtn': 'Actualizar',
        'goalAddBtn': 'Añadir',
        'goalBalanceAction': 'Acción de Saldo',
        'goalWithdrawMoney': 'Retirar',
        'goalEnterAmountHint': 'Introduzca la cantidad (ej. 500)',
        'goalWithdrawBtn': 'Retirar',
        'goalSpendingPower': 'Poder Adquisitivo',
        'goalDailyLimit': 'Límite Diario',
        'goalOnTarget': 'En Objetivo Diario',
        'goalLimitExceeded': 'Límite Superado',
        'goalEditPlan': 'Editar Plan Financiero',
        'goalDistributable': 'Distribuible',
        'goalMonthlyTarget': 'Objetivo Mensual',
        'goalDaily': 'Diario',
        'goalResetTitle': '¿Restablecer Objetivo?',
        'goalResetDesc': '¿Estás seguro de que quieres restablecer tu objetivo actual y todo lo que has ahorrado? Esta acción no se puede deshacer.',
        'goalCancelBtn': 'Cancelar',
        'goalResetSuccessMsg': 'Objetivo y ahorros restablecidos.',
        'goalResetBtn': 'Restablecer'
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
print("Goals localizations injected!")
