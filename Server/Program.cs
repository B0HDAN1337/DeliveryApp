using Server.Data;
using Microsoft.EntityFrameworkCore;
using Server.Repository;
using Server.Service;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<DeliveryDbContext>(options =>
options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// Repository
builder.Services.AddScoped<IRouteRepository, RouteRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();

// Services
builder.Services.AddScoped<IRouteService, RouteService>();
builder.Services.AddScoped<IUserService, UserService>();

// Controllers
builder.Services.AddControllers();

// HttpContextAccessor
builder.Services.AddHttpContextAccessor();

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Json Web Token authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = "DeliveryApp",
        ValidAudience = "DeliveryApp",
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("keyGenerationTokenForUserIdentification"))
    };
});

// Cors
builder.WebHost.UseUrls("http://0.0.0.0:8080");

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
    builder => builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();


using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<DeliveryDbContext>();
        DbInitializer.Initializer(context);
        Console.WriteLine($"Database initialization Successfully");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Database initialization failed: {ex.Message}");
    }
}

if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapControllers();
app.UseCors("AllowAll");

app.UseAuthentication();
app.UseAuthorization();

app.Run();

