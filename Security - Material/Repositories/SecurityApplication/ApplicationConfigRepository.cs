using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories.SecurityApplication
{
    public class ApplicationConfigRepository
    {
        PortalEntities _db = new PortalEntities();
        public IEnumerable<ApplicationConfigModel> GetAll(string name, int deptId, string kind, DateTime? dateFrom, DateTime? dateTo)
        {
            try
            {
                var list = (from l in _db.SP_APPLICATION_CONFIG_GETALL(name, deptId, kind, dateFrom, dateTo)
                            select new ApplicationConfigModel()
                            {
                                Id = l.Id,
                                Name = l.Name,
                                Code = l.Code,
                                DeptId = l.DeptId,
                                DeptName = l.DeptName,
                                Description = l.Description,
                                ApprovalLineName = l.ApprovalLineName,
                                ApprovalLineDefault = l.ApprovalLineDefault,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalKind = l.ApprovalKind,
                                KindName = l.KindName,
                                Active = l.Active,
                                CreateDate = l.CreateDate,
                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName
                            }).ToList();
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository Application Config get all: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public IEnumerable<ApplicationConfigTree> GetListApplication()
        {
            try
            {
                var list = (from u in _db.SP_APPLICATION_CONFIG_GETLIST()
                            select new ApplicationConfigTree
                            {
                                id = u.ID ?? 0,
                                Name = u.NAME,
                                parentid = u.PARENTID,
                                Code = u.CODE
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.Code = Util.Encrypt(item.id.ToString());
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository Get list application: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public ApplicationConfigModel GetInfor(int id)
        {
            try
            {
                var item = (from u in _db.ApplicationConfig
                            where u.Id == id
                            select new ApplicationConfigModel
                            {
                                Id = u.Id,
                                Name = u.Name
                            }).FirstOrDefault();
                return item;

            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository GetInfor: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string GetDefaultApproval(int applicationId)
        {
            try
            {

                var approvalLine = (from l in _db.ApplicationConfig
                                    where l.Id == applicationId && l.DeleteUid == null
                                    select l.ApprovalLineJson + "|" + l.ApprovalKind.ToString()).FirstOrDefault();
                return approvalLine;

            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository GetDefaultApproval: " + applicationId.ToString() + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public bool InsertApplicationConfig(ApplicationConfigModel model)
        {
            try
            {
                if (model == null) return false;

                var item = new ApplicationConfig
                {
                    Name = model.Name,
                    Code = model.Code,
                    Description = model.Description,
                    ApprovalKind = model.ApprovalKind,
                    ApprovalLineDefault = model.ApprovalLineDefault,
                    ApprovalLineJson = model.ApprovalLineJson,
                    DeptId = model.DeptId,
                    CreateDate = DateTime.Now,
                    CreateUid = model.CreateUid
                };

                _db.ApplicationConfig.Add(item);
                _db.SaveChanges();
                return true;

            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository Insert: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return false;
            }
        }
        public bool UpdateApplicationConfig(ApplicationConfigModel model)
        {
            try
            {
                if (model == null) return false;
                var item = (from c in _db.ApplicationConfig
                            where c.Id == model.Id
                            select c).FirstOrDefault();
                if (item == null) return false;
                item.Name = model.Name;
                item.Code = model.Code;
                item.Description = model.Description;
                item.ApprovalKind = model.ApprovalKind;
                item.ApprovalLineDefault = model.ApprovalLineDefault;
                item.ApprovalLineJson = model.ApprovalLineJson;
                item.DeptId = model.DeptId;
                item.UpdateDate = DateTime.Now;
                item.UpdateUId = model.CreateUid;
                _db.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository Update: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return false;
            }
        }
        public bool DeleteApplicationConfig(int id, string empId)
        {
            try
            {
                var item = (from c in _db.ApplicationConfig
                            where c.Id == id
                            select c).FirstOrDefault();
                if (item == null) return false;
                item.DeleteDate = DateTime.Now;
                item.DeleteUid = empId;
                _db.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository Update: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return false;
            }
        }
    }
}