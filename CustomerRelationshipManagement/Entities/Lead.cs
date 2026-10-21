using System.Text.Json.Serialization;

namespace CustomerRelationshipManagement.Entities;

public class Lead
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string PhoneNumber { get; set; } = string.Empty;

    public int ProjectId { get; set; }
    public Project Project { get; set; } = null!;

    public string? EmployeeId { get; set; }
    public Employee? Employee { get; set; }

    public int? ChannelId { get; set; }
    public Channel Channel { get; set; } = null!;

    public decimal? Budget { get; set; }

    public ICollection<Comment> Comments { get; set; }
        = new List<Comment>();

    public Status Status { get; set; } = Status.FreshLead;

    public DateTime Created { get; set; } = DateTime.UtcNow;
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public DateTime Updated { get; set; }
    public TypeLead TypeLead { get; set; }
    public DateTime? Assigned { get; set; }
    public bool IsDublicated { get; set; } = false;
}