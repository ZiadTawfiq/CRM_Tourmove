using CustomerRelationshipManagement.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement
{
    public class AppDbContext : IdentityDbContext<Employee>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Channel> Channels { get; set; }
        public DbSet<Comment> Comments {  get; set; }
        public DbSet<Project> Projects { get; set; }
        public DbSet<Owner> Owners { get; set; }
        public DbSet<Lead> Leads { get; set; }


    }
}
