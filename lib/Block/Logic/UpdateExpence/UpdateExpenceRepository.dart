import '../../../Model/SuccessModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class UpdateExpenseRepository {
  Future<SuccessModel?> postExpenseUpdate(Map<String, dynamic> data);
}

class UpdateExpenseImpl implements UpdateExpenseRepository {
  final RemoteDataSource remoteDataSource;

  const UpdateExpenseImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postExpenseUpdate(Map<String, dynamic> data) async {
    return await remoteDataSource.updateExpense(data);
  }
}

