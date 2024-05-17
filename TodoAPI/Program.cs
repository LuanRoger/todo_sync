using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using TodoAPI.Context;
using TodoAPI.Controllers;
using TodoAPI.Endpoints;
using TodoAPI.Endpoints.Filters;
using TodoAPI.Repositories;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

FirebaseApp.Create(new AppOptions
{
    Credential = GoogleCredential.GetApplicationDefault(),
    ProjectId = "fire-auth-server-client"
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<AppDbContext>(optionsBuilder =>
{
    optionsBuilder.UseSqlite("Data Source=./database.db;");
});

builder.Services.AddScoped<ITodoRepository, TodoRepository>();
builder.Services.AddScoped<ITodoController, TodoController>();

WebApplication app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

using (IServiceScope scope = app.Services.CreateScope())
{
    AppDbContext db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated();
}

app.UseHttpsRedirection();

RouteGroupBuilder todoGroup = app.MapGroup("todos")
    .AddEndpointFilter<FirebaseAuthorizationFilter>();
todoGroup.MapTodoEndpoints();

app.Run();