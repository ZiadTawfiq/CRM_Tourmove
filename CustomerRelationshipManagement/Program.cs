using CustomerRelationshipManagement;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.LeadDuplicationHandler;
using CustomerRelationshipManagement.LeadStatusHandler;
using CustomerRelationshipManagement.Repositories;
using CustomerRelationshipManagement.Sevices;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add Controllers with enum string conversion
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
});

builder.Services.AddOpenApi();
builder.Services.AddEndpointsApiExplorer();

// CORS for Flutter and Frontend
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// DbContext configuration (uses connection string or in-memory fallback for local dev)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (!string.IsNullOrEmpty(connectionString))
{
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(connectionString));
}
else
{
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseInMemoryDatabase("CrmLocalDb"));
}

// Handlers Registration
builder.Services.AddScoped<ILeadStatusHandler, CancellationStatusHandler>();
builder.Services.AddScoped<ILeadStatusHandler, ReservationStatusHandler>();
builder.Services.AddScoped<ILeadStatusHandler, OrientationStatusHandler>();
builder.Services.AddScoped<ILeadStatusHandler, FollowUpStatusHandler>();
builder.Services.AddScoped<ILeadDuplicationHandler, ReassignLeadHandler>();
builder.Services.AddScoped<ILeadDuplicationHandler, CreateNewleadHandelr>();

// Repositories Registration
builder.Services.AddScoped<ILeadRepository, LeadRepository>();
builder.Services.AddScoped<IleadDuplicateRepository, LeadDuplicateRepository>();
builder.Services.AddScoped<IEmployeeRepository, EmployeeRepository>();
builder.Services.AddScoped<IProjectRepository, ProjectRepository>();
builder.Services.AddScoped<IChannelRepository, ChannelRepository>();
builder.Services.AddScoped<ICommentRepository, CommentRepository>();
builder.Services.AddScoped<IGroupRepository, GroupRepository>();
builder.Services.AddScoped<IOwnerRepository, OwnerRepository>();

// Services Registration
builder.Services.AddScoped<ILeadService, LeadService>();
builder.Services.AddScoped<IleadDuplicateService, LeadDuplicateService>();
builder.Services.AddScoped<IEmployeeService, EmployeeService>();
builder.Services.AddScoped<IProjectService, ProjectService>();
builder.Services.AddScoped<IChannelService, ChannelService>();
builder.Services.AddScoped<ICommentService, CommentService>();
builder.Services.AddScoped<IGroupService, GroupService>();
builder.Services.AddScoped<IOwnerService, OwnerService>();
builder.Services.AddScoped<IAuthService, TokenService>();

// Configure JWT settings
var jwtSettings = builder.Configuration
    .GetSection("Jwt")
    .Get<JwtSettings>();

if (jwtSettings != null && !string.IsNullOrEmpty(jwtSettings.SecretKey))
{
    builder.Services
        .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            options.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidIssuer = jwtSettings.Issuer,
                ValidateAudience = true,
                ValidAudience = jwtSettings.Audience,
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(
                    Encoding.UTF8.GetBytes(jwtSettings.SecretKey)),
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero
            };
        });
}

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
