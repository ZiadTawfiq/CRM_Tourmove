
namespace CustomerRelationshipManagement.Entities
{
    public class RefreshToken
    {
        public int Id { get; set; }

        public string TokenHash { get; set; } = string.Empty;

        public DateTime ExpiresAt { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime? RevokedAt { get; set; }

        public string? UserId { get; set; }
        public Employee User { get; set; } = null!;
        public bool IsActive => RevokedAt == null && !IsExpired;
        public bool IsExpired => DateTime.UtcNow >= ExpiresAt;
        public bool IsRevoked => RevokedAt != null;
        public string FamilyId { get; set; } = string.Empty;
        public string ReplaceedByTokenHash { get; set; } = string.Empty;

    }
}
