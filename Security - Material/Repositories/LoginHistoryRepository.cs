using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories
{
    public class LoginHistoryRepository
    {
        PortalEntities _db = new PortalEntities();
        public bool InsertLog(LogHistoryModel model)
        {
            try
            {
                if (model == null) return false;

                var obj = new SysLogHistory
                {
                    UserId = model.UserId,
                    IpAddress = model.IpAddress,
                    LogTime = DateTime.Now,
                    OperatingSystem = model.OperatingSystem,
                    PcName = model.PcName,
                    PcBrowser = model.PcBrowser,
                    //ControllerName = model.ControllerName,
                    //ActionName = model.ActionName
                };
                _db.SysLogHistory.Add(obj);
                _db.SaveChanges();
                return true;

            }
            catch (Exception ex)
            {
                LogHelper.Error("Log Repository Insert Log: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return false;
            }
        }
        public IEnumerable<LogHistoryModel> GetAll(string subject, int deptId, DateTime? dateFrom, DateTime? dateTo)
        {
            try
            {
                var list = (from l in _db.SP_SYS_LOG_HISTORY(subject, deptId, dateFrom, dateTo)
                            select new LogHistoryModel()
                            {
                                UserId = l.UserId,
                                IpAddress = l.IpAddress,
                                LogTime = l.LogTime,
                                DeptName = l.DeptName,
                                PlantName = l.PlantName,
                                OrganizeName = l.OrganizationName,
                                SectionName = l.SectName,
                                Name = l.LocalName
                            }).ToList();

                if (list.Count == 0) return null;
                foreach (var item in list)
                {
                    item.StringIpAddress = Util.INT2IP(item.IpAddress ?? 0);
                }
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("NoticesRepository GetNotices: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public IEnumerable<LogHistoryModel> GetByDeptId(int deptCode)
        {
            try
            {

                var list = (from l in _db.SP_SYS_GET_LOG_BY_DEPTID(deptCode)
                            select new LogHistoryModel()
                            {
                                UserId = l.UserId,
                                IpAddress = l.IpAddress,
                                LogTime = l.LogTime,
                                DeptName = l.DeptName,
                                PlantName = l.PlantName,
                                OrganizeName = l.OrganizationName,
                                SectionName = l.SectName,
                                Name = l.LocalName
                            }).ToList();

                if (list.Count == 0) return null;
                foreach (var item in list)
                {
                    item.StringIpAddress = Util.INT2IP(item.IpAddress ?? 0);
                }
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("NoticesRepository GetNotices: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
    }
}