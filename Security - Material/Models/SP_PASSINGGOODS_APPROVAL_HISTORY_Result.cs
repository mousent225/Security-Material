//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Security___Material.Models
{
    using System;
    
    public partial class SP_PASSINGGOODS_APPROVAL_HISTORY_Result
    {
        public Nullable<int> Id { get; set; }
        public string EmpId { get; set; }
        public string EmpName { get; set; }
        public Nullable<System.Guid> ApprovalType { get; set; }
        public string ApproverTypeName { get; set; }
        public Nullable<bool> IsApprove { get; set; }
        public Nullable<byte> Seq { get; set; }
        public string Comment { get; set; }
        public Nullable<System.DateTime> DateApprove { get; set; }
        public string DateApproveFormat { get; set; }
        public string JobTitle { get; set; }
    }
}