using Microsoft.EntityFrameworkCore;
using TodoAPI.Entities.Models;
using TodoAPI.Entities.Type;

namespace TodoAPI.Context;

public class AppDbContext(DbContextOptions options) : DbContext(options)
{
    public DbSet<Todo> todos { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        new TodoTypeConfiguration().Configure(modelBuilder.Entity<Todo>());
    }
}