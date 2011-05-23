using QueryLayer.Utilities;

namespace QueryLayer.Enums
{
    /// <summary>
    /// Defines possible values for the field CoordinateStatus 
    /// </summary>
    public enum CoordinateStatus
    {
        [StringValue("VALID")]
        Valid = 0,
        [StringValue("OUTSIDE")]
        Outside,
        [StringValue("MISSING")]
        Missing
    }
}
