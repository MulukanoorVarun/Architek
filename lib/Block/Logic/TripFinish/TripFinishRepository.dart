import 'package:dio/dio.dart';
import '../../../Model/SuccessModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class TripFinishRepository{
  Future<SuccessModel?> finishtrip(FormData data);
}

class FinishTripImpl implements TripFinishRepository {
  final RemoteDataSource remoteDataSource;

  const FinishTripImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> finishtrip(FormData data) async {
    return await remoteDataSource.finishtrip();
  }
}
