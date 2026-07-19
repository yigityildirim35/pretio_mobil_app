// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora de Costo de Tiempo';

  @override
  String get balance => 'Saldo';

  @override
  String get dashboard => 'Panel';

  @override
  String get calendar => 'Calendario';

  @override
  String get reports => 'Informes';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get analytics => 'Análisis';

  @override
  String get coach => 'Entrenador';

  @override
  String get shadow => 'Sombra';

  @override
  String get time => 'Tiempo';

  @override
  String get profile => 'Perfil';

  @override
  String get setDailyGoal => 'Establecer Meta Diaria';

  @override
  String get addQuickAmount => 'Añadir Cantidad Rápida';

  @override
  String get needs => 'Necesidades';

  @override
  String get wants => 'Deseos';

  @override
  String get total => 'Total';

  @override
  String get currentStreak => 'Racha Actual';

  @override
  String get longestStreak => 'Racha más larga';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Añadir';

  @override
  String get delete => 'Eliminar';

  @override
  String editAmount(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Editar Cantidad $amountString';
  }

  @override
  String get deleteAmountConfirmation =>
      '¿Quieres eliminar esta cantidad rápida?';

  @override
  String get manage => 'Gestionar';

  @override
  String get done => 'Hecho';

  @override
  String get addTransaction => 'Añadir transacción';

  @override
  String get whatDidYouBuy => '¿Qué compraste?';

  @override
  String get howDoYouFeel => '¿Cómo te sientes al respecto?';

  @override
  String get isThisNeedOrWant => '¿Es esto una Necesidad, Deseo o Obligación?';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get recentActivity => 'Actividad Reciente';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get noRecentActivity => 'No hay actividad reciente';

  @override
  String get newCategory => 'Nueva Categoría';

  @override
  String get categoryName => 'Nombre de la Categoría';

  @override
  String get selectIcon => 'Seleccionar Icono';

  @override
  String get selectColor => 'Seleccionar Color';

  @override
  String get create => 'Crear';

  @override
  String get shadowBudget => 'Presupuesto en Sombra';

  @override
  String get item => 'Artículo';

  @override
  String get price => 'Precio';

  @override
  String get howDidItFeel => '¿Cómo se sintió no comprarlo?';

  @override
  String get proud => 'Orgulloso';

  @override
  String get relieved => 'Aliviado';

  @override
  String get sad => 'Triste';

  @override
  String get iDidntBuyIt => '¡No lo compré!';

  @override
  String totalSaved(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Total Ahorrado: $amountString';
  }

  @override
  String get examples => 'EJEMPLOS';

  @override
  String memberSince(int year) {
    return 'Miembro desde $year';
  }

  @override
  String get financialHealth => 'Salud Financiera';

  @override
  String get excellent => 'Excelente';

  @override
  String get personalInformation => 'Información Personal';

  @override
  String get annualSalary => 'Salario Anual';

  @override
  String get weeklyHours => 'Horas Semanales';

  @override
  String get appPreferences => 'Preferencias de la aplicación';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get security => 'Seguridad';

  @override
  String get faceIdLogin => 'Inicio de Sesión FaceID';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get timeValue => 'Valor del Tiempo';

  @override
  String get yourProfileShared => 'TU PERFIL (Compartido)';

  @override
  String get monthlySalary => 'Salario Mensual';

  @override
  String get recalculateRate => 'Recalcular Tarifa';

  @override
  String get yourTimeIsWorth => 'Tu tiempo vale';

  @override
  String get tlPhr => '/hr';

  @override
  String get howMuchLife => '¿CUÁNTA VIDA CUESTA?';

  @override
  String get trends => 'Tendencias';

  @override
  String get noTransactionsYet => 'Aún no hay transacciones.';

  @override
  String get good => 'Bien';

  @override
  String get okay => 'Regular';

  @override
  String get regret => 'Arrepentimiento';

  @override
  String get overBudget => 'Presupuesto excedido';

  @override
  String get onTrack => 'En Camino';

  @override
  String get monthlyAvg => 'PROM. MENSUAL';

  @override
  String get day => 'Día';

  @override
  String get perDay => '/ día';

  @override
  String days(int count) {
    return '$count Días';
  }

  @override
  String get financialCoach => 'Coach Financiero';

  @override
  String get moodVsMoney => 'Estado de ánimo-Dinero';

  @override
  String get needVsWant => 'Necesidad-Deseo';

  @override
  String deleteCategoryTitle(String category) {
    return '¿Eliminar \"$category\"?';
  }

  @override
  String get deleteCategoryContent =>
      'Esto solo eliminará la categoría de tu lista. Las transacciones existentes mantendrán este nombre de categoría.';

  @override
  String get remaining => 'Restante';

  @override
  String goal(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'META: $amountString';
  }

  @override
  String get transactionHistory => 'Historial de transacciones';

  @override
  String get currency => 'Moneda';

  @override
  String get editTransactionTitle => 'Editar Transacción';

  @override
  String get titleLabel => 'Título';

  @override
  String get amountLabel => 'Cantidad';

  @override
  String get favorite => 'Favorito';

  @override
  String get need => 'Necesidad';

  @override
  String get want => 'Deseo';

  @override
  String get necessity => 'Obligación';

  @override
  String get spendingBalance => 'Saldo de Gastos';

  @override
  String get emotionalImpact => 'Impacto Emocional';

  @override
  String get budgetProgress => 'Progreso Presupuesto';

  @override
  String get weeklyLimit => 'Límite Semanal';

  @override
  String get monthlyLimit => 'Límite Mensual';

  @override
  String get underDailyGoal => 'por debajo meta diaria';

  @override
  String get overDailyGoal => 'por encima meta';

  @override
  String get fancyLatte => 'Café con Leche Elegante';

  @override
  String get runningShoes => 'Zapatos de correr';

  @override
  String get flagshipPhone => 'Teléfono insignia';

  @override
  String get sedanCar => 'Coche Sedán';

  @override
  String get catFood => 'Comida';

  @override
  String get catTransport => 'Transporte';

  @override
  String get catShopping => 'Compras';

  @override
  String get catFun => 'Diversión';

  @override
  String get catBills => 'Facturas';

  @override
  String get catOther => 'Otro';

  @override
  String get phone => 'Teléfono';

  @override
  String get undoTransactionQuestion => '¿Quieres deshacer esta transacción?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get addNote => 'Añadir Nota';

  @override
  String get enterNote => 'Escribe la nota aquí...';

  @override
  String get budgetPlanner => 'Planificador';

  @override
  String get pleaseEnterItemAndPrice =>
      'Por favor, introduce el artículo y el precio';

  @override
  String get victorySaved => '¡Victoria Guardada! 🎉';

  @override
  String get editGoal => 'Editar Meta';

  @override
  String get goalName => 'Nombre de la Meta';

  @override
  String get goalAmount => 'Cantidad de la Meta';

  @override
  String get rateUpdated => '¡Tarifa Actualizada! 🚀';

  @override
  String get coffeeShoesEta => 'Café, Zapatos, etc.';

  @override
  String get howMuchWasIt => '¿Cuánto fue?';

  @override
  String get happy => 'Feliz';

  @override
  String get neutral => 'Neutral';

  @override
  String get reclaimed => 'RECUPERADO';

  @override
  String get workHours => 'Horas de Trabajo';

  @override
  String get mountainOfSavings => 'Montaña de Ahorros';

  @override
  String levelX(int level) {
    return 'Nivel $level';
  }

  @override
  String get starting => 'Inicio';

  @override
  String get totalPool => 'Total Pool';

  @override
  String get discretionarySpending => 'Discretionary';

  @override
  String leftToPeak(int percent) {
    return '$percent% hasta la cima';
  }

  @override
  String get recentVictories => 'Victorias Recientes';

  @override
  String get noVictoriesYet => 'Aún no se han registrado victorias.';

  @override
  String savedHours(String hours) {
    return '$hours horas recuperadas';
  }

  @override
  String get edit => 'Editar';

  @override
  String get editVictory => 'Editar Victoria';

  @override
  String get minShort => 'm';

  @override
  String get hrShort => 'h';

  @override
  String get workDay => 'día de trabajo';

  @override
  String get monthShort => 'mes';

  @override
  String get workShort => 'trabajo';

  @override
  String get categories => 'Categorías';

  @override
  String get weekly => 'Semanalmente';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get goals => 'Metas';

  @override
  String get noSpendToast => '¡Gastos registrados hoy!';

  @override
  String get noSpendTitle => 'Sin gastos';

  @override
  String get noSpendNote => 'Hoy no se han hecho gastos';

  @override
  String get deletedData => 'Datos eliminados';

  @override
  String get settingsAndPreferences => 'AJUSTES Y PREFERENCIAS';

  @override
  String get account => 'Cuenta';

  @override
  String get profileNameLabel => 'NOMBRE DE PERFIL';

  @override
  String get avatarLabel => 'AVATAR';

  @override
  String get personalizeCharacter => 'Personaliza tu personaje';

  @override
  String get changeAvatar => 'CAMBIAR AVATAR';

  @override
  String get balanceAndFinance => 'Saldo y Finanzas';

  @override
  String get balanceInfoLabel => 'INFO DE SALDO';

  @override
  String currentBalance(String amount) {
    return 'ACTUAL: $amount';
  }

  @override
  String get currencyLabel => 'MONEDA';

  @override
  String get appearance => 'Apariencia';

  @override
  String get languageSelectionLabel => 'SELECCIÓN DE IDIOMA';

  @override
  String get themesLabel => 'TEMAS';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeForest => 'Verde Bosque';

  @override
  String get themeCottonCandy => 'Algodón de Azúcar';

  @override
  String get themeSunset => 'Atardecer';

  @override
  String get themeProfileDark => 'Azul Noche';

  @override
  String get themeAmoled => 'Oscuro';

  @override
  String get preferences => 'Preferencias';

  @override
  String get hideSpentMoney => 'OCULTAR DINERO GASTADO';

  @override
  String get privacyMode => 'Modo privacidad';

  @override
  String get needWantModule => 'MÓDULO NECESIDAD - DESEO';

  @override
  String get showWhenAddingNew => 'Mostrar al agregar nuevo';

  @override
  String get emotionModule => 'MÓDULO EMOCIÓN';

  @override
  String get view3D => 'VISTA 3D';

  @override
  String get addEmbossEffect => 'Agregar efecto relieve';

  @override
  String get reset => 'Restablecer';

  @override
  String get deleteAll => 'BORRAR TODO';

  @override
  String get deletePermanently => 'Borrar todos los datos';

  @override
  String get buttonDelete => 'BORRAR';

  @override
  String get about => 'Acerca de';

  @override
  String get appPurpose => 'PROPÓSITO DE LA APP';

  @override
  String get whyAreWeHere => '¿Por qué estamos aquí?';

  @override
  String get aboutApp => 'ACERCA DE LA APP';

  @override
  String get versionAndDetails => 'Versión y detalles';

  @override
  String get creators => 'CREADORES';

  @override
  String get whoDevelopedIt => '¿Quién lo desarrolló?';

  @override
  String get selectAvatar => 'Seleccionar Avatar';

  @override
  String get editPhoto => 'Editar Foto';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get highestStreak => 'MEJOR RACHA';

  @override
  String get totalSpending => 'GASTO TOTAL';

  @override
  String get currentStreakLabel => 'RACHA ACTUAL';

  @override
  String get financialIq => 'CI Financiero';

  @override
  String percentNeed(int percent) {
    return '$percent% Neces.';
  }

  @override
  String percentWant(int percent) {
    return '$percent% Deseo';
  }

  @override
  String percentObligation(int percent) {
    return '$percent% Oblig.';
  }

  @override
  String get subscriptions => 'Suscripciones';

  @override
  String get seeAll => 'VER TODO';

  @override
  String get noSubscriptionsYet => 'Aún no tienes suscripciones.';

  @override
  String get badgesAndAchievements => 'Insignias y Logros';

  @override
  String get accountOperations => 'Operaciones';

  @override
  String get addIncome => 'Añadir Ingresos';

  @override
  String get unexpectedMoney => '¿Dinero inesperado?';

  @override
  String get enterAmount => 'Ingrese la cantidad';

  @override
  String get buttonAdd => 'Agregar';

  @override
  String get editTotalBalance => 'Editar Saldo Total';

  @override
  String get resetInitialBalance => 'Restablecer saldo inicial';

  @override
  String get updateBalance => 'Actualizar Saldo';

  @override
  String get buttonUpdate => 'Actualizar';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get deleteWarning =>
      'Todos tus gastos y configuraciones se borrarán permanentemente.';

  @override
  String get yesContinue => 'Sí, Continuar';

  @override
  String get finalConfirmation => 'Confirmación Final';

  @override
  String get pressToClearData => 'Presiona para borrar datos.';

  @override
  String secondsRemaining(int seconds) {
    return '$seconds segundos...';
  }

  @override
  String get deleteNow => 'BORRAR AHORA';

  @override
  String get waiting => 'Esperando...';

  @override
  String get insightsTitle => 'Perspectivas Predictivas';

  @override
  String get goalUnreachable =>
      'Tu tasa de gasto actual impide que ahorres. ¡La meta es inalcanzable!';

  @override
  String goalReachableDesc(int days) {
    return 'A tu tasa de gasto actual, alcanzarás tu meta en aproximadamente $days días.';
  }

  @override
  String budgetEmptyWarning(int days) {
    return 'Advertencia: ¡A esta tasa de gasto, tu presupuesto se agotará en $days días!';
  }

  @override
  String get budgetSafe =>
      'Tu presupuesto está a salvo con la tasa de gasto actual.';

  @override
  String get dailyAverageSavings => 'Ahorro Promedio Diario';

  @override
  String get accountActions => 'Acciones de Cuenta';

  @override
  String get addIncomeDesc => '¿Recibiste dinero inesperado?';

  @override
  String get noNoteAttached => 'Sin nota';

  @override
  String get categoryDistribution => 'Distribución por Categoría';

  @override
  String get balanceSummary => 'Resumen de Saldo';

  @override
  String get remainingBalanceText => 'Saldo Restante';

  @override
  String categoryBudgetShare(String percentage) {
    return 'Parte del Presupuesto: $percentage%';
  }

  @override
  String get spentAmount => 'Gastado';

  @override
  String lastMonthPlus(String diff) {
    return 'Mes pasado: +$diff%';
  }

  @override
  String lastMonthMinus(String diff) {
    return 'Mes pasado: $diff%';
  }

  @override
  String get sameAsLastMonth => 'Igual que el mes pasado';

  @override
  String get newData => 'Nuevos datos';

  @override
  String get obligationWarning =>
      'Este es un gasto obligatorio. No afecta su límite diario, solo se deduce de su saldo principal.';

  @override
  String get tapForDetails => 'Toque para ver detalles';

  @override
  String transactionCount(String count) {
    return '$count Transacciones';
  }

  @override
  String get noRecordsToday => 'No hay registros para este día.';

  @override
  String get goalCurrentGoal => 'Objetivo Actual';

  @override
  String get goalTotalSavings => 'Ahorros Totales (En Bóveda)';

  @override
  String get goalThisMonthTask => 'Tarea de Este Mes (Protegida)';

  @override
  String get goalRemainingNet => 'Objetivo Restante';

  @override
  String get goalIfProtected => 'Si se Protege Este Mes';

  @override
  String get goalUpdateBtn => 'Actualizar';

  @override
  String get goalAddBtn => 'Añadir';

  @override
  String get goalBalanceAction => 'Acción de Saldo';

  @override
  String get goalWithdrawMoney => 'Retirar';

  @override
  String get goalEnterAmountHint => 'Introduzca la cantidad (ej. 500)';

  @override
  String get goalWithdrawBtn => 'Retirar';

  @override
  String get goalSpendingPower => 'Poder Adquisitivo';

  @override
  String get goalDailyLimit => 'Límite Diario';

  @override
  String get goalOnTarget => 'En Objetivo Diario';

  @override
  String get goalLimitExceeded => 'Límite Superado';

  @override
  String get goalEditPlan => 'Editar Plan Financiero';

  @override
  String get goalDistributable => 'Distribuible';

  @override
  String get goalMonthlyTarget => 'Objetivo Mensual';

  @override
  String get goalDaily => 'Diario';

  @override
  String get goalResetTitle => '¿Restablecer Objetivo?';

  @override
  String get goalResetDesc =>
      '¿Estás seguro de que quieres restablecer tu objetivo actual y todo lo que has ahorrado? Esta acción no se puede deshacer.';

  @override
  String get goalCancelBtn => 'Cancelar';

  @override
  String get goalResetSuccessMsg => 'Objetivo y ahorros restablecidos.';

  @override
  String get goalResetBtn => 'Restablecer';

  @override
  String get goalUpdateGoalTitle => 'Actualizar Objetivo';

  @override
  String get goalNameInputLabel => 'Nombre del Artículo';

  @override
  String get goalTargetPrice => 'Precio Objetivo';

  @override
  String get goalSaveBtn => 'Guardar';

  @override
  String get goalUpdateGoalsTitle => 'Actualizar Objetivos';

  @override
  String get goalMonthlySavingsTarget => 'Objetivo de Ahorro Mensual';

  @override
  String get shadowItemHint => 'p. ej. Café, auriculares...';

  @override
  String get badgeKutsalSeriTitle => 'La Racha Sagrada';

  @override
  String get badgeKutsalSeriDesc => 'Número de días consecutivos sin gastar.';

  @override
  String get badgeCuzdanBekcisiTitle => 'Guardián de Billetera';

  @override
  String get badgeCuzdanBekcisiDesc => 'Número total de días sin ningún gasto.';

  @override
  String get badgeDuyguDedektifiTitle => 'Detective Emocional';

  @override
  String get badgeDuyguDedektifiDesc =>
      'Número total de transacciones registradas con una emoción.';

  @override
  String get badgeDuzenUzmaniTitle => 'Experto en Equilibrio';

  @override
  String get badgeDuzenUzmaniDesc =>
      'Número total de transacciones etiquetadas como necesidad, deseo u obligación.';

  @override
  String get badgeVeriKurduTitle => 'Devorador de Datos';

  @override
  String get badgeVeriKurduDesc =>
      'Número total de transacciones de gastos registradas.';

  @override
  String get badgeVazgecisUstasiTitle => 'Maestro del Renunciamiento';

  @override
  String get badgeVazgecisUstasiDesc =>
      'Número total de artículos omitidos y enviados al presupuesto sombra.';

  @override
  String get badgeGallery => 'Galería de Insignias';

  @override
  String get totalProgress => 'Progreso Total';

  @override
  String get totalLevels => 'Niveles Totales';

  @override
  String get maxShort => 'MÁX';

  @override
  String get levelShort => 'NIV';

  @override
  String get streakBadge => '🔥 Insignia de Racha';

  @override
  String get cumulativeBadge => '📈 Insignia Acumulativa';

  @override
  String get maxLevelReached => '¡NIVEL MÁXIMO ALCANZADO!';

  @override
  String get subscriptionManagement => 'Gestión de Suscripciones';

  @override
  String get monthlyTotalLabel => 'Total Mensual';

  @override
  String get expenseDistribution => 'Distribución de Gastos';

  @override
  String get detailsButton => 'Detalles';

  @override
  String get mySubscriptions => 'Mis Suscripciones';

  @override
  String onDate(String date) {
    return 'el $date';
  }

  @override
  String get addNewSubscription => 'Añadir Nueva Suscripción';

  @override
  String get noSubscriptionsAdded => 'Aún no has añadido ninguna suscripción.';

  @override
  String nextLevelTarget(int count) {
    return 'Objetivo para el siguiente nivel:\nNecesitas hacer $count más.';
  }

  @override
  String progressLabel(int current, int total) {
    return '$current / $total progreso';
  }

  @override
  String get monthlyReport => 'Informe Mensual';

  @override
  String get totalSpent => 'TOTAL GASTADO';

  @override
  String comparedToLastMonth(String percentage, String trend) {
    return '%$percentage $trend que el mes pasado';
  }

  @override
  String get trendLess => 'menos';

  @override
  String get trendMore => 'más';

  @override
  String get subscriptionDistribution => 'Distribución de Suscripciones';

  @override
  String get upcomingPayments => 'Próximos Pagos';

  @override
  String get noUpcomingPayments => 'No hay próximos pagos.';

  @override
  String nextPaymentInDays(int days) {
    return 'PRÓXIMO • FALTAN $days DÍAS';
  }

  @override
  String get unknown => 'Desconocido';

  @override
  String daysRemainingText(int days) {
    return 'Faltan $days días';
  }

  @override
  String get editSubscription => 'Editar Suscripción';

  @override
  String get newSubscription => 'Nueva Suscripción';

  @override
  String get serviceIconLabel => 'ICONO DEL SERVICIO';

  @override
  String get serviceNameLabel => 'NOMBRE DEL SERVICIO';

  @override
  String get serviceNameHint => 'Ej: Netflix, Spotify...';

  @override
  String get monthlyFeeLabel => 'TARIFA MENSUAL';

  @override
  String get paymentCycleLabel => 'CICLO DE PAGO';

  @override
  String get wantNeedLabel => 'DESEO / NECESIDAD';

  @override
  String get needItem => 'Necesidad';

  @override
  String get wantItem => 'Deseo';

  @override
  String get necessityItem => 'Obligación';

  @override
  String get moodLabel => 'ESTADO DE ÁNIMO';

  @override
  String get happyItem => 'Feliz';

  @override
  String get neutralItem => 'Neutral';

  @override
  String get regretItem => 'Arrepentido';

  @override
  String get nextPaymentDateLabel => 'PRÓXIMA FECHA DE PAGO';

  @override
  String get dateHint => 'dd.mm.aaaa';

  @override
  String get unnamed => 'Sin nombre';

  @override
  String get notSpecified => 'No especificado';

  @override
  String get saveChanges => 'GUARDAR CAMBIOS';

  @override
  String get saveSubscription => 'GUARDAR SUSCRIPCIÓN';

  @override
  String get deleteSubscription => 'ELIMINAR SUSCRIPCIÓN';

  @override
  String get editMyIcon => 'Editar Mi Icono';

  @override
  String get customIcon => 'Icono Personalizado';

  @override
  String get selectIconTitle => 'Seleccionar Icono';

  @override
  String get uploadIcon => 'SUBIR ICONO';

  @override
  String get popularCategory => 'Popular';

  @override
  String get financeCategory => 'Finanzas';

  @override
  String get educationCategory => 'Educación';

  @override
  String get entertainmentCategory => 'Entretenimiento';

  @override
  String get bankWord => 'Banco';

  @override
  String get insuranceWord => 'Seguro';

  @override
  String get creditCardWord => 'Tarjeta de Crédito';

  @override
  String get creditWord => 'Crédito';

  @override
  String get schoolWord => 'Escuela';

  @override
  String get bookMagazineWord => 'Libro/Revista';

  @override
  String get personalDevWord => 'Desarrollo Personal';

  @override
  String get courseWord => 'Curso';

  @override
  String get gameWord => 'Juego';

  @override
  String get cinemaSeriesWord => 'Cine/Serie';

  @override
  String get musicWord => 'Música';

  @override
  String get eventActivityWord => 'Evento';

  @override
  String get totalUppercase => 'TOTAL';

  @override
  String get spendingsTab => 'Gastos';

  @override
  String get otherCategory => 'Otros';

  @override
  String get autoRenewal => 'Renovación Automática';

  @override
  String get appPurposeHeroTitle => 'Gasto Consciente,\nFuturo Libre.';

  @override
  String get appPurposeHeroDesc =>
      'Pretio transforma tus gastos de simples números en su verdadero impacto en tu vida, ayudándote a reemplazar impulsos momentáneos con decisiones conscientes que te acercan a tus sueños.';

  @override
  String get feature1Title => 'Registro Rápido y Práctico';

  @override
  String get feature1Desc =>
      'Registra tus gastos al instante y sin esfuerzo. En lugar de formularios tediosos, añade tus transacciones en segundos, convirtiendo el control financiero en un hábito diario agradable.';

  @override
  String get feature2Title => 'Brújula Financiera Emocional';

  @override
  String get feature2Desc =>
      'Descubre la psicología detrás de cada gasto. ¿Es una necesidad real o un impulso repentino? Mapea tus hábitos de consumo y destina tu dinero solo a las cosas que te aportan valor.';

  @override
  String get feature3Title => 'Enfócate en Tus Sueños';

  @override
  String get feature3Desc =>
      'Planifica no solo para hoy, sino para el futuro. Mira claramente qué tan cerca estás de tu objetivo y dirige tus ahorros directamente hacia él.';

  @override
  String get feature4Title => 'Análisis Detallado y Seguimiento de Hábitos';

  @override
  String get feature4Desc =>
      'Mira transparentemente a dónde va tu dinero. Descubre tus hábitos de consumo examinando tus tendencias de gasto y distribución emocional en detalle con gráficos elegantes.';

  @override
  String get feature5Title => 'Totalmente Personalizable';

  @override
  String get feature5Desc =>
      'Adapta tu asistente financiero a tu estilo de vida. Crea tus propias categorías, establece montos de ingreso rápido y celebra tus logros con insignias únicas.';

  @override
  String get aboutHeroDesc =>
      'Pretio no es solo un rastreador de presupuesto ordinario; es una filosofía de vida personal que te devuelve el control sobre tu tiempo, dinero y emociones. En medio del frenesí del consumismo, fue diseñado para recordarte tu propia fuerza de voluntad e iluminar el camino hacia tus sueños.';

  @override
  String get aboutSection1Title => 'Significado del Nombre';

  @override
  String get aboutSection1Desc =>
      'Pretio deriva sus raíces de la palabra latina \"pretium\", que significa \"valor\" y \"precio\". Todo lo que compramos en la vida no solo tiene un costo financiero, sino un verdadero precio pagado con nuestro tiempo y emociones. Pretio existe para mostrarte este verdadero valor.';

  @override
  String get aboutSection2Title => 'Su Simplicidad';

  @override
  String get aboutSection2Desc =>
      'No te abruma con tablas financieras complejas, menús confusos y gráficos agotadores. Con su diseño minimalista y agradable a la vista, convierte el seguimiento financiero de una fuente de estrés en una rutina diaria pacífica.';

  @override
  String get aboutSection3Title => 'Su Conciencia';

  @override
  String get aboutSection3Desc =>
      'Te muestra no solo lo que gastas, sino por qué lo gastas. Iluminando tu psicología de consumo, te ayuda a comprender si el artículo que compraste es una necesidad genuina o un capricho momentáneo.';

  @override
  String get aboutSection4Title => 'Su Practicidad';

  @override
  String get aboutSection4Desc =>
      'Sigue perfectamente el ritmo de la vida diaria. Puedes registrar gastos en segundos sin llenar formularios largos y aburridos, actualizar tu presupuesto con un solo toque y resumir tu estado financiero de un vistazo.';

  @override
  String get aboutSection5Title => 'Su Personalización';

  @override
  String get aboutSection5Desc =>
      'El estilo de vida y viaje financiero de cada uno es único. Puedes adaptar completamente Pretio a tus propios hábitos creando tus propias categorías, estableciendo objetivos personalizados y ajustando tus montos de ingreso rápido.';

  @override
  String get aboutFooterNote =>
      'Esta aplicación fue creada por un grupo independiente de desarrolladores para ayudarte a proteger tu fuerza de voluntad frente al consumismo desenfrenado.';

  @override
  String get developersTitle => 'Nuestros Desarrolladores';

  @override
  String get averageSoFar => 'Promedio hasta ahora';

  @override
  String get all => 'Todo';

  @override
  String get favorites => 'Favoritos';

  @override
  String get currentNetBalance => 'Saldo Neto Actual';

  @override
  String get makeTransaction => 'Hacer Transacción';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String insightProjectionGood(String percent) {
    return 'A este ritmo, ahorrarás un $percent% más que tu objetivo al final del mes.';
  }

  @override
  String insightProjectionBad(String percent) {
    return 'A este ritmo, ahorrarás un $percent% menos que tu objetivo al final del mes.';
  }

  @override
  String insightCategoryAlert(String category) {
    return 'Este mes gastaste más en la categoría $category.';
  }

  @override
  String insightStreak(int days) {
    return '¡Genial! No has gastado nada durante $days días.';
  }
}
