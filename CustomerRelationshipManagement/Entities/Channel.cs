namespace CustomerRelationshipManagement.Entities
{
    public class Channel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<Lead> Leads { get; set; } = new List<Lead>();
    }
}
