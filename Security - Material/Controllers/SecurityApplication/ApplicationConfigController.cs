using SSO_Material.Repositories;
using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class ApplicationConfigController : Controller
    {
        // GET: ApprovalLineConfig
        #region Application Config
        //[MvcSiteMapNode(Title = "Application Configuration", ParentKey = "home", Key = "applicationconfig")]
        public ActionResult Index()
        {
            //var controllerId = this.ControllerContext.RouteData.Values["controller"].ToString() + "Controller";
            //ViewBag.Rights = (new AuthorizationRepository()).GetRights(controllerId, User.GetClaimValue(ClaimTypes.Role));
            return View();
        }

        [AllowAnonymous]
        public ActionResult GetAll(DateTime fromDate, DateTime toDate)
        {
            var repository = new ApplicationConfigRepository();
            var list = repository.GetAll(null, 0, null, fromDate, toDate);
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        public ActionResult GetListApplication()
        {
            var res = new ApplicationConfigRepository();
            var list = res.GetListApplication().ToList();

            return Json(list, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public ActionResult Insert(ApplicationConfigModel model)
        {
            model.CreateUid = User.GetClaimValue(ClaimTypes.PrimarySid);
            var rep = new ApplicationConfigRepository();
            var response = rep.InsertApplicationConfig(model);
            return Json(response ? new { result = "OK" } : new { result = "ERROR" });
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult Update(ApplicationConfigModel model)
        {
            model.CreateUid = User.GetClaimValue(ClaimTypes.PrimarySid);
            var rep = new ApplicationConfigRepository();
            var response = rep.UpdateApplicationConfig(model);
            return Json(response ? new { result = "OK" } : new { result = "ERROR" });
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult Delete(ApplicationConfigModel model)
        {
            var rep = new ApplicationConfigRepository();
            var response = rep.DeleteApplicationConfig(model.Id, User.GetClaimValue(ClaimTypes.PrimarySid));
            return Json(response ? new { result = "OK" } : new { result = "ERROR" });
        }
        #endregion

        #region Common
        [AllowAnonymous]
        public ActionResult GetDefaultApprovalLine(int applicationId)
        {
            var response = (new ApplicationConfigRepository()).GetDefaultApproval(applicationId);
            return Json(new { data = response });
        }

        //[OutputCache(Duration = 1800, VaryByParam = "none", Location = OutputCacheLocation.Client)]
        [AllowAnonymous]
        public ActionResult ShowModalConfig(string id)
        {
            return PartialView("ApprovalLine");
        }
        #endregion
    }
}