import '../../../Model/SuccessModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class PostTripRepository {
  Future<SuccessModel?> postTrip(Map<String, dynamic> data);
}

class PostTripImpl implements PostTripRepository {
  final RemoteDataSource remoteDataSource;

  PostTripImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postTrip(Map<String, dynamic> data) async {
    return await remoteDataSource.postTrip(data);
  }


}
