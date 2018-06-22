using Security___Material.Models;
using SSO_Material.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories
{
    public class CategoryRepository
    {
        PortalEntities _db = new PortalEntities();
        public IEnumerable<CategoryValueModel> GetListValues(string category, string name, string status)
        {
            var bStatus = false;
            if (status != "")
                bStatus = (status == "1");
            var cate = new Guid(category);
            if (category == null)
                return null;
            try
            {
                var u = (from v in _db.SysCategoryValue
                            from c in _db.SysCategory
                                .Where(c => c.ID == v.Category).DefaultIfEmpty()
                            from p in _db.SysCategoryValue
                                .Where(p => p.ID == v.ParentID).DefaultIfEmpty()
                            where v.Category == cate && v.IsDelete != true && v.Name.Contains(name) && (status == "" || v.Actived == bStatus)
                            orderby v.ParentID, v.Sequence
                            select new CategoryValueModel
                            {
                                ID = v.ID,
                                Name = v.Name,
                                SubCode = v.SubCode ?? "",
                                Sequence = v.Sequence ?? 0,
                                Category = v.Category,
                                CategoryName = c.Name,
                                ParentID = v.ParentID,
                                ParentName = p.Name ?? "",
                                ModifyDate = v.UpdateDate ?? v.CreateDate,
                                Actived = v.Actived,
                                HasChild = _db.SysCategoryValue.Any(a => a.ParentID == v.ID && a.IsDelete != true)
                            }).ToList();
                return u;
                
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public IEnumerable<CategoryValueModel> GetListValuesViaParent(string category, string name, string status, string parentId)
        {
            var bStatus = false;
            if (status != "")
                bStatus = (status == "1");
            var cate = new Guid(category);
            if (category == null)
                return null;
            try
            {
                var u = (from v in _db.SysCategoryValue
                         from c in _db.SysCategory
                             .Where(c => c.ID == v.Category).DefaultIfEmpty()
                         from p in _db.SysCategoryValue
                             .Where(p => p.ID == v.ParentID).DefaultIfEmpty()
                         where v.Category == cate && v.IsDelete != true && v.Name.Contains(name) && (status == "" || v.Actived == bStatus) && v.ParentID == new Guid(parentId)
                         orderby v.ParentID, v.Sequence
                         select new CategoryValueModel
                         {
                             ID = v.ID,
                             Name = v.Name,
                             SubCode = v.SubCode ?? "",
                             Sequence = v.Sequence ?? 0,
                             Category = v.Category,
                             CategoryName = c.Name,
                             ParentID = v.ParentID,
                             ParentName = p.Name ?? "",
                             ModifyDate = v.UpdateDate ?? v.CreateDate,
                             Actived = v.Actived,
                             HasChild = _db.SysCategoryValue.Any(a => a.ParentID == v.ID && a.IsDelete != true)
                         }).ToList();
                return u;

            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}