
using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;

namespace SSO_Material.Controllers.SecurityApplication
{
    [KSAuthorized]
    public class VisitorApplicationMasterController : Controller
    {
        #region Application Master
        VisitorApplicationMasterRepository _rep = new VisitorApplicationMasterRepository();
        // GET: VisitorApplicationMaster
        public ActionResult Index()
        {
            return View();
        }
        
        public ActionResult ViewDetail(string id)
        {
            ViewBag.ApplicationId = id;
            var item = _rep.GetMasterDetail(int.Parse(Util.Decrypt(id).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            return View(item);
        }

        [AllowAnonymous]
        public ActionResult GetAll(DateTime fromDate, DateTime toDate, int? applicationType, string userId, string approvalStatus)
        {
            var list = _rep.GetAll(null, fromDate, toDate, applicationType, User.GetClaimValue(ClaimTypes.Sid), approvalStatus == "" ? null : approvalStatus);
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetForSecurity(DateTime fromDate, DateTime toDate, int? applicationType, string approvalStatus)
        {
            var list = _rep.GetForSecurity(null, fromDate, toDate, applicationType, approvalStatus == "" ? null : approvalStatus, User.GetClaimValue(ClaimTypes.Sid));
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetForIssued(DateTime fromDate, DateTime toDate)
        {
            var list = _rep.GetForIssued(fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid));
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult ShowApplicationDetail(int id)
        {
            ViewBag.ApplicationId = id;
            switch (id)
            {
                case 8:
                    return PartialView("_ShortTerm");
                case 9:
                    return PartialView("_LongTerm");
                default:
                    return PartialView("_ShortTerm");
            }
        }

        public ActionResult ShowApplicationDetailView(string id)
        {
            var applicationId = id.Split('_')[0];
            var applicationType = id.Split('_')[1];
            var isCheckIn = (id.Split('_')[2] == "checkinout");
            var item = _rep.GetMasterDetail(int.Parse(Util.Decrypt(applicationId).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            var patialView = (applicationType == "8" ? "_ShortTermView" : "_LongTermView");
            ViewBag.IsCheckIn = isCheckIn;
            return PartialView(patialView, item);
        }
        public ActionResult ShowApplicationDetailEdit(string id)
        {
            var applicationId = id.Split('_')[0];
            var applicationType = id.Split('_')[1];
            var item = _rep.GetMasterDetail(int.Parse(Util.Decrypt(applicationId).Split('_')[0]), User.GetClaimValue(ClaimTypes.Sid));
            var patialView = (applicationType == "8" ? "_ShortTermEdit" : "_LongTermEdit");
            return PartialView(patialView, item);
        }

        public int ApplicationMasterInsert(VisitorApplicationMasterModel model)
        {
            if (model.Id == 0)
                return _rep.ApplicationMasterInsert(model, User.GetClaimValue(ClaimTypes.Sid));
            else
            {
                _rep.ApplicationMasterUpdate(model, User.GetClaimValue(ClaimTypes.Sid));
                return model.Id;
            }
        }
        public JsonResult ApplicationMasterCopy(int id, int applicationType)
        {
            return Json(_rep.ApplicationMasterCopy(id, applicationType, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult ApplicationMasterUpdateAll(VisitorApplicationMasterModel model)
        {
            return Json(_rep.ApplicationMasterUpdateAll(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }

        public JsonResult ApplicationMasterDelete(int id)
        {
            return Json(_rep.ApplicationMasterDelete(id), JsonRequestBehavior.AllowGet);
        }

        public JsonResult ApplicationMasterDeleteUpdate(int id)
        {
            return Json(_rep.ApplicationMasterDeleteUpdate(id, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region Detail
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
                    //fName = file.FileName;
                    if (file != null && file.ContentLength > 0)
                    {

                        var originalDirectory = new DirectoryInfo(string.Format("{0}Resource\\Images", Server.MapPath(@"\")));

                        string pathString = Path.Combine(originalDirectory.ToString(), "Avatar", User.GetClaimValue(ClaimTypes.Sid));
                        
                        var fileName1 = Path.GetFileName(file.FileName);

                        var ext = file.FileName.Split('.')[file.FileName.Split('.').Length - 1];

                        bool isExists = Directory.Exists(pathString);

                        if (!isExists)
                            Directory.CreateDirectory(pathString);
                        fName = Util.RemoveSign4VietnameseString(file.FileName.Replace("." + ext, "")).Replace(" ", "");

                        var path = string.Format("{0}\\{1}-{2:yyyyMMdd-HHmmss}.{3}", pathString, fName, DateTime.Now, ext);

                        mess = string.Format("../Resource/Images/Avatar/{0}/{1}-{2:yyyyMMdd-HHmmss}.{3}", User.GetClaimValue(ClaimTypes.Sid), fName, DateTime.Now, ext);

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
        public JsonResult DeleteFile(string fileName)
        {
            var originalDirectory = new DirectoryInfo(string.Format("{0}Resource\\Images", Server.MapPath(@"\")));

            string pathString = Path.Combine(originalDirectory.ToString(), "Avatar");

            var serverPath = Request.MapPath("~" + fileName);
            if (System.IO.File.Exists(serverPath))
            {
                System.IO.File.Delete(serverPath);
            }
            return Json(new { result = "OK" });
        }

        public ActionResult GetDetail(int applicationMasterId)
        {
            var list = _rep.GetDetail(applicationMasterId, null);
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetDetailVehicle(int applicationMasterId)
        {
            var list = _rep.GetDetailVehicle(applicationMasterId, null);
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetListViaVendor(string identityCard, int? vendorId, DateTime fromDate, DateTime toDate)
        {
            var list = _rep.GetListViaVendor(null, identityCard == "" ? null : identityCard, vendorId == 0 ? null : vendorId, fromDate, toDate);
            return Json(list, JsonRequestBehavior.AllowGet);
        }        
        public JsonResult DetailInsert(VisitorApplicationDetailModel model)
        {
            return Json( _rep.DetailInsert(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult DetailInsertMulti(List<VisitorApplicationDetailModel> model)
        {
            return Json(_rep.InsertMulti(model, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public JsonResult DetailUpdate(VisitorApplicationDetailModel model)
        {
            return Json(_rep.DetailUpdate(model, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public JsonResult DetailPersonDelete(int[] id)
        {
            return Json(_rep.DetailPersonDelete(id, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public JsonResult DetailVehicleDelete(int[] id)
        {
            return Json(_rep.DetailVehicleDelete(id, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public JsonResult SetSameDate(int masterId, DateTime fromDate, DateTime toDate)
        {
            return Json(_rep.SetSameDate(masterId, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public ActionResult ShowVisitorDetail()
        {
            return PartialView("_VisitorInfor");
        }
        public ActionResult ShowVisitorDetailView(int id)
        {
            var model = _rep.GetDetail(null, id)[0];
            return PartialView("_VisitorInforView", model);
        }
        public ActionResult ShowVisitorList(string id)
        {
            ViewBag.IdentityCard = id;
            return PartialView("_VisitorList");
        }

        public JsonResult VisitorGetList(string apprStatus)
        {
            var result = (new VisitorWorkingDailyRepository()).GetListVisitor(null, null, null, null, null, apprStatus == "" ? null : apprStatus, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult VisitorDetail(int visitorId)
        {
            var result = (new VisitorWorkingDailyRepository()).GetListDetail(visitorId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult VehicleGetList(string apprStatus)
        {
            var result = (new VisitorWorkingDailyRepository()).GetListVehicle(null, null, null, null, null, apprStatus == "" ? null : apprStatus, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult VehicleGetListCurrent()
        {
            var result = (new VisitorWorkingDailyRepository()).GetListVehicleCurrent();
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Vendor
        public ActionResult GetListVendor(int? id, DateTime fromDate, DateTime toDate, string vendorType)
        {
            var list = _rep.GetListVendor(id, fromDate, toDate, User.GetClaimValue(ClaimTypes.Sid), vendorType);
            return Json(list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult ShowVendorInformation(string vendorType)
        {
            return PartialView("_Vendor");
        }
        public ActionResult ShowVendorInformationView(int id)
        {
            var list = _rep.GetListVendor(id, DateTime.MinValue, DateTime.MaxValue, User.GetClaimValue(ClaimTypes.Sid), null);
            return PartialView("_VendorView", list[0]);
        }
        public ActionResult ShowVendorList()
        {
            return PartialView("_VendorList");
        }
        public JsonResult VendorInsert(VendorModel model)
        {
            var result = _rep.VendorInsert(model, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result);
        }
        public JsonResult VendorUpdate(VendorModel model)
        {
            var result = _rep.VendorUpdate(model, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result);
        }
        public JsonResult VendorUpdateTermOfUse(int id, bool isChecked)
        {
            var result = _rep.VendorUpdateTermOfUse(id, isChecked, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult VendorDelete(int id)
        {
            var result = _rep.VendorDelete(id, User.GetClaimValue(ClaimTypes.Sid));
            return Json(result);
        }

        #endregion

        #region Approval Line
        public string DefaultApprovalLine(int applicationId)
        {
            return _rep.GetDefaultApproval(applicationId);
        }
        public ActionResult ApprvalLineHistory(int applicationId)
        {
            var result = _rep.ApprovalHistoryGetList(User.GetClaimValue(ClaimTypes.Sid), applicationId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

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
            return Json( _rep.ApplicationConfirm(id, isConfirm, linkApplication));
        }
        public JsonResult Approve(ApprovalModel model)
        {
            return Json(_rep.ApproveApplication(model, User.GetClaimValue(ClaimTypes.Sid)), JsonRequestBehavior.AllowGet);
        }
        public JsonResult Recall(int masterId, int applicationId)
        {
            return Json(_rep.RecallApplication(masterId, applicationId, User.GetClaimValue(ClaimTypes.Sid)));
        }
        #endregion

        #region Card Issuance
        public ActionResult CardIssuance()
        {
            return View();
        }
        public JsonResult CardIssued(List<VisitorApplicationDetailModel> list, bool isVisitor)
        {
            return Json(_rep.CardIssuance(list, isVisitor, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public JsonResult SendEmailForVisitor(int masterId)
        {
            return Json(_rep.SendMail(masterId, User.GetClaimValue(ClaimTypes.Sid)));
        }
        public JsonResult SendEmailForVehicle(int masterId, int type)
        {
            return Json(_rep.SendMailVehicle(masterId, User.GetClaimValue(ClaimTypes.Sid), type));
        }
        #endregion

        #region SignalR



        #endregion

        #region Print Card

        public ViewResult PrintCard(int masterId)
        {
            var list = _rep.GetDetail(masterId, null);
            ViewBag.VisitorList = list;
            var masterDetail = _rep.GetMasterDetail(masterId, User.GetClaimValue(ClaimTypes.Sid));
            ViewBag.CompanyName = masterDetail.VendorName;
            return View();
        }
        public ViewResult PrintCardVehicle()
        {
            return View();
        }
        #endregion
    }
}