using System;

namespace SSO_Material.ViewModels.SecurityApplication
{
    public class ViolationModel
    {
        public int Id { get; set; }
        public string IdEncrypt { get; set; }
        public string Code { get; set; }

        public int? VisitorId { get; set; }
        public string VisitorName { get; set; }
        public string IdentityCard { get; set; }
        public string VehicleType { get; set; }
        public string VehicleTypeName { get; set; }
        public string VehiclePlate { get; set; }

        public int VendorId { get; set; }
        public string VendorName { get; set; }

        public string EmpId { get; set; }
        public string EmpName { get; set; }
        public int? DeptId { get; set; }

        public string OrgName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectionName { get; set; }

        public DateTime ViolateDate { get; set; }
        public string ViolateType { get; set; }
        public string ViolationTypeName { get; set; }
        public string ReasonDetail { get; set; }
        public bool IsBlackList { get; set; }

        public string PersonInCharge { get; set; }
        public string PersonInChargeName { get; set; }
        public bool IsAttachment { get; set; }

        //public string ApprovalKind { get; set; }
        //public string ApprovalKindName { get; set; }
        //public string ApprovalLine { get; set; }
        //public string ApprovalLineJson { get; set; }
        //public string ApprovalStatus { get; set; }
        //public string ApprovalStatusName { get; set; }
        //public string NextApprover { get; set; }
        //public string NextApproverName { get; set; }

        //public DateTime? ConfirmDate { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreateUid { get; set; }
        public string CreateName { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string UpdateUId { get; set; }
        public string UpdateName { get; set; }
        public DateTime? DeleteDate { get; set; }
        public string DeleteUid { get; set; }

        public bool IsView { get; set; }
    }
}