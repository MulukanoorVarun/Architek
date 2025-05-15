import 'package:tripfin/Model/UpdateProfileModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class UpdateprofileRepository {
  Future<Updateprofilemodel?> Updateprofile(dynamic data);
}

class UpdateProfileImpl implements UpdateprofileRepository {
  final RemoteDataSource remoteDataSource;

  const UpdateProfileImpl({required this.remoteDataSource});

  @override
  Future<Updateprofilemodel?> Updateprofile(dynamic data) async {
    // return await remoteDataSource.UpdateProfile(data);
  }
}
