using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TodoAPI.Entities.Models;

namespace TodoAPI.Entities.Type;

public class TodoTypeConfiguration : IEntityTypeConfiguration<Todo>
{
    public void Configure(EntityTypeBuilder<Todo> builder)
    {
        builder.HasKey(f => f.id);
        builder.HasIndex(f => f.userId);
        
        builder.Property(f => f.id)
            .ValueGeneratedOnAdd();
        
        builder.Property(f => f.description)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(f => f.done)
            .HasDefaultValue(false)
            .IsRequired();

        builder.Property(f => f.userId);
        
        builder.Property(f => f.createdAt)
            .HasDefaultValueSql("GETDATE()")
            .IsRequired();
    }
}