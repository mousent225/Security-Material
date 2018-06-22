using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels.SecurityApplication
{
    public class PassingGoodsMasterModel
    {
        public int Id { get; set; }
        public string IdEncrypt { get; set; }
        public string Code { get; set; }
        public string Applicant { get; set; }
        public string ApplicantName { get; set; }

        public string OrgName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public int DeptId { get; set; }
        public string SectionName { get; set; }
        public DateTime ApplicationDate { get; set; }
        public bool ReImport { get; set; }
        public DateTime? ReImportDate { get; set; }
        public string Reason { get; set; }

        public bool FinishApplication { get; set; }
        public string FinishReason { get; set; }
        public DateTime? FinishDate { get; set; }

        public string ApprovalKind { get; set; }
        public string ApprovalKindName { get; set; }
        public string ApprovalLine { get; set; }
        public string ApprovalLineJson { get; set; }
        public string ApprovalStatus { get; set; }
        public string ApprovalStatusName { get; set; }
        public string NextApprover { get; set; }
        public string NextApproverName { get; set; }
        public DateTime? ConfirmDate { get; set; }

        public string CreateUid { get; set; }
        public string CreateName { get; set; }
        public DateTime CreateDate { get; set; }

        public bool IsView { get; set; }
        public bool IsRecall { get; set; }

        public string ExportUid { get; set; }
        public string ExportName { get; set; }
        public DateTime? ExportDate { get; set; }
        public string ExportGate { get; set; }
    }

    public class PassingGoodsDetailModel
    {
        public int Id { get; set; }

        public int MasterId { get; set; }
        public string Code { get; set; }
        public string Applicant { get; set; }
        public string ApplicantName { get; set; }
        public string OrgName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public int DeptId { get; set; }
        public string SectionName { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public DateTime? ExportDate { get; set; }
        public string ItemName { get; set; }
        public string Serial { get; set; }
        public string Description { get; set; }
        public int Quantity { get; set; }        

        public bool ReImport { get; set; }
        public string ReImportName { get; set; }

        public DateTime? ReImportDate { get; set; }
        public string ImportUid { get; set; }
        public string ImportName { get; set; }
        public string ImportGate { get; set; }

        public bool? IsAttachment { get; set; }        
        public string ItemLocation { get; set; }

        public DateTime? PassDate { get; set; }
        public DateTime? ImportDate { get; set; }
        public string Remark { get; set; }
        public string SecurityName { get; set; }
        public string Gate { get; set; }
        public string GateName { get; set; }

        public bool IsView { get; set; }
    }
}