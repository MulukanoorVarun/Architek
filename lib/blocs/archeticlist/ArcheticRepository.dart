import '../../models/ArchitectModel.dart';
import '../../services/remote_data_source.dart';

abstract class Archeticrepository {
  Future<ArchitectModel?> getArchetic();
}

class GetcategoryImpl implements Archeticrepository {
  final RemoteDataSource remoteDataSource;
  GetcategoryImpl({required this.remoteDataSource});

  Future<ArchitectModel?> getArchetic() async {
    return await remoteDataSource.getArchetic();
  }
}