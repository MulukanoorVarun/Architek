import 'package:tripfin/Model/EditExpenceModel.dart';

import '../../../Services/remote_data_source.dart';

abstract class Editexpenserepository {
  Future<Editexpencemodel?> Editexpense(Map<String, dynamic> data);
}

class EditexpenceImpl implements Editexpenserepository {
  final RemoteDataSource remoteDataSource;

  const EditexpenceImpl({required this.remoteDataSource});

  @override
  Future<Editexpencemodel?> Editexpense(Map<String, dynamic> data) async {
    return await remoteDataSource.EditExpensedata(data);
  }
}
