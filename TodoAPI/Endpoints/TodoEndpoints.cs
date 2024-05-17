﻿using Microsoft.AspNetCore.Mvc;
using TodoAPI.Controllers;
using TodoAPI.Endpoints.Filters;
using TodoAPI.Endpoints.Models;
using TodoAPI.Models;

namespace TodoAPI.Endpoints;

public static class TodoEndpoints
{
    public static IEndpointRouteBuilder MapTodoEndpoints(this IEndpointRouteBuilder builder)
    {
        builder.MapGet("/{id:int}", GetTodoByIdHandler);
        builder.MapGet("/", GetUserTodosHandler);
        builder.MapPost("/", CreateUserTodoHandler);
        builder.MapDelete("/{id:int}", DeleteUserTodoHandler);

        return builder;
    }

    private async static Task<IResult> CreateUserTodoHandler(HttpContext context,
        [FromBody] CreateTodoRequest body,
        [FromServices] ITodoController controller)
    {
        string userId = FirebaseAuthorizationFilter.ExtractRequestToken(context)!;
        
        int newTodoId = await controller.CreateUserTodo(userId, body);
        
        return Results.Created($"/todos/{newTodoId}", newTodoId);
    }

    private async static Task<IResult> GetUserTodosHandler(HttpContext context,
        [FromQuery] int page,
        [FromQuery] int pageSize,
        [FromServices] ITodoController controller)
    {
        string userId = FirebaseAuthorizationFilter.ExtractRequestToken(context)!;
        
        var todos = await controller.GetUserTodos(userId, page, pageSize);
        
        return Results.Ok(todos);
    }

    private async static Task<IResult> GetTodoByIdHandler(HttpContext context, 
        [FromRoute] int id,
        [FromServices] ITodoController controller)
    {
        string userId = FirebaseAuthorizationFilter.ExtractRequestToken(context)!;
        
        TodoDto? todo = await controller.GetTodoById(id, userId);
        
        return todo is not null ? Results.Ok(todo) : Results.NotFound();
    }
    
    private async static Task<IResult> DeleteUserTodoHandler(HttpContext context,
        [FromRoute] int id,
        [FromServices] ITodoController controller)
    {
        string userId = FirebaseAuthorizationFilter.ExtractRequestToken(context)!;

        int? deletedTodoId = await controller.DeleteUserTodo(userId, id);
        
        return deletedTodoId is not null ? Results.Ok(deletedTodoId) : Results.NotFound();
    }
}