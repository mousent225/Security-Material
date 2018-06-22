using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class VisitorWorkingDailyController : Controller
    {
        VisitorWorkingDailyRepository _rep = new VisitorWorkingDailyRepository();
        // GET: VisitorWorkingDaily
        public ActionResult Index()
        {
            var guard = (new GuardRepository()).GetInfor(User.GetClaimValue(ClaimTypes.Sid));
            ViewBag.GateDefaultId = guard == null ? "" : guard.Gate;
            return View();
        }

        public ActionResult History()
        {
            return View();
        }
        #region Visitor
        public JsonResult VisitorGetList(DateTime workDate, string gateId, int applicationType)
        {
            var result = Json(_rep.GetListVisitor(null, workDate, gateId, null, applicationType, null, null), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        public JsonResult VisitorDetail(int visitorId)
        {
            var result = _rep.GetListDetail(visitorId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        //public JsonResult VisitorHistory(DateTime fromDate, DateTime toDate)
        //{
        //    var result = _rep.GetHistory(fromDate, toDate, "");
        //    return Json(result, JsonRequestBehavior.AllowGet);
        //}
        public JsonResult Insert(int visitorId, string visitorCard, string remark, bool isCheckIn, int applicationType)
        {
            return Json(_rep.Insert(visitorId, visitorCard, remark, User.GetClaimValue(ClaimTypes.Sid), isCheckIn, applicationType));
        }
        public JsonResult CheckOff(List<VisitorWorkingDailyModel> list)
        {
            return Json(_rep.CheckOff(list, User.GetClaimValue(ClaimTypes.Sid)));
        }
        #endregion

        #region Vehicle
        public JsonResult VehicleGetList(DateTime workDate, string gateId, int applicationType)
        {
            var result = Json(_rep.GetListVehicle(null, workDate, gateId, null, applicationType, null, null), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        public JsonResult VehicleGetListCurrent()
        {
            var result = _rep.GetListVehicleCurrent();
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult VehicleDetail(int visitorId)
        {
            var result = _rep.GetListVehicleDetail(visitorId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult VehicleInsert(int vehicleId, string vehicleCard, string remark, bool isCheckIn, string newDriver)
        {
            return Json(_rep.VehicleInsert(vehicleId, vehicleCard, remark, User.GetClaimValue(ClaimTypes.Sid), isCheckIn, newDriver));
        }
        public JsonResult VehicleCheckOff(List<VehicleCheckingDailyModel> list)
        {
            return Json(_rep.VehicleCheckOff(list, User.GetClaimValue(ClaimTypes.Sid)));
        }
        #endregion

        #region Container
        public JsonResult ContainerGetList(DateTime workDate, string gateId)
        {
            var result = Json(_rep.GetListContainer(null, workDate, gateId, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        public JsonResult ContainerDetail(int containerId)
        {
            var result = _rep.GetListContainerDetail(containerId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult ContainerTrackingInsert(int containerId, int vehicleId, string remark, bool isCheckIn)
        {
            return Json(_rep.ContainerTrackingInsert(containerId, vehicleId, remark, isCheckIn, User.GetClaimValue(ClaimTypes.Sid)));
        }
        #endregion

    }
}