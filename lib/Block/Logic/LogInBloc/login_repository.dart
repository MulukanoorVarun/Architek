import 'package:tripfin/Model/LoginResponseModel.dart';

import '../../../remote_data_source.dart';

abstract class LoginRepository {
  Future<Login_ResponseModel?> postLogin(Map<String, dynamic> data);
}

class LoginImpl implements LoginRepository {
  final RemoteDataSource remoteDataSource;

  LoginImpl({required this.remoteDataSource});

  @override
  Future<Login_ResponseModel?> postLogin(Map<String, dynamic> data) async {
    return await remoteDataSource.loginApi(data);
  }
}
