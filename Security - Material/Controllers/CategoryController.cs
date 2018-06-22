using SSO_Material.Repositories;
using SSO_Material.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Controllers
{
    public class CategoryController : Controller
    {
        CategoryRepository _res = new CategoryRepository();
        // GET: Category
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult GetListValueViaCate(string category, bool isFilter)
        {
            var list = _res.GetListValues(category, "", "1").ToList();
            if (isFilter) list.Insert(0, new CategoryValueModel() { ID = Guid.Empty, Name = "All" });
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetListValuesViaParent(string category, bool isFilter, string parentId)
        {
            var list = _res.GetListValuesViaParent(category, "", "1", parentId).ToList();
            if (isFilter) list.Insert(0, new CategoryValueModel() { ID = Guid.Empty, Name = "All" });
            return Json(list, JsonRequestBehavior.AllowGet);
        }
    }
}