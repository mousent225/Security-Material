using Security___Material.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels
{
    public class DeptModel
    {
        public string Id { get; set; }
        public string Code { get; set; }
        public string EnName { get; set; }
        public bool DelFlag { get; set; }
        public int Parent { get; set; }
        public string DeptCode { get; set; }
        private IEnumerable<DeptModel> _children;
        public bool HasChildren { get; set; }
        public IEnumerable<DeptModel> Children
        {
            get
            {
                if (!HasChildren) return null;
                using (var db = new PortalEntities())
                {
                    var list = (from u in db.HrDeptMaster
                                where u.Parent.ToString() == Id && u.IsDelete == false
                                orderby u.Code
                                select new DeptModel
                                {
                                    Id = u.Id.ToString(),
                                    EnName = u.EnName,
                                    DeptCode = u.Code,
                                    HasChildren = db.HrDeptMaster.Any(c => c.Parent == u.Id)
                                }).ToList();
                    foreach (var item in list)
                    {
                        item.EnName = "[" + item.DeptCode + "] " + item.EnName;
                    }
                    return list.OrderBy(c => c.Code).ToList();
                }
            }
            set { _children = value; }
        }
    }
    public class DepartmentModel
    {
        public string OrganizeName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectionName { get; set; }
        public int id { get; set; }
        public int? parentid { get; set; }
        public string Name { get; set; }
        public string ParentName { get; set; }
        public string KoName { get; set; }
        public string MailGroup { get; set; }
    }
}