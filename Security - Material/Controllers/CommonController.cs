using SSO_Material.Repositories;
using SSO_Material.ViewModels.Common;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace SSO_Material.Controllers
{
    public class CommonController : Controller
    {
        readonly CommonRepository _rep = new CommonRepository();
        // GET: Dept
        public ActionResult Index()
        {
            return View();
        }
        public JsonResult GetDeptTreeView()
        {
            var result = _rep.GetDeptTreeView();
            return result.Any() ? Json(result, JsonRequestBehavior.AllowGet) : null;
        }        

        #region employee 
        public ActionResult ShowModalEmployeeInfor(string id)//id: iclude empId_modalName
        {
            ViewBag.EmpId = id;
            return PartialView("_EmployeeInfor");
        }

        public JsonResult GetEmployeeInfor(int deptCode, string userId, string userName, string status, string nation, string sex, bool? hasEmail)
        {
            var result = Json(_rep.GetUsers(1, userId, userName, status, deptCode, sex, nation, hasEmail), JsonRequestBehavior.AllowGet);
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        #endregion

        #region ATTACHMENT FILE
        public JsonResult AttachmentInsert(List<AttachmentModel> model)
        {
            foreach (var item in model)
            {
                _rep.AttachmentInsert(item);
            }
            return Json("Ok", JsonRequestBehavior.AllowGet);
        }
        public JsonResult AttachmentDelete(int id)
        {
            var result = _rep.AttachmentDelete(id);
            var serverPath = Request.MapPath("~" + result.Replace("../",""));
            if (System.IO.File.Exists(serverPath))
            {
                System.IO.File.Delete(serverPath);
            }
            return Json("Ok", JsonRequestBehavior.AllowGet);
        }
        public JsonResult AttachmentGet(string moduleId, int masterId)
        {
            var result = _rep.AttachmentGet(moduleId, masterId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        #endregion
        
    }

}