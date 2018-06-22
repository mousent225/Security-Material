using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories
{
    public class ForgetCardRepository
    {
        PortalEntities _db = new PortalEntities();

        public IEnumerable<ForgetCardModel> GetAll(int deptId, string empId, string empName, string position, string jobTitle, DateTime fromDate, DateTime toDate)
        {
            var list = (from l in _db.SP_FORGETCARD_GETALL(deptId, empId, empName, position, jobTitle, fromDate, toDate)
                        select new ForgetCardModel()
                        {
                            EmpId = l.EmpId,
                            EmpName = l.EmpName,
                            WorkDate = l.WorkDate ?? new DateTime(),
                            OrgName = l.OrganizationName,
                            PlantName = l.PlantName,
                            DeptName = l.DeptName,
                            SectName = l.SectName,
                            Position = l.Posistion,
                            JobTitle = l.JobTitle,
                            TimeIn = l.TimeIn,
                            TimeOut = l.TimeOut,
                            ReasonName = l.ReasonName
                        }).ToList();
            return list;
        }

        public ForgetCardModel GetInfor(string empId, DateTime? workDate)
        {
            var list = (from l in _db.SP_FORGETCARD_GETINFOR(empId, workDate)
                        select new ForgetCardModel()
                        {
                            Id = l.Id,
                            EmpId = l.EmpId,
                            EmpName = l.EmpName,
                            Position = l.Posistion,
                            JobTitle = l.JobTitle,
                            JoinDate = l.JOINDATE,
                            DeptFullName = l.DeptFullName,
                            DeptId = l.DeptId??0,
                            TimeIn = l.TimeIn,
                            TimeOut = l.TimeOut,
                            ImageBinary = l.Img,
                            WorkDate = l.WorkDate ?? new DateTime(),
                            SecurityName = l.SecurityName,
                            GateNumber = l.GateId.ToString(),
                            GateName = l.GateName,
                            TemporaryCard = l.TemporaryCard,
                            Reason = l.Reason,
                            ReasonOthers = l.ReasonOthers,
                            ReasonName = l.ReasonName,
                            Org = l.Organization??0,
                            OrgName = l.OrganizationName,
                            DeptPrint = l.DeptNamePrint
                        }).FirstOrDefault();
            if (list == null)
                return null;

            list.Image = Util.ScaleImage(list.ImageBinary);
            
            return list;
        }

        public string UpdateForgetCard(ForgetCardModel model)
        {
            try
            {
                _db.SP_FORGETCARD_UPDATE(model.EmpId, model.WorkDate, model.TimeIn, model.TimeOut, model.SecurityName, model.TemporaryCard, model.GateNumber, model.Reason, model.ReasonOthers, model.IsCheckIn, model.Id);
                return "Ok";
            }
            catch (Exception ex)
            {
                return ex.InnerException.ToString();
            }
        }

        public string DeleteForgetCard(string empId, DateTime? workDate)
        {
            try
            {
                _db.SP_FORGETCARD_DELETE(empId, workDate);
                return "Ok";
            }
            catch (Exception ex)
            {
                return ex.InnerException.ToString();
            }
        }
    }
}