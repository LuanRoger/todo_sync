using Microsoft.EntityFrameworkCore;
using TodoAPI.Context;
using TodoAPI.Entities.Models;

namespace TodoAPI.Repositories;

public class TodoRepository : ITodoRepository
{
    private readonly AppDbContext _dbContext;

    public TodoRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
    }
    
    public async Task<Todo?> GetTodoById(int id)
    {
        Todo? todo = await _dbContext.todos.FindAsync(id);
        return todo;
    }
    
    public async Task<Todo?> CreateTodo(Todo todo)
    {
        var newEntity = await _dbContext.todos.AddAsync(todo);
        
        return newEntity.Entity;
    }
    
    public async Task<IReadOnlyCollection<Todo>> GetUserTodos(string userId, int page, int pageSize)
    {
        return await _dbContext.todos
            .AsNoTracking()
            .Where(todo => todo.userId == userId)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public bool DeleteTodoById(Todo toDelete)
    {
        _dbContext.todos.Remove(toDelete);
        
        return true;
    }

    public Task<int> FlushChanges() => _dbContext.SaveChangesAsync();
}