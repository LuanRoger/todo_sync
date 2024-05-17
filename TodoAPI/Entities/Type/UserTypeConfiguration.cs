using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TodoAPI.Entities.Models;

namespace TodoAPI.Entities.Type;

public class UserTypeConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.Property(f => f.id)
            .IsRequired();
        builder.HasKey(f => f.id);
        
        builder.Property(f => f.email)
            .HasMaxLength(100)
            .IsRequired();
        
        builder.Property(f => f.displayName)
            .IsRequired(false);
    }
}