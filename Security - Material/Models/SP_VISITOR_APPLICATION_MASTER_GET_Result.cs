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
    
    public partial class SP_VISITOR_APPLICATION_MASTER_GET_Result
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string Applicant { get; set; }
        public string ApplicantName { get; set; }
        public string PhoneNumber { get; set; }
        public string HandPhoneNumber { get; set; }
        public string OrgName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectName { get; set; }
        public Nullable<System.Guid> Purpose { get; set; }
        public string PurposeName { get; set; }
        public string LocationOther { get; set; }
        public string Location { get; set; }
        public string Gate { get; set; }
        public int ApplicationType { get; set; }
        public string ApplicationTypeName { get; set; }
        public System.DateTime FromDate { get; set; }
        public System.DateTime ToDate { get; set; }
        public Nullable<System.Guid> ApprovalKind { get; set; }
        public string KindName { get; set; }
        public string ApprovalLineJson { get; set; }
        public string ApprovalLine { get; set; }
        public string ApprovalStatusName { get; set; }
        public Nullable<System.Guid> ApprovalStatus { get; set; }
        public string LocationName { get; set; }
        public string GateName { get; set; }
        public string NextApprover { get; set; }
        public string NextApproverName { get; set; }
        public Nullable<System.DateTime> ConfirmDate { get; set; }
        public System.DateTime CreateDate { get; set; }
        public string CreateUid { get; set; }
        public string CreateName { get; set; }
        public Nullable<int> Vendor { get; set; }
        public string CompanyName { get; set; }
        public string ContactPerson { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public string VendorAddress { get; set; }
        public int ISVIEW { get; set; }
    }
}
