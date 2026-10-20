namespace CustomerRelationshipManagement.Dtos
{
    public class ActionDto
    {
        public string status { get; set; }
        public string? comment { get; set; }
        public int? leadId { get; set; }
        public int? salesRepId { get; set; }

    }
}
