import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/matter.dart';

class ReportService {
  static Future<Uint8List> generateMatterReportBytes(Matter matter) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final logoImage = await rootBundle.load(
      'assets/images/brand/001-logo-primary.jpg',
    );
    final logo = pw.MemoryImage(logoImage.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'JusticIAdministrativa',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 24,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.Text(
                        'Reporte de Asunto Legal',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Image(logo, width: 50, height: 50),
                ],
              ),
              pw.SizedBox(height: 40),

              // Matter Details
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildRow(
                      'Expediente:',
                      matter.referenceCode,
                      font,
                      fontBold,
                    ),
                    pw.SizedBox(height: 10),
                    _buildRow('Título:', matter.title, font, fontBold),
                    pw.SizedBox(height: 10),
                    _buildRow(
                      'Tipo:',
                      matter.matterType.displayName,
                      font,
                      fontBold,
                    ),
                    pw.SizedBox(height: 10),
                    _buildRow(
                      'Estado:',
                      matter.status.displayName,
                      font,
                      fontBold,
                    ),
                    pw.SizedBox(height: 10),
                    _buildRow(
                      'Última Actualización:',
                      DateFormat('dd/MM/yyyy').format(matter.lastUpdate),
                      font,
                      fontBold,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),

              // Summary Section
              pw.Text(
                'Resumen del Caso',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 18,
                  color: PdfColors.blue900,
                ),
              ),
              pw.Divider(color: PdfColors.blue900),
              pw.SizedBox(height: 10),
              pw.Text(
                'Este documento certifica el estado actual del asunto gestionado por la firma. Para más detalles, consulte el portal en línea o contacte a su abogado asignado.',
                style: pw.TextStyle(font: font, fontSize: 12, lineSpacing: 5),
              ),

              pw.Spacer(),

              // Footer
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generado el: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Text(
                    'justiciadministrativa.com',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Legacy method for direct print if needed, but we prefer bytes for preview
  static Future<void> generateMatterReport(Matter matter) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async =>
          generateMatterReportBytes(matter),
      name: 'Reporte_${matter.referenceCode}.pdf',
    );
  }

  static pw.Widget _buildRow(
    String label,
    String value,
    pw.Font font,
    pw.Font bold,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(label, style: pw.TextStyle(font: bold, fontSize: 12)),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(font: font, fontSize: 12)),
        ),
      ],
    );
  }
}
