namespace CustomerRelationshipManagement.Dtos
{
    public class ResetPasswordDto
    {
        public string OldPassword { get;set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
        public string Token { get; set; }
    
    
    }
        

    
}
