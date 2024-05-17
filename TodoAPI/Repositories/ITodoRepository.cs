using TodoAPI.Entities.Models;

namespace TodoAPI.Repositories;

public interface ITodoRepository
{
    public Task<Todo?> GetTodoById(int id);
    public Task<Todo?> CreateTodo(Todo todo);
    public Task<IReadOnlyCollection<Todo>> GetUserTodos(string userId, int page, int pageSize);
    public bool DeleteTodoById(Todo toDelete);
    public Task<int> FlushChanges();
}