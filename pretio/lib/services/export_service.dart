import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:intl/intl.dart';

// PDF Packages
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Excel Package
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

import '../models/transaction.dart';
import '../providers/currency_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class ExportService {
  static Future<void> exportToExcel(
    BuildContext context,
    List<Transaction> transactions,
    CurrencyProvider currencyProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final workbook = excel.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Micro Spend Report';

    // Headers
    sheet.getRangeByName('A1').setText(l10n.time);
    sheet.getRangeByName('B1').setText(l10n.titleLabel);
    sheet.getRangeByName('C1').setText(l10n.categoryName);
    sheet.getRangeByName('D1').setText(l10n.amountLabel);
    sheet.getRangeByName('E1').setText('${l10n.expense}/${l10n.income}');
    sheet.getRangeByName('F1').setText(l10n.emotionalImpact);
    sheet.getRangeByName('G1').setText(l10n.needVsWant);

    // Styling Headers
    final excel.Range headerRange = sheet.getRangeByName('A1:G1');
    headerRange.cellStyle.backColor = '#112117';
    headerRange.cellStyle.fontColor = '#FFFFFF';
    headerRange.cellStyle.bold = true;

    // Data
    int rowIndex = 2;
    for (var t in transactions) {
      if (t.category == 'no_spend') continue;

      final dateStr = DateFormat('yyyy-MM-dd').format(t.date);
      final displayAmount = currencyProvider.convertFromBase(
        t.amount,
        currencyProvider.currency,
      );
      final typeStr = t.type == 'income' ? l10n.income : l10n.expense;

      sheet.getRangeByIndex(rowIndex, 1).setText(dateStr);
      sheet.getRangeByIndex(rowIndex, 2).setText(t.title);
      sheet.getRangeByIndex(rowIndex, 3).setText(t.category);
      sheet.getRangeByIndex(rowIndex, 4).setNumber(displayAmount);
      sheet.getRangeByIndex(rowIndex, 5).setText(typeStr);
      sheet.getRangeByIndex(rowIndex, 6).setText(t.emotion);
      sheet.getRangeByIndex(rowIndex, 7).setText(t.necessity);

      rowIndex++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/pretio_report.xlsx';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    await SharePlus.instance.share(ShareParams(files: [XFile(path)], text: 'Pretio Excel Report'));
  }

  static Future<void> exportToPdf(
    BuildContext context,
    List<Transaction> transactions,
    CurrencyProvider currencyProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final pdf = pw.Document();

    final ttf = await PdfGoogleFonts.robotoRegular();
    final ttfBold = await PdfGoogleFonts.robotoBold();

    pw.MemoryImage? logoImage;
    try {
      final ByteData data = await rootBundle.load(
        'assets/images/icon_1024.png',
      );
      logoImage = pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      debugPrint('Logo not found');
    }

    // Filter out no_spend
    final txns = transactions.where((t) => t.category != 'no_spend').toList();
    txns.sort((a, b) => b.date.compareTo(a.date));

    // Calculate Totals
    double totalExpense = 0;
    double totalIncome = 0;
    for (var t in txns) {
      final displayAmount = currencyProvider.convertFromBase(
        t.amount,
        currencyProvider.currency,
      );
      if (t.type == 'expense') totalExpense += displayAmount;
      if (t.type == 'income') totalIncome += displayAmount;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        footer: (pw.Context ctx) {
          return pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            alignment: pw.Alignment.center,
            decoration: const pw.BoxDecoration(
              color: PdfColors.teal900,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Text(
              'Pretio',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          );
        },
        build: (pw.Context ctx) {
          return [
            // HEADER
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Pretio',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal900,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      l10n.statistics,
                      style: const pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                if (logoImage != null)
                  pw.Container(
                    width: 120,
                    height: 120,
                    child: pw.Image(logoImage),
                  ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),

            // SUMMARY
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      l10n.income,
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      currencyProvider.formatCurrency(
                        totalIncome,
                        currencyProvider.currency,
                      ),
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.green700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      l10n.expense,
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      currencyProvider.formatCurrency(
                        totalExpense,
                        currencyProvider.currency,
                      ),
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.red700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // TABLE
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.time,
                l10n.titleLabel,
                l10n.categoryName,
                l10n.amountLabel,
              ],
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.teal900,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                ),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: txns.map((t) {
                final displayAmount = currencyProvider.convertFromBase(
                  t.amount,
                  currencyProvider.currency,
                );
                return [
                  DateFormat('yyyy-MM-dd').format(t.date),
                  t.title,
                  t.category,
                  currencyProvider.formatCurrency(
                    displayAmount,
                    currencyProvider.currency,
                  ),
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    final List<int> bytes = await pdf.save();
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/pretio_report.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    await SharePlus.instance.share(ShareParams(files: [XFile(path)], text: 'Pretio PDF Report'));
  }
}
