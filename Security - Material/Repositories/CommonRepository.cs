using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels;
using SSO_Material.ViewModels.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories
{
    public class CommonRepository
    {
        PortalEntities _db = new PortalEntities();
        public List<DeptModel> GetDeptTreeView()
        {
            try
            {
                var list = (from u in _db.HrDeptMaster
                            where u.Parent == null
                            from mm in _db.HrDeptMaster.Where(m => m.Id == u.Parent && m.IsDelete == false).DefaultIfEmpty()
                            select new DeptModel
                            {
                                Id = u.Id.ToString(),
                                EnName = u.EnName,
                                HasChildren = _db.HrDeptMaster.Any(m => m.Parent == u.Id),
                                DeptCode = u.Code
                            }).ToList();
                if (list == null) return null;
                foreach (var item in list)
                {
                    item.EnName = "[" + item.DeptCode + "] " + item.EnName;
                }
                return list.OrderBy(c => c.Code).ToList();

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public IEnumerable<UserModel> GetUsers(int searchType, string userId, string userName, string status, int deptCode, string sex, string nation, bool? hasEmail)
        {
            try
            {
                var item = (from u in _db.SP_SYS_USER_LIST(searchType, userId, userName, deptCode, sex == "" ? null : sex, nation == "" ? null : nation, hasEmail)
                            select new UserModel
                            {
                                LoginID = u.Code,
                                Name = u.LocalName,
                                Email = u.Email,
                                OrganizeName = u.OrganizationName,
                                PlantName = u.PlantName,
                                DeptName = u.DeptName,
                                SectionName = u.SectName,
                                StatusName = u.NAME,
                                DeptFullName = u.DeptFullName,
                                DeptId = u.DeptId,
                                CostCenter = u.Costcenter,

                                HandPhoneNumber = u.HandPhoneNumber,
                                PhoneNumber = u.PhoneNumber
                            }).ToList();

                return item;
            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository: GetUsers: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        #region ATTACHMENT FILE
        public bool AttachmentInsert(AttachmentModel model)
        {
            try
            {
                _db.SP_SYS_ATTACHMENT_INSERT(model.ModuleId, model.MasterId, model.Name, model.Path, model.Type, model.Size);
                return true;
            }
            catch (Exception ex)
            {
                LogHelper.Error("CommonRepository: AttachmentInsert: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public List<AttachmentModel> AttachmentGet(string moduleId, int masterId)
        {
            try
            {
                var list = (from l in _db.SP_SYS_ATTACHMENT_GET(moduleId, masterId)
                            select new AttachmentModel()
                            {
                                AttachId = l.AttachId,
                                ModuleId = l.ModuleId.ToString(),
                                MasterId = l.MasterId,
                                Name = l.FileName,
                                Path = l.FilePath,
                                Type = l.FileType,
                                Size = l.FileSize
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("CommonRepository: AttachmentInsert: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public string AttachmentDelete(int id)
        {
            try
            {
                var item = (from i in _db.Attachment
                            where i.AttachId == id
                            select i).FirstOrDefault();
                if (item == null)
                    return "Nothing to do";
                _db.Attachment.Remove(item);
                _db.SaveChanges();
                return item.FilePath;
            }
            catch (Exception ex)
            {
                LogHelper.Error("CommonRepository: AttachmentDelete: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        #endregion

    }
}