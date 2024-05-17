using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TodoAPI.Entities.Models;

namespace TodoAPI.Entities.Type;

public class TodoTypeConfiguration : IEntityTypeConfiguration<Todo>
{
    public void Configure(EntityTypeBuilder<Todo> builder)
    {
        builder.Property(f => f.id)
            .ValueGeneratedOnAdd();
        builder.HasKey(f => f.id);
        
        builder.Property(f => f.description)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(f => f.done)
            .HasDefaultValue(false)
            .IsRequired();

        builder.HasOne<User>(f => f.user)
            .WithMany()
            .HasForeignKey(f => f.userId)
            .IsRequired();
        
        builder.Property(f => f.createdAt)
            .HasDefaultValueSql("GETDATE()")
            .IsRequired();
    }
}