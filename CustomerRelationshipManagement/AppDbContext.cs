using CustomerRelationshipManagement.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;

namespace CustomerRelationshipManagement
{
    public class AppDbContext : IdentityDbContext<Employee>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Lead>()
                .HasIndex(l => new 
                {
                    l.PhoneNumber,
                   
                })
                .IsUnique();

            modelBuilder.ApplyConfigurationsFromAssembly(
                typeof(AppDbContext).Assembly);
        }
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Channel> Channels { get; set; }
        public DbSet<Comment> Comments {  get; set; }
        public DbSet<Project> Projects { get; set; }
        public DbSet<Owner> Owners { get; set; }
        public DbSet<Lead> Leads { get; set; }
        public DbSet<LeadHistory> LeadHistories { get; set; }

    


    }
}
