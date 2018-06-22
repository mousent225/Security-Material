using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class VendorController : Controller
    {
        VisitorApplicationMasterRepository _rep = new VisitorApplicationMasterRepository();
        // GET: Vendor
        public ActionResult Index()
        {
            return View();
        }
        [OutputCache(Duration = 86400, Location = OutputCacheLocation.Client, NoStore = true, VaryByParam = "none")]
        public ActionResult GetListVendor(int? id, DateTime fromDate, DateTime toDate, string vendorType)
        {
            var list = _rep.GetListVendor(id, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid), vendorType);
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public JsonResult FindVendor(string value, string vendorType)
        {
            var list = _rep.VendorFind(value, vendorType);
            return Json(list, JsonRequestBehavior.AllowGet);
        }
    }
}