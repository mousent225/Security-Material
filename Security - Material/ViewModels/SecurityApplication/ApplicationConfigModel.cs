using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels.SecurityApplication
{
    public class ApplicationConfigModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }
        public bool Active { get; set; }
        public int? DeptId { get; set; }
        public string DeptName { get; set; }
        public string Description { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreateUid { get; set; }
        public string CreateName { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string UpdateUId { get; set; }
        public DateTime? DeleteDate { get; set; }
        public string ApprovalLineDefault { get; set; }
        public string ApprovalLineName { get; set; }
        public string ApprovalLineJson { get; set; }
        public string DeleteUid { get; set; }
        public Guid? ApprovalKind { get; set; }
        public string KindName { get; set; }
    }
    public class ApplicationConfigTree
    {
        public int id { get; set; }
        public int? parentid { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }
    }
}