import 'package:smartelearn/features/dashboard/data/models/user_info_model.dart';
import 'package:smartelearn/services/dashboard_services.dart';

abstract class UserRemoteDataSource {
  Future<UserInfoModel> getDashboardData();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DashboardServices dashboardServices;

  UserRemoteDataSourceImpl({DashboardServices? dashboardServices})
      : dashboardServices = dashboardServices ?? DashboardServices();

  @override
  Future<UserInfoModel> getDashboardData() async {
    final response = await dashboardServices.fetchDashboardData();
    return UserInfoModel.fromJson(response);
  }
}
