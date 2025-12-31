import '../models/outlet.model.dart';

class OutletsRepository {
  Future<List<OutletModel>> getAvailableOutlets() async {
    // Simulate delay like fetching from server
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      OutletModel(id: '0', label: 'Outlet #0', ip: '192.168.1.10'),
      OutletModel(id: '1', label: 'Outlet #1', ip: '192.168.1.11'),
      OutletModel(id: '2', label: 'Outlet #2', ip: '192.168.1.12'),
    ];
  }
}
