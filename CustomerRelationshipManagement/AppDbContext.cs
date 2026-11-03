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

          
            modelBuilder.Entity<LeadGroup>()
                .HasOne(lg => lg.Lead)
                .WithMany(l => l.LeadGroups)
                .HasForeignKey(lg => lg.LeadId);
            modelBuilder.Entity<LeadGroup>()
                .HasOne(lg => lg.Group)
                .WithMany(g => g.LeadGroups)
                .HasForeignKey(lg => lg.GroupId);


            modelBuilder.Entity<Group>()
                .HasMany(g => g.Projects)
                .WithOne(p => p.Group)
                .HasForeignKey(p => p.GroupId);

            modelBuilder.Entity<ProjectLead>()
                .HasKey(pl => new { pl.ProjectId, pl.LeadId });
            modelBuilder.Entity<ProjectLead>()
                .HasOne(pl => pl.Project)
                .WithMany(p => p.ProjectLeads)
                .HasForeignKey(pl => pl.ProjectId);
            modelBuilder.Entity<ProjectLead>()
                .HasOne(pl => pl.Lead)
                .WithMany(l => l.ProjectLeads)
                .HasForeignKey(pl => pl.LeadId); 
                






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
        public DbSet<Group> Groups { get; set; }

    


    }
}
