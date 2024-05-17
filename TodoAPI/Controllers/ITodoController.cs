using TodoAPI.Endpoints.Models;
using TodoAPI.Models;

namespace TodoAPI.Controllers;

public interface ITodoController
{
    public Task<TodoDto?> GetTodoById(int todoId, string userId);
    public Task<ICollection<TodoDto>> GetUserTodos(string userId, int page, int pageSize);
    public Task<int> CreateUserTodo(string userId, CreateTodoRequest todoRequest);
    public Task<int?> DeleteUserTodo(string userId, int todoId);
}