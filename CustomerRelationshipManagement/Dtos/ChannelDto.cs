namespace CustomerRelationshipManagement.Dtos
{
    public class ChannelDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int LeadsCount { get; set; }
    }

    public class CreateChannelDto
    {
        public string Name { get; set; } = string.Empty;
    }

    public class UpdateChannelDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }
}
