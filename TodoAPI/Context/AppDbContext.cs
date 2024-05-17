using Microsoft.EntityFrameworkCore;
using TodoAPI.Entities.Models;
using TodoAPI.Entities.Type;

namespace TodoAPI.Context;

public class AppDbContext(DbContextOptions options) : DbContext(options)
{
    public DbSet<User> users { get; set; }
    public DbSet<Todo> todos { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        new UserTypeConfiguration().Configure(modelBuilder.Entity<User>());
        new TodoTypeConfiguration().Configure(modelBuilder.Entity<Todo>());
    }
}