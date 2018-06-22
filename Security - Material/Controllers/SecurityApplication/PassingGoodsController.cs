using SSO_Material.Repositories;
using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.Common;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class PassingGoodsController : Controller
    {
        PassingGoodsRepository _rep = new PassingGoodsRepository();
        // GET: PassingGoods
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Checkout()
        {
            return View();
        }
        public ActionResult GetAll(DateTime fromDate, DateTime toDate,  string userId, string approvalStatus)
        {
            var list = _rep.GetAll(null, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid), approvalStatus == "" ? null : approvalStatus);
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetForSecurity(DateTime fromDate, DateTime toDate, string userId, string approvalStatus)
        {
            var list = _rep.GetForSecurity(null, fromDate, toDate, approvalStatus == "" ? null : approvalStatus, User.GetClaimValue(ClaimTypes.Sid));
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetDetailForSecurity(DateTime fromDate, DateTime toDate)
        {
            var list = _rep.GetDetailForSecurity( true, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid));
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ViewDetail(string id)
        {
            ViewBag.ApplicationId = id;
            var item = _rep.GetDetail(int.Parse(Util.Decrypt(id).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            return View(item);
        }
        
        public JsonResult Insert(PassingGoodsMasterModel model)
        {
            if(model.Id == 0)
                return Json(_rep.Insert(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
            else
                return Json(_rep.Update(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult UpdateAll (PassingGoodsMasterModel model)
        {
            return Json(_rep.UpdateAll(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult ApplicationMasterDeleteUpdate(int id)
        {
            return Json(_rep.Delete(id, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        #region Popup
        public ActionResult ShowPopupView(string id)
        {
            ViewBag.IsCheckOut = id.Contains("checkout");
            id = id.Replace("checkout", "");
            var item = _rep.GetDetail(int.Parse(Util.Decrypt(id).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));                        
            return PartialView("_PassingGoodsView", item);
        }
        public ActionResult ShowPopupEdit(string id)
        {
            var item = _rep.GetDetail(int.Parse(Util.Decrypt(id).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            return PartialView("_PassingGoodsEdit", item);
        }
        public ActionResult ShowPopup()
        {
            return PartialView("_PassingGoods");
        }
        public ActionResult ShowPopupImage(int id)
        {
            var att = new CommonRepository();
            var listAtt = att.AttachmentGet("8C0D1530-AB8F-40D0-922C-63C9A208778A", id);
            ViewBag.ListAttachment = listAtt;
            return PartialView("_Image");
        }
        public ActionResult ShowPopupDetail(int id)
        {
            ViewBag.ReImport = id == 1;
            return PartialView("_PassingGoodsDetail");
        }
        public ActionResult ShowPopupDetailView(int id)
        {
            var att = new CommonRepository();
            var listAtt = att.AttachmentGet("8C0D1530-AB8F-40D0-922C-63C9A208778A", id);            
            var list = _rep.GetViaMaster(id, null);
            ViewBag.ListAttachment = listAtt;
            return PartialView("_PassingGoodsDetailView", list[0]);
        }
        public ActionResult Print(string id)
        {
            var masterId = int.Parse(Util.Decrypt(id).Split('_')[0]);            
            var listDetail = _rep.GetViaMaster(null, masterId);
            

            var att = new CommonRepository();
            List<AttachmentModel> listAtt = new List<AttachmentModel>();
            
            foreach (var item in listDetail)
            {                
                var list = att.AttachmentGet("8C0D1530-AB8F-40D0-922C-63C9A208778A", item.Id);
                foreach (var i in list)
                {
                    i.Path = i.Path.Replace("..", "");
                    listAtt.Add(i);
                }
            }

            var appr = _rep.GetApprovalHistory(12, masterId);

            ViewBag.ListAttachment = listAtt;
            ViewBag.Detail = listDetail;
            ViewBag.Appr = appr;
            return View(_rep.GetDetail(masterId, User.GetClaimValue(ClaimTypes.Sid))); ;
        }
        #endregion

        #region Detail
        public ActionResult GetDetailViaMaster(int? id, int? masterId)
        {
            var list = _rep.GetViaMaster(id == 0 ? null : id, masterId == 0 ? null : masterId);
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public JsonResult DetailInsert(PassingGoodsDetailModel model)
        {
            return Json(_rep.DetailInsert(model), JsonRequestBehavior.AllowGet);
        }
        public JsonResult DetailUpdate(PassingGoodsDetailModel model)
        {
            return Json(_rep.DetailUpdate(model), JsonRequestBehavior.AllowGet);
        }
        public JsonResult DetailUpdateCheckout(List<PassingGoodsDetailModel> model, DateTime? finishDate, string finishReason)
        {
            foreach (var item in model)
            {
                _rep.DetailUpdateCheckout(item.Id, item.MasterId, item.Gate, item.PassDate, item.ImportDate, item.Remark, item.Remark, finishDate, finishReason);
            }
            return Json("Ok", JsonRequestBehavior.AllowGet);
        }
        public JsonResult EndApplication(int masterId, DateTime? finishDate, string finishReason)
        {
            var result = _rep.DetailUpdateCheckout(null, masterId, null, null, null, null, null, finishDate, finishReason);
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
                        var originalDirectory = new DirectoryInfo(string.Format("{0}Resource\\Images", Server.MapPath(@"\")));

                        string pathString = Path.Combine(originalDirectory.ToString(), "PassingGoods", User.GetClaimValue(ClaimTypes.Sid));

                        var fileName1 = Path.GetFileName(file.FileName);

                        var ext = file.FileName.Split('.')[file.FileName.Split('.').Length - 1];

                        bool isExists = Directory.Exists(pathString);

                        if (!isExists)
                            Directory.CreateDirectory(pathString);

                        fName = Util.RemoveSign4VietnameseString(file.FileName.Replace("." + ext, "")).Replace(" ", "");

                        var path = string.Format("{0}\\{1}-{2:yyyyMMdd-HHmmss}.{3}", pathString, fName, DateTime.Now, ext);

                        mess = string.Format("../Resource/Images/PassingGoods/{0}/{1}-{2:yyyyMMdd-HHmmss}.{3}", User.GetClaimValue(ClaimTypes.Sid), fName, DateTime.Now, ext);


                        //var path = string.Format("{0}\\{1}-{2:yyyyMMdd HHmmss}.{3}", pathString, file.FileName.Replace("." + ext, ""), DateTime.Now, ext);

                        //mess = string.Format("../Resource/Images/PassingGoods/{0}-{1:yyyyMMdd HHmmss}.{2}", file.FileName.Replace("." + ext, ""), DateTime.Now, ext);

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
        #endregion
        #region Approval Line
       
        public ActionResult GetApproveHistory(int applicationId, int masterId)
        {
            var result = _rep.GetApprovalHistory(applicationId, masterId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult ApprovalLine(int applicationId, int masterId)
        {
            return Json(_rep.GetApproval(applicationId, masterId), JsonRequestBehavior.AllowGet);
        }
        public JsonResult Confirm(int id, bool isConfirm, string linkApplication)
        {
            return Json(_rep.Confirm(id, isConfirm, linkApplication));
        }
        public JsonResult Approve(ApprovalModel model)
        {
            return Json(_rep.Approve(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult Recall(int masterId, int applicationId)
        {
            return Json(_rep.Recall(masterId, applicationId, User.GetClaimValue(ClaimTypes.Sid)));
        }
        #endregion

        #region Check IN-OUT
        public JsonResult GoodsCheckOut(int masterId)
        {
            return Json(_rep.CheckOut(masterId, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult Import(List<PassingGoodsDetailModel> list)
        {
            return Json(_rep.Import(list, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        #endregion

    }
}