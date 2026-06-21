class PortalStats {
  final int activeMatters;
  final int totalDocuments;
  final int upcomingEvents;
  final int pendingInvoices;

  const PortalStats({
    required this.activeMatters,
    required this.totalDocuments,
    required this.upcomingEvents,
    required this.pendingInvoices,
  });

  factory PortalStats.fromJson(Map<String, dynamic> json) {
    return PortalStats(
      activeMatters: (json['active_matters'] as num?)?.toInt() ?? 0,
      totalDocuments: (json['total_documents'] as num?)?.toInt() ?? 0,
      upcomingEvents: (json['upcoming_events'] as num?)?.toInt() ?? 0,
      pendingInvoices: (json['pending_invoices'] as num?)?.toInt() ?? 0,
    );
  }
}
