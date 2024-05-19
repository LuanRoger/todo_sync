class CreateTodoRequest {
  String description;
  DateTime createdAt;

  CreateTodoRequest({
    required this.description,
    required this.createdAt,
  });
}
