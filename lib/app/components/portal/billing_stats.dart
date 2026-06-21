import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/invoice.dart';

class BillingStats extends StatelessWidget {
  final List<Invoice> invoices;

  const BillingStats({super.key, required this.invoices});

  @override
  Widget build(BuildContext context) {
    final paidTotal = invoices
        .where((i) => i.status == InvoiceStatus.pagada)
        .fold(0.0, (sum, i) => sum + i.amount);
    final pendingTotal = invoices
        .where((i) => i.status == InvoiceStatus.pendiente)
        .fold(0.0, (sum, i) => sum + i.amount);
    final total = paidTotal + pendingTotal;

    if (total == 0) return const SizedBox.shrink();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF15803D),
                    value: paidTotal,
                    title: '${((paidTotal / total) * 100).toStringAsFixed(0)}%',
                    radius: 20,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFB45309),
                    value: pendingTotal,
                    title:
                        '${((pendingTotal / total) * 100).toStringAsFixed(0)}%',
                    radius: 20,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  color: const Color(0xFF15803D),
                  label: "Pagado",
                  amount: NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(paidTotal),
                ),
                const SizedBox(height: 16),
                _buildLegendItem(
                  color: const Color(0xFFB45309),
                  label: "Pendiente",
                  amount: NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 2,
                  ).format(pendingTotal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              amount,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
