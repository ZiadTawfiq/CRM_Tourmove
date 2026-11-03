using Microsoft.AspNetCore.Identity;
using System.Text.Json.Serialization;

namespace CustomerRelationshipManagement.Entities
{
    public class Employee : IdentityUser
    {
        public string Name { get; set; }
        public List<Lead> Leads { get; set; } = new List<Lead>();
        public List<Owner> Owners { get; set; } = new List<Owner>();
        public List<Project> Projects { get; set; } = new List<Project>();
    }
}
