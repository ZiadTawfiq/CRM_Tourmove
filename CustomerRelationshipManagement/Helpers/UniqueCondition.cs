using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Helpers
{
    public class UniqueCondition
    {
        public static bool IsUniquePhoneNumberViolation(
        DbUpdateException ex)
        {
            return ex.InnerException is Microsoft.Data.SqlClient.SqlException sqlException
                && (sqlException.Number == 2601 ||
                    sqlException.Number == 2627);
        }
    }
}
