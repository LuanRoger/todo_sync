namespace TodoAPI.Endpoints.Models;

public class CreateTodoRequest
{
    public required string description { get; init; }
    public required DateTime createdAt { get; init; }
}