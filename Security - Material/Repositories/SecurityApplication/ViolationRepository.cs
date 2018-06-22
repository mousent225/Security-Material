using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;

namespace SSO_Material.Repositories.SecurityApplication
{    
    public class ViolationRepository
    {
        PortalEntities _db = new PortalEntities();
        public List<ViolationModel> GetList(int? id, DateTime? fromDate, DateTime? toDate, string userId, string approvalStatus)
        {
            try
            {
                var list = (from l in _db.SP_VIOLATION_GET(id, fromDate, toDate, userId, approvalStatus)
                            select new ViolationModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                EmpId = l.EmpId,
                                EmpName = l.EmpName,
                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                VisitorId = l.VisitorId,
                                VisitorName = l.VisitorName,
                                VendorId = l.VendorId ?? 0,
                                VendorName = l.VendorName,
                                IdentityCard = l.IdentityCard,

                                ViolateDate = l.ViolateDate,
                                ViolateType = l.ViolateType.ToString(),
                                ViolationTypeName = l.ViolationTypeName,
                                ReasonDetail = l.ReasonDetail,

                                PersonInCharge = l.PersonInCharge,
                                PersonInChargeName = l.PersonInChargeName,
                                IsAttachment = l.IsAttachment,

                                IsBlackList = l.IsBlackList,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                IsView = l.ISVIEW != 0
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.IdEncrypt = Util.Encrypt(item.Id.ToString() + "_" + string.Format("hhss", DateTime.Now));
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ViolationRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public int Insert(ViolationModel model, string userId)
        {
            try
            {
                var result = (_db.SP_VIOLATION_INSERT(model.VisitorId, model.EmpId, model.DeptId, model.ViolateDate, model.ViolateType, model.ReasonDetail, model.IsBlackList, model.PersonInCharge, model.IsAttachment, userId)
                             ).FirstOrDefault();
                return result ?? 0;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ViolationRepository Insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return 0;
            }
        }
        public string Update(ViolationModel model, string userId)
        {
            try
            {
                var result = _db.SP_VIOLATION_UPDATE(model.Id, model.VisitorId, model.EmpId, model.DeptId, model.ViolateDate, model.ViolateType, model.ReasonDetail, model.IsBlackList, model.PersonInCharge, model.IsAttachment, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("ViolationRepository Update: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
    }
}