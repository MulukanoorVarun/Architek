import 'package:arkitek_app/bloc/add_edit_post/add_edit_post_repository.dart';
import 'package:arkitek_app/bloc/add_edit_post/add_edit_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPostCubit extends Cubit<AddEditPostState> {
  final AddEditPostRepository addEditPostRepository;

  AddEditPostCubit(this.addEditPostRepository) : super(AddEditPostIntially());

  Future<void> addPost(Map<String, dynamic> data) async {
    emit(AddEditPostLoading());
    try {
      final res = await addEditPostRepository.addPost(data);
      if (res != null) {
        emit(AddEditPostLoaded(successModel: res));
      } else {
        emit(AddEditPostError(message: "No data available"));
      }
    } catch (e) {
      emit(AddEditPostError(message: "An error occurred: $e"));
    }
  }

  Future<void> editPost(Map<String, dynamic> data, String id) async {
    emit(AddEditPostLoading());
    try {
      final res = await addEditPostRepository.editPost(data, id);
      if (res != null) {
        emit(AddEditPostLoaded(successModel: res));
      } else {
        emit(AddEditPostError(message: "No data available"));
      }
    } catch (e) {
      emit(AddEditPostError(message: "An error occurred: $e"));
    }
  }
}
