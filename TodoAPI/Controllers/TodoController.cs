using TodoAPI.Endpoints.Models;
using TodoAPI.Entities.Models;
using TodoAPI.Models;
using TodoAPI.Repositories;

namespace TodoAPI.Controllers;

public class TodoController : ITodoController
{
    private readonly ITodoRepository _todoRepository;

    public TodoController(ITodoRepository todoRepository)
    {
        _todoRepository = todoRepository;
    }

    public async Task<TodoDto?> GetTodoById(int todoId, string userId)
    {
        Todo? todo = await _todoRepository.GetTodoById(todoId);
        
        if(todo is null || todo.userId != userId)
        {
            return null;
        }

        TodoDto todoDto = new()
        {
            id = todo.id,
            description = todo.description,
            done = todo.done,
            userId = todo.userId,
            createdAt = todo.createdAt,
        };
        
        return todoDto;
    }
    
    public async Task<ICollection<TodoDto>> GetUserTodos(string userId, int page, int pageSize)
    {
        IReadOnlyCollection<Todo> todos = await _todoRepository.GetUserTodos(userId, page, pageSize);
        
        return todos.Select(todo => new TodoDto
        {
            id = todo.id,
            description = todo.description,
            done = todo.done,
            userId = todo.userId,
            createdAt = todo.createdAt,
        }).ToList();
    }
    
    public async Task<int> CreateUserTodo(string userId, CreateTodoRequest todoRequest)
    {
        Todo todo = new()
        {
            description = todoRequest.description,
            done = false,
            userId = userId,
            createdAt = todoRequest.createdAt,
        };
        
        await _todoRepository.CreateTodo(todo);
        await _todoRepository.FlushChanges();
        
        return todo.id;
    }
    
    public async Task<int?> DeleteUserTodo(string userId, int todoId)
    {
        Todo? todo = await _todoRepository.GetTodoById(todoId);
        
        if(todo is null || todo.userId != userId)
            return null;

        _todoRepository.DeleteTodoById(todo);
        await _todoRepository.FlushChanges();
        
        return todo.id;
    }
}