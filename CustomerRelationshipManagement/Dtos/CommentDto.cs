namespace CustomerRelationshipManagement.Dtos
{
    public class CommentDto
    {
        public int Id { get; set; }
        public string Text { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string? EmployeeId { get; set; }
        public string? EmployeeName { get; set; }
        public int LeadId { get; set; }
    }

    public class CreateCommentDto
    {
        public string Text { get; set; } = string.Empty;
        public int LeadId { get; set; }
        public string? EmployeeId { get; set; }
    }

    public class UpdateCommentDto
    {
        public int Id { get; set; }
        public string Text { get; set; } = string.Empty;
    }
}
