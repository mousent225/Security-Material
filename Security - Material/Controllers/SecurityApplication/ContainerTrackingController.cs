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

namespace Security___Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class ContainerTrackingController : Controller
    {
        VisitorApplicationMasterRepository _rep = new VisitorApplicationMasterRepository();
        // GET: ContainerTracking
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ShowApplicationDetail(int id)
        {
            ViewBag.ApplicationId = id;
            return PartialView("_Insert");
        }
        public ActionResult ShowApplicationDetailView(string id)
        {
            var item = _rep.GetMasterDetail(int.Parse(Util.Decrypt(id).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            var patialView = "_View";
            return PartialView(patialView, item);
        }
        public ActionResult ShowApplicationDetailEdit(string id)
        {
            var item = _rep.GetMasterDetail(int.Parse(Util.Decrypt(id).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            var patialView = "_Edit";
            return PartialView(patialView, item);
        }
        public JsonResult GetList(int? id, int? masterId)
        {
            var result = Json(_rep.ContainerGetList(id, masterId), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        public JsonResult Insert(List<ContainerDetailModel> list)
        {
            var result = _rep.ContainerInsertMulti(list, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult Update(ContainerDetailModel model)
        {
            var result = _rep.ContainerUpdate(model, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult Delete(int[] list)
        {
            var result = _rep.ContainerDelete(list, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult SetSameDate(int masterId, DateTime fromDate, DateTime toDate)
        {
            return Json(_rep.ContainerSetSameDate(masterId, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid)));
        }
    }
}