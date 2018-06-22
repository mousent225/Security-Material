using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories.SecurityApplication
{
    public class GuardRepository
    {
        PortalEntities _db = new PortalEntities();
        public List<GuardModel> GetAll(int? id, DateTime? fromDate, DateTime? toDate)
        {
            try
            {
                var list = (from l in _db.SP_GUARD_GET(id, fromDate, toDate)
                            select new GuardModel()
                            {
                                GuardId = l.GuardId,
                                Name = l.Name,
                                Gate = l.Gate.ToString(),
                                GateName = l.GateName,

                                Vendor = l.Vendor.ToString(),
                                VendorName = l.VendorName,

                                Remark = l.Remark,
                                IsActive = l.IsActive,
                                IsActiveString = l.IsActiveString,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                Password = l.Password
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.Password = ED5Helper.Decrypt(item.Password);
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("GuardRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public GuardModel GetInfor(string guardId)
        {
            try
            {
                var item = _db.Guard.Where(i => i.GuardId == guardId).FirstOrDefault();
                if (item == null)
                    return null;
                var guard = new GuardModel()
                {
                    GuardId = item.GuardId,
                    Name = item.Name,
                    Gate = item.Gate.ToString(),
                    Vendor = item.Vendor.ToString()
                };
                return guard;
            }
            catch (Exception ex)
            {
                LogHelper.Error("GuardRepository GetInfor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public string Insert(GuardModel model, string userId)
        {
            try
            {
                _db.SP_GUARD_INSERT(model.Name, model.Password, model.Gate,
                                                        model.Remark, model.Vendor, model.IsActive, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                var mess = ex.InnerException.Message;
                LogHelper.Error("GuardRepository Insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return mess;
            }
        }
        public string Update(GuardModel model, string userId, bool isChangePass)
        {
            try
            {
                _db.SP_GUARD_UPDATE(model.GuardId, model.Name, model.Remark, model.IsActive, isChangePass, model.Password, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                var mess = ex.InnerException.Message;
                LogHelper.Error("GuardRepository Update: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return mess;
            }
        }

        public string UpdatePass(string guardId, string pass, string userId)
        {
            try
            {
                var item = _db.Guard.Where(a => a.GuardId == guardId).FirstOrDefault();
                if (item == null)
                    return "Error";
                item.Password = pass;
                item.UpdateUId = userId;
                item.UpdateDate = DateTime.Now;
                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                var mess = ex.InnerException.Message;
                LogHelper.Error("GuardRepository UpdatePass: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return mess;
            }
        }
    }
}