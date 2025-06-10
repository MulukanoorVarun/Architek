
import '../../models/SuccessModel.dart';
import '../../services/remote_data_source.dart';

abstract class LoginRepository {
  Future<SuccessModel?> loginApi(Map<String,dynamic> data);
}

class LoginRepositoryImpl implements LoginRepository {
  final RemoteDataSource remoteDataSource;
  LoginRepositoryImpl({required this.remoteDataSource});

  Future<SuccessModel?> loginApi(Map<String,dynamic> data) async {
    return await remoteDataSource.registerApi(data);
  }
}