import 'package:arkitek_app/models/project.dart';

class ProjectRepository {
  Future<List<Project>> getUserProjects() async {
    // TODO: Implement API call
    return [];
  }

  Future<Project> getProjectById(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  Future<Project> createProject(Project project) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  Future<Project> updateProject(Project project) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  Future<void> deleteProject(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  Future<List<Project>> filterProjects({required String status}) async {
    // TODO: Implement API call
    return [];
  }
}