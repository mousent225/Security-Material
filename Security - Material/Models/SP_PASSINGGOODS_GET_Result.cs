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
    
    public partial class SP_PASSINGGOODS_GET_Result
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string Applicant { get; set; }
        public string ApplicantName { get; set; }
        public int DeptId { get; set; }
        public string OrgName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectName { get; set; }
        public System.DateTime ApplicationDate { get; set; }
        public Nullable<bool> ReImport { get; set; }
        public Nullable<System.DateTime> ReImportDate { get; set; }
        public string Reason { get; set; }
        public Nullable<bool> FinishApplication { get; set; }
        public string FinishReason { get; set; }
        public Nullable<System.DateTime> FinishDate { get; set; }
        public Nullable<System.Guid> ApprovalKind { get; set; }
        public string KindName { get; set; }
        public string ApprovalLineJson { get; set; }
        public string ApprovalLine { get; set; }
        public string ApprovalStatusName { get; set; }
        public Nullable<System.Guid> ApprovalStatus { get; set; }
        public string NextApprover { get; set; }
        public string NextApproverName { get; set; }
        public System.DateTime CreateDate { get; set; }
        public string CreateUid { get; set; }
        public string CreateName { get; set; }
        public int ISVIEW { get; set; }
        public Nullable<System.DateTime> ExportDate { get; set; }
        public string ExportUid { get; set; }
        public string GateName { get; set; }
        public string ExportName { get; set; }
    }
}
