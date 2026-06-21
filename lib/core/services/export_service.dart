import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/invoice.dart';

class ExportService {
  Future<void> exportInvoicesToExcel(List<Invoice> invoices) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Facturas'];

    // Header
    sheet.appendRow([
      TextCellValue('Número'),
      TextCellValue('Cliente'),
      TextCellValue('Monto'),
      TextCellValue('Moneda'),
      TextCellValue('Estado'),
      TextCellValue('Fecha Emisión'),
      TextCellValue('Fecha Vencimiento'),
    ]);

    // Data
    for (final invoice in invoices) {
      sheet.appendRow([
        TextCellValue(invoice.invoiceNumber),
        TextCellValue(invoice.clientId),
        DoubleCellValue(invoice.amount),
        TextCellValue(invoice.currency),
        TextCellValue(invoice.status.displayName),
        TextCellValue(DateFormat('yyyy-MM-dd').format(invoice.createdAt)),
        TextCellValue(
          invoice.dueDate != null
              ? DateFormat('yyyy-MM-dd').format(invoice.dueDate!)
              : '',
        ),
      ]);
    }

    // Save and Share
    final fileBytes = excel.save();
    if (fileBytes != null) {
      final xFile = XFile.fromData(
        Uint8List.fromList(fileBytes),
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        name: 'facturas_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx',
      );

      await Share.shareXFiles([xFile], text: 'Reporte de Facturación');
    }
  }

  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }
}
