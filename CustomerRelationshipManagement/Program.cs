using CustomerRelationshipManagement.LeadDuplicationHandler;
using CustomerRelationshipManagement.LeadStatusHandler;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
// serializer to handle enum as string
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
});

// DI
builder.Services.AddScoped<ILeadStatusHandler, CancellationStatusHandler>();
builder.Services.AddScoped<ILeadStatusHandler, ReservationStatusHandler>();
builder.Services.AddScoped<ILeadStatusHandler, OrientationStatusHandler>();
builder.Services.AddScoped<ILeadDuplicationHandler, ReassignLeadHandler>();
builder.Services.AddScoped<ILeadDuplicationHandler, CreateNewleadHandelr>();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
