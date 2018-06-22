using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.IO;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class ViolationController : Controller
    {
        ViolationRepository _rep = new ViolationRepository();
        // GET: Violation
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetAll(DateTime fromDate, DateTime toDate, string approvalStatus)
        {
            var list = _rep.GetList(null, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid), approvalStatus == "" ? null : approvalStatus);
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ShowApplication(string id)
        {
            ViewBag.ApplicationType = id;
            var partialView = "_Violation";
            return PartialView(partialView);
        }
        public ActionResult ShowApplicationView(string id)
        {
            var list = _rep.GetList(int.Parse(id), DateTime.MinValue, DateTime.MaxValue, User.GetClaimValue(ClaimTypes.Sid), null);
            var partialView = "_ViolationView";
            return PartialView(partialView, list[0]);
        }
        public JsonResult Insert(ViolationModel model)
        {
            var result = _rep.Insert(model, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult Update(ViolationModel model)
        {
            var result = _rep.Update(model, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult SaveUploadedFile()
        {
            bool isSavedSuccessfully = true;
            string fName = "";
            var mess = "";
            try
            {
                foreach (string fileName in Request.Files)
                {
                    HttpPostedFileBase file = Request.Files[fileName];
                    //Save file content goes here
                    fName = file.FileName;
                    if (file != null && file.ContentLength > 0)
                    {

                        var originalDirectory = new DirectoryInfo(string.Format("{0}Resource\\Application", Server.MapPath(@"\")));

                        string pathString = Path.Combine(originalDirectory.ToString(), "Violation");

                        var fileName1 = Path.GetFileName(file.FileName);

                        var ext = file.FileName.Split('.')[file.FileName.Split('.').Length - 1];

                        bool isExists = Directory.Exists(pathString);

                        if (!isExists)
                            Directory.CreateDirectory(pathString);

                        var path = string.Format("{0}\\{1}-{2:yyyyMMdd HHmmss}.{3}", pathString, file.FileName.Replace("." + ext, ""), DateTime.Now, ext);

                        mess = string.Format("/Resource/Application/Violation/{0}-{1:yyyyMMdd HHmmss}.{2}", file.FileName.Replace("." + ext, ""), DateTime.Now, ext);

                        file.SaveAs(path);
                    }

                }

            }
            catch (Exception ex)
            {
                mess = ex.InnerException.Message;
                isSavedSuccessfully = false;
            }
            if (isSavedSuccessfully)
            {
                return Json(new { Message = mess });
            }
            else
            {
                return Json(new { Message = "Error in saving file" });
            }
        }

    }
}