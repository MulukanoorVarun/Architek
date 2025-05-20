import 'package:tripfin/Services/remote_data_source.dart';

import '../../../Model/ExpenseDetailModel.dart';

abstract class GetExpenseDetailRepo {
  Future<ExpenseDetailModel?> getExpensiveDetails(String id);
}

class GetExpenseDetailImpl implements GetExpenseDetailRepo {
  final RemoteDataSource remoteDataSource;
  GetExpenseDetailImpl({required this.remoteDataSource});
  @override
  Future<ExpenseDetailModel?> getExpensiveDetails(id) async {
    return await remoteDataSource.getExpenseDetails(id);
  }
}
