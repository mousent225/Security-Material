using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Security.Claims;
using System.Web.Mvc;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class GuardController : Controller
    {
        GuardRepository _rep = new GuardRepository();
        // GET: Guard
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult GetAll(DateTime fromDate, DateTime toDate)
        {
            var list = _rep.GetAll(null, fromDate, toDate);
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        public JsonResult Insert(GuardModel model)
        {
            model.Password = ED5Helper.Encrypt(model.Password);
            var result = _rep.Insert(model, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult Update(GuardModel model)
        {
            if(!string.IsNullOrEmpty(model.Password))
                model.Password = ED5Helper.Encrypt(model.Password);
            var result = _rep.Update(model, User.GetClaimValue(ClaimTypes.Sid), true);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult UpdatePass(string guardId, string pass)
        {
            var result = _rep.UpdatePass(guardId, ED5Helper.Encrypt(pass), User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}