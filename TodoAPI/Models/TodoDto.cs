namespace TodoAPI.Models;

public class TodoDto
{
    public required int id { get; init; }
    public required string description { get; init; }
    public required bool done { get; init; }
    public required string userId { get; init; }
    public required DateTime createdAt { get; init; }
}