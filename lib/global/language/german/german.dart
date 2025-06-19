// import '../../../utils/static_strings/static_strings.dart';

// Map<String, String> german = {
//   ///====================== Initial ========================
//   AppStrings.appName: "GastRonomIQ",
//   AppStrings.appTagLine: "Verfolge Artikel, \nBerechnen, Gemeinsam",
//   AppStrings.getStarted: "Loslegen",
//   AppStrings.welcome: "Willkommen",

//   ///====================== Auth ========================
//   AppStrings.signUp: "Registrieren",
//   AppStrings.signIn: "Anmelden",
//   AppStrings.adminSignUp: "Admin Registrierung",
//   AppStrings.or: "Oder",
//   AppStrings.email: "E-Mail",
//   AppStrings.fullName: "Vollständiger Name",
//   AppStrings.employee: "Mitarbeiter",
//   AppStrings.admin: "Admin",
//   AppStrings.successful: "Erfolgreich",

//   AppStrings.congratulations:
//       "Glückwunsch! Ihr Passwort wurde geändert. Klicken Sie auf Weiter, um sich anzumelden",
//   AppStrings.emailText: 'contact@dscode...com',
//   AppStrings.passwordReset: "Passwort zurücksetzen",
//   AppStrings.enterYourEmailHint: "Geben Sie Ihre E-Mail ein",
//   AppStrings.reEnterPassword: "Passwort erneut eingeben",
//   AppStrings.confirmPasswordHint: "Passwort bestätigen",
//   AppStrings.monthlyReport: "Monatlicher Bericht",
//   AppStrings.updatePassword: "Passwort aktualisieren",
//   AppStrings.resendEmail: "E-Mail erneut senden",
//   AppStrings.setANewPassword: "Neues Passwort festlegen",
//   AppStrings.monthlyGrocerySpending: "Monatliche Ausgaben für Lebensmittel",
//   AppStrings.totalExpenses: "Gesamtausgaben",
//   AppStrings.viewBreakdown: "Aufschlüsselung anzeigen",
//   AppStrings.trackTotalSpent: "Gesamtausgaben verfolgen",
//   AppStrings.totalSpent: "Insgesamt ausgegeben",
//   AppStrings.budgetLimit: "Budgetgrenze",
//   AppStrings.groceryItems: "Lebensmittelartikel",
//   AppStrings.underBudget: "Im Budget",
//   AppStrings.recentPurchases: "Kürzliche Einkäufe",
//   AppStrings.createANewPassword:
//       "Erstellen Sie ein neues Passwort. Stellen Sie sicher, dass es sich von früheren unterscheidet.",
//   AppStrings.enterYourFullName: "Geben Sie Ihren vollständigen Namen ein",
//   AppStrings.enterYourNewPassword: "Geben Sie Ihr neues Passwort ein",
//   AppStrings.weSent: "Wir haben einen Link zum Zurücksetzen an ",
//   AppStrings.checkYourEmail: "Überprüfen Sie Ihre E-Mail",
//   AppStrings.haveNotGotTheMail: "Haben Sie die E-Mail noch nicht erhalten? ",
//   AppStrings.verifyCode: "Code bestätigen",
//   AppStrings.enterYour5Digit:
//       "Geben Sie den 5-stelligen Code aus der E-Mail ein",
//   AppStrings.confirm: "Bestätigen",
//   AppStrings.confirmPassword:
//       "Ihr Passwort wurde erfolgreich zurückgesetzt. Klicken Sie auf Bestätigen, um ein neues Passwort festzulegen",
//   AppStrings.password: "Passwort",
//   AppStrings.passwordHint: "********",
//   AppStrings.passWordMustBeAtLeast:
//       "Das Passwort muss mindestens einen Großbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten",
//   AppStrings.fieldCantNotBeEmpty: "Das Feld darf nicht leer sein",
//   AppStrings.passwordLengthAndContain:
//       "Das Passwort muss mindestens 8 Zeichen lang sein und mindestens einen Großbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten",
//   AppStrings.forgotPassword: "Passwort vergessen?",
//   AppStrings.doYouHaveAnAccount: "Haben Sie ein Konto?",
//   AppStrings.rememberMe: "Angemeldet bleiben",
//   AppStrings.dontHaveAAccount: "Sie haben noch kein Konto? ",

//   ///====================== Subscription ========================
//   AppStrings.subscribe: "Abonnieren",
//   AppStrings.skip: "Überspringen",
//   AppStrings.getUnlimitedAccess:
//       "Erhalten Sie unbegrenzten Zugang zu unseren Programmen.",
//   AppStrings.takeTheFirstStep:
//       "Machen Sie den ersten Schritt zu einem gesünderen und glücklicheren Leben.",
//   AppStrings.popular: "BELIEBT",
//   AppStrings.forMoreScan: "Für mehr Scan",
//   AppStrings.sixtyPointNoneNine: "\$60,99",
//   AppStrings.forOneYear: "Für 1 Jahr",
//   AppStrings.unlimitedAccessTosSan: "Unbegrenzter Zugriff auf Scan",
//   AppStrings.viewMonthlyRecord: "Monatlichen Bericht anzeigen",
//   AppStrings.youWillBe:
//       "Ihnen werden \$9,99 (Monatsplan) oder \n\$60,99 (Jahresplan) über Ihr iTunes-Konto berechnet. Sie können jederzeit kündigen, wenn Sie nicht zufrieden sind.",
//   AppStrings.appleStorePay: "Apple Store Pay",
//   AppStrings.unlockExclusivefeatures:
//       "Exklusive Funktionen freischalten und Ihr Dating-Erlebnis verbessern.",
//   AppStrings.completeYourPurchase: "Kauf abschließen",
//   AppStrings.upgradeFrom: "Upgrade ab \$9,99",
//   AppStrings.paymentMethod: "Zahlungsmethode",
//   AppStrings.paymentMethodHint: "MasterCard 13345***44",
//   AppStrings.payWithApplePayAndGetOffers:
//       "Mit Apple Pay bezahlen und Angebote und Rabatte bei Ihrem nächsten Einkauf erhalten",
//   AppStrings.pay: "Bezahlen",
//   AppStrings.payNow: "Jetzt bezahlen",

//   ///====================== Home ========================
//   AppStrings.yourGroceryExpensesAtAGlance:
//       "Ihre Ausgaben für Lebensmittel auf einen Blick",
//   AppStrings.add: "Hinzufügen",
//   AppStrings.purchaseHistory: "Kaufverlauf",
//   AppStrings.itemsYouveBought: "Artikel, die Sie gekauft haben",
//   AppStrings.viewAll: "Alle anzeigen",

//   ///====================== Scanner ========================
//   AppStrings.scanner: "Scanner",
//   AppStrings.recentScans: "Letzte Scans",
//   AppStrings.edit: "Bearbeiten",
//   AppStrings.save: "Speichern",
//   AppStrings.processed: "Verarbeitet",

//   ///====================== Transaction History ========================
//   AppStrings.transactionHistory: "Transaktionsverlauf",
//   AppStrings.totalSpending: "Gesamtausgaben",
//   AppStrings.export: "Exportieren",
//   AppStrings.download: "Herunterladen",

//   ///====================== Profile ========================
//   AppStrings.profile: "Profil",
//   AppStrings.unlockExclusiveFeatures:
//       "Exklusive Funktionen freischalten und Ihr Dating-Erlebnis verbessern.",
//   AppStrings.manager: "Manager",
//   AppStrings.addedReceipt: "Beleg hinzugefügt",
//   AppStrings.recently: "Kürzlich",
//   AppStrings.total: "Gesamt",

//   ///====================== Report ========================
//   AppStrings.report: "Bericht",
// };
import '../../../utils/static_strings/static_strings.dart';

Map<String, String> german = {
  ///====================== Initial ========================
  AppStrings.appName: "GastRonomIQ",
  AppStrings.appTagLine: "Artikel verfolgen,\nBerechnen, Gemeinsam",
  AppStrings.getStarted: "Start",
  AppStrings.welcome: "Willkommen",

  ///====================== Auth ========================
  AppStrings.signUp: "Registrieren",
  AppStrings.signIn: "Anmelden",
  AppStrings.adminSignUp: "Admin Anmeldung",
  AppStrings.or: "Oder",
  AppStrings.email: "E-Mail",
  AppStrings.fullName: "Name",
  AppStrings.employee: "Mitarbeiter",
  AppStrings.admin: "Admin",
  AppStrings.successful: "Erfolgreich",
  AppStrings.pleaseEnterYourEmailToReset:
      "E-Mail eingeben, um Passwort zurückzusetzen",
  AppStrings.congratulations: "Passwort geändert! Weiter zum Login",
  AppStrings.emailText: 'contact@dscode...com',
  AppStrings.passwordReset: "Passwort zurücksetzen",
  AppStrings.enterYourEmailHint: "E-Mail eingeben",
  AppStrings.reEnterPassword: "Passwort wiederholen",
  AppStrings.confirmPasswordHint: "Passwort bestätigen",
  AppStrings.monthlyReport: "Monatsbericht",
  AppStrings.updatePassword: "Passwort ändern",
  AppStrings.youEmail: "Deine E-Mail",
  AppStrings.resendEmail: "E-Mail erneut senden",
  AppStrings.setANewPassword: "Neues Passwort setzen",
  AppStrings.monthlyGrocerySpending: "Monatliche Ausgaben",
  AppStrings.totalExpenses: "Gesamtausgaben",
  AppStrings.viewBreakdown: "Details ansehen",
  AppStrings.trackTotalSpent: "Ausgaben verfolgen",
  AppStrings.totalSpent: "Gesamt ausgegeben",
  AppStrings.budgetLimit: "Budgetlimit",
  AppStrings.groceryItems: "Lebensmittel",
  AppStrings.underBudget: "Im Budget",
  AppStrings.recentPurchases: "Letzte Einkäufe",
  AppStrings.createANewPassword: "Neues Passwort erstellen (anders als vorher)",
  AppStrings.enterYourFullName: "Vollständigen Namen eingeben",
  AppStrings.enterYourNewPassword: "Neues Passwort eingeben",
  AppStrings.weSent: "Link gesendet an ",
  AppStrings.checkYourEmail: "E-Mail prüfen",
  AppStrings.haveNotGotTheMail: "E-Mail nicht erhalten? ",
  AppStrings.verifyCode: "Code eingeben",
  AppStrings.enterYour5Digit: "5-stelligen Code eingeben",
  AppStrings.confirm: "Bestätigen",
  AppStrings.confirmPassword: "Passwort erfolgreich zurückgesetzt",
  AppStrings.password: "Passwort",
  AppStrings.passwordHint: "********",
  AppStrings.passWordMustBeAtLeast:
      "Passwort braucht Groß-, Kleinbuchstaben und Zahl",
  AppStrings.fieldCantNotBeEmpty: "Feld darf nicht leer sein",
  AppStrings.passwordLengthAndContain:
      "Mind. 8 Zeichen, Groß-/Kleinbuchstabe & Zahl",
  AppStrings.forgotPassword: "Passwort vergessen?",
  AppStrings.doYouHaveAnAccount: "Schon Konto?",
  AppStrings.rememberMe: "Angemeldet bleiben",
  AppStrings.dontHaveAAccount: "Kein Konto? ",

  ///====================== Subscription ========================
  AppStrings.subscribe: "Abonnieren",
  AppStrings.skip: "Überspringen",
  AppStrings.getUnlimitedAccess: "Unbegrenzt Zugang zu Programmen",
  AppStrings.takeTheFirstStep: "Erster Schritt zu gesünderem Leben",
  AppStrings.popular: "BELIEBT",
  AppStrings.forMoreScan: "Mehr Scan",
  AppStrings.sixtyPointNoneNine: "\$60,99",
  AppStrings.forOneYear: "1 Jahr",
  AppStrings.unlimitedAccessTosSan: "Unbegrenzter Scan",
  AppStrings.viewMonthlyRecord: "Monatsbericht ansehen",
  AppStrings.youWillBe:
      "\$9,99 (Monat) oder \$60,99 (Jahr) via iTunes belastet. Kündigen jederzeit.",
  AppStrings.appleStorePay: "Apple Store Pay",
  AppStrings.unlockExclusivefeatures: "Exklusive Funktionen freischalten",
  AppStrings.completeYourPurchase: "Kauf abschließen",
  AppStrings.upgradeNow: 'Jetzt upgraden',
  AppStrings.paymentMethod: "Zahlungsmethode",
  AppStrings.paymentMethodHint: "MasterCard 13345***44",
  AppStrings.payWithApplePayAndGetOffers:
      "Mit Apple Pay bezahlen & Rabatte sichern",
  AppStrings.pay: "Bezahlen",
  AppStrings.payNow: "Jetzt zahlen",

  ///====================== Home ========================
  AppStrings.yourGroceryExpensesAtAGlance: "Lebensmittel-Ausgaben im Blick",
  AppStrings.add: "Hinzufügen",
  AppStrings.purchaseHistory: "Käufe",
  AppStrings.itemsYouveBought: "Gekaufte Artikel",
  AppStrings.viewAll: "Alle",

  ///====================== Scanner ========================
  AppStrings.scanner: "Scanner",
  AppStrings.recentScans: "Letzte Scans",
  AppStrings.edit: "Bearbeiten",
  AppStrings.save: "Speichern",
  AppStrings.processed: "Verarbeitet",

  ///====================== Transaction History ========================
  AppStrings.transactionHistory: "Transaktionen",
  AppStrings.totalSpending: "Gesamtausgaben",
  AppStrings.export: "Export",
  AppStrings.download: "Download",

  ///====================== Profile ========================
  AppStrings.profile: "Profil",
  AppStrings.unlockExclusiveFeatures: "Exklusive Features freischalten",
  AppStrings.manager: "Manager",
  AppStrings.addedReceipt: "Beleg hinzugefügt",
  AppStrings.recently: "Kürzlich",
  AppStrings.total: "Gesamt",

  ///====================== Report ========================
  AppStrings.report: "Bericht",
  AppStrings.cancel: 'Abbrechen',
  AppStrings.takeFirstStep:
      'Mach den ersten Schritt zu einem gesünderen Leben.',
  AppStrings.monthlyPremiumPlan: 'Monatsabo Premium',
  AppStrings.yearlyPremiumPlan: 'Jahresabo Premium',
  AppStrings.moreScan: 'Mehr Scans',
  AppStrings.unlockMonthlyReport: 'Monatsbericht freischalten',
  AppStrings.unlimitedScan: 'Unbegrenzte Scans',
  AppStrings.unlockYearlyReport: 'Jahresbericht freischalten',

  AppStrings.pricingInfo:
      '\$9,99 pro Monat oder \$60,99 pro Jahr (60 % sparen). Bezahlung über PayPal. Jederzeit kündbar.',
  AppStrings.freeTrialFor: "Testversion für",
  AppStrings.sevenDays: "7 Tage",
  AppStrings.reportofMonth: 'Monatsbericht',
  AppStrings.recent: "Kürzlich",
  AppStrings.all: 'Alle',
};
