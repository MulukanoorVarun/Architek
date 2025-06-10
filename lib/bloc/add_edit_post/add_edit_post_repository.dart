import '../../models/SuccessModel.dart';
import '../../services/remote_data_source.dart';

abstract class AddEditPostRepository {
  Future<SuccessModel?> addPost(Map<String, dynamic> data);
  Future<SuccessModel?> editPost(Map<String, dynamic> data, String id);
  Future<SuccessModel?> deletePost(String id);
}

class AddEditPostRepositoryImpl implements AddEditPostRepository {
  final RemoteDataSource remoteDataSource;
  AddEditPostRepositoryImpl({required this.remoteDataSource});

  Future<SuccessModel?> addPost(Map<String, dynamic> data) async {
    return await remoteDataSource.addPost(data);
  }

  Future<SuccessModel?> editPost(Map<String, dynamic> data, String id) async {
    return await remoteDataSource.editPost(data, id);
  }

  Future<SuccessModel?> deletePost(String id) async {
    return await remoteDataSource.deletePost(id);
  }
}
