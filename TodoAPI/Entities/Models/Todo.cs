namespace TodoAPI.Entities.Models;

public class Todo
{
    public int id { get; set; }
    public string description { get; set; }
    public bool done { get; set; }
    public string userId { get; set; }
    public User user { get; set; }
    public DateTime createdAt { get; set; }
}