using SSO_Material.Repositories.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Security___Material.Controllers.SecurityApplication
{
    public class StatisticsController : Controller
    {
        // GET: Statistics
        VisitorApplicationMasterRepository _rep = new VisitorApplicationMasterRepository();
        public ActionResult Applications()
        {
            return View();
        }
        public ActionResult Visitor()
        {
            return View();
        }
        public ActionResult Vehicle()
        {
            return View();
        }

        public JsonResult VisitorList(int? applicationType, DateTime? fromDate, DateTime? toDate, DateTime? workDateFrom, DateTime? workDateTo, int? status)
        {
            var result = Json(_rep.Visitor(applicationType, fromDate, toDate, workDateFrom, workDateTo , status), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        public JsonResult VehicleList(int? applicationType, DateTime? fromDate, DateTime? toDate, DateTime? workDateFrom, DateTime? workDateTo, int? status)
        {
            var result = Json(_rep.Vehicle(applicationType, fromDate, toDate, workDateFrom, workDateTo, status), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
    }
}