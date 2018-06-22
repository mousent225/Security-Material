using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;

namespace SSO_Material.Repositories.SecurityApplication
{    
    public class PassingGoodsRepository
    {
        PortalEntities _db = new PortalEntities();
        #region Master
        public List<PassingGoodsMasterModel> GetAll(int? id, DateTime? fromDate, DateTime? toDate, string userId, string approvalStatus)
        {
            try
            {
                var list = (from l in _db.SP_PASSINGGOODS_GET(id, fromDate, toDate, userId, approvalStatus)
                            select new PassingGoodsMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                ApprovalKind = l.ApprovalKind.ToString(),
                                ApprovalKindName = l.KindName,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalLine = l.ApprovalLine,
                                ApprovalStatus = l.ApprovalStatus.ToString(),
                                ApprovalStatusName = l.ApprovalStatusName,
                                NextApprover = l.NextApprover,
                                NextApproverName = l.NextApproverName,

                                ApplicationDate = l.ApplicationDate,
                                ReImport = l.ReImport ?? false,
                                ReImportDate = l.ReImportDate,
                                Reason = l.Reason,

                                FinishApplication = l.FinishApplication ?? false,
                                FinishReason = l.FinishReason,
                                FinishDate = l.FinishDate,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                IsView = l.ISVIEW != 0,

                                ExportDate = l.ExportDate,
                                ExportUid = l.ExportUid,
                                ExportName = l.ExportName,
                                ExportGate = l.GateName
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.IdEncrypt = Util.Encrypt(item.Id.ToString() + "_" + string.Format("hhss", DateTime.Now));
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<PassingGoodsMasterModel> GetForSecurity(int? id, DateTime? fromDate, DateTime? toDate, string approvalStatus, string userId)
        {
            try
            {
                var list = (from l in _db.SP_PASSINGGOODS_GET_FOR_SECURITY(id, fromDate, toDate, approvalStatus, userId)
                            select new PassingGoodsMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                ApprovalKind = l.ApprovalKind.ToString(),
                                ApprovalKindName = l.KindName,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalLine = l.ApprovalLine,
                                ApprovalStatus = l.ApprovalStatus.ToString(),
                                ApprovalStatusName = l.ApprovalStatusName,
                                NextApprover = l.NextApprover,
                                NextApproverName = l.NextApproverName,

                                ApplicationDate = l.ApplicationDate,
                                ReImport = l.ReImport ?? false,
                                ReImportDate = l.ReImportDate,
                                Reason = l.Reason,

                                FinishApplication = l.FinishApplication ?? false,
                                FinishReason = l.FinishReason,
                                FinishDate = l.FinishDate,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                ExportDate = l.ExportDate,
                                ExportUid = l.ExportUid,
                                ExportName = l.ExportName,
                                ExportGate = l.GateName,
                                IsView = l.ISVIEW == 1
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.IdEncrypt = Util.Encrypt(item.Id.ToString() + "_" + string.Format("hhss", DateTime.Now));
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetForSecurity: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }        

        public PassingGoodsMasterModel GetDetail(int id, string userId)
        {
            try
            {
                var list = (from l in _db.SP_PASSINGGOODS_GETDETAIL(id, userId)
                            select new PassingGoodsMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                ApprovalKind = l.ApprovalKind.ToString(),
                                ApprovalKindName = l.KindName,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalLine = l.ApprovalLine,
                                ApprovalStatus = l.ApprovalStatus.ToString(),
                                ApprovalStatusName = l.ApprovalStatusName,
                                NextApprover = l.NextApprover,
                                NextApproverName = l.NextApproverName,

                                ApplicationDate = l.ApplicationDate,
                                ReImport = l.ReImport ?? false,
                                ReImportDate = l.ReImportDate,
                                Reason = l.Reason,

                                FinishApplication = l.FinishApplication ?? false,
                                FinishReason = l.FinishReason,
                                FinishDate = l.FinishDate,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                IsRecall = l.IsRecall ?? false,

                                ExportDate = l.ExportDate,
                                ExportUid = l.ExportUid,
                                ExportName = l.ExportName,
                                ExportGate = l.GateName

                            }).FirstOrDefault();
                list.IdEncrypt = Util.Encrypt(list.Id.ToString() + "_" + string.Format("hhss", DateTime.Now));
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public int Insert(PassingGoodsMasterModel model, string userId)
        {
            try
            {
                var result = (_db.SP_PASSINGGOODS_INSERT(model.Applicant, model.DeptId, model.ApplicationDate,
                                                        model.ReImport, model.ReImportDate, model.Reason, userId)).FirstOrDefault();
                return result ?? 0;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository Insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return 0;
            }
        }

        public int Update(PassingGoodsMasterModel model, string userId)
        {
            try
            {
                _db.SP_PASSINGGOODS_UPDATE(model.Id, model.Applicant, model.DeptId, model.ApplicationDate,
                                                        model.ReImport, model.ReImportDate, model.Reason, userId);
                return model.Id;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository Update: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return 0;
            }
        }
        public string UpdateAll(PassingGoodsMasterModel model, string userId)
        {
            try
            {
                _db.SP_PASSINGGOODS_UPDATE_ALLDATA(model.Id, 12, model.ApprovalLine, model.ApprovalLineJson, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository UpdateAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        public string Delete(int id, string userId)
        {
            try
            {
                var item = (from d in _db.PassingGoodsMaster
                            where d.Id == id
                            select d).FirstOrDefault();
                if (item == null)
                    return "Not found";
                item.DeleteDate = DateTime.Now;
                item.DeleteUid = userId;
                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository Delete: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion

        #region Detail
        public List<PassingGoodsDetailModel> GetViaMaster(int? id, int? masterId)
        {
            try
            {
                var list = (from l in _db.SP_PASSINGGOODS_DETAIL_GET(id, masterId, null)
                            select new PassingGoodsDetailModel()
                            {
                                Id = l.Id,
                                MasterId = l.MasterId,
                                ItemName = l.ItemName,
                                ItemLocation = l.ItemLocation,
                                Serial = l.Serial,
                                Description = l.Description,
                                Quantity = l.Quantity,
                                
                                ReImport = l.ReImport ?? false,
                                ReImportName = l.ReImportName,

                                ReImportDate = l.ReImportDate,
                                IsAttachment = l.IsAttachment,

                                Remark = l.Remark,
                                
                                ImportDate = l.ImportDate,
                                ImportGate = l.ImportGate,
                                ImportName = l.ImportName,
                                ImportUid = l.ImportUid

                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public int DetailInsert(PassingGoodsDetailModel model)
        {
            try
            {
                var result = (_db.SP_PASSINGGOODS_DETAIL_INSERT(model.MasterId, model.ItemName, model.Serial, model.Description, model.Quantity, model.ItemLocation, 
                    model.IsAttachment, model.ReImport, model.ReImportDate)).FirstOrDefault();
                return result ?? 0;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return 0;
            }
        }
        public string DetailUpdate(PassingGoodsDetailModel model)
        {
            try
            {
                _db.SP_PASSINGGOODS_DETAIL_UPDATE(model.Id, model.MasterId, model.ItemName, model.Serial, model.Description, model.Quantity, model.ItemLocation, model.IsAttachment);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }

        public string DetailUpdateCheckout(int? id, int masterId, string gateId, DateTime? passDate, DateTime? importDate, string remark, string securityName, DateTime? finishDate, string finishReason)
        {
            try
            {
                _db.SP_PASSINGGOODS_DETAIL_UPDATE_CHECKOUT(id, masterId, gateId, passDate, importDate, remark, securityName, finishDate, finishReason);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }

        #endregion
        #region Approval
        public List<ApprovalModel> GetApproval(int applicationId, int masterId)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_GET_APPROVAL(applicationId, masterId)
                            select new ApprovalModel()
                            {
                                Id = l.Id,
                                ApplicationId = l.ApplicationId,
                                MasterId = l.MasterId,
                                EmpId = l.EmpId,
                                EmpName = l.EmpName,
                                ApproverType = l.ApproverType.ToString(),
                                ApproverTypeName = l.ApproverTypeName,
                                IsApprove = l.IsApprove,
                                Comment = l.Comment,
                                DateApprove = l.DateApprove,
                                Seq = l.Seq
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository GetApproval: " + applicationId.ToString() + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }

        }
        public List<ApprovalModel> GetApprovalHistory(int applicationId, int masterId)
        {
            try
            {
                var list = (from l in _db.SP_PASSINGGOODS_APPROVAL_HISTORY(masterId, applicationId)
                            select new ApprovalModel()
                            {
                                Id = l.Id ?? 0,
                                EmpId = l.EmpId,
                                EmpName = l.EmpName,
                                ApproverType = l.ApprovalType.ToString(),
                                ApproverTypeName = l.ApproverTypeName,
                                IsApprove = l.IsApprove,
                                Comment = l.Comment,
                                DateApprove = l.DateApprove,
                                DateApproveFormat = l.DateApproveFormat,
                                Seq = l.Seq ?? 0,
                                JobTitle = l.JobTitle
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository GetApprovalHistory: " + applicationId.ToString() + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string Confirm(int id, bool isConfirm, string linkApplication)
        {
            try
            {
                var result = _db.SP_PASSINGGOODS_CONFIRM(id, isConfirm, linkApplication);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository ApplicationConfirm: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        public string Approve(ApprovalModel model, string userId)
        {
            try
            {
                if (model == null)
                    return "Error: model null";

                var result = _db.SP_PASSINGGOODS_APPROVE(model.MasterId, model.ApplicationId, model.IsApprove, model.Comment, userId, model.LinkApplication);
                return "Ok";

            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository ApproveApplication: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        public string Recall(int masterId, int applicationId, string userId)
        {
            try
            {

                var result = _db.SP_PASSINGGOODS_RECALL(masterId, applicationId, userId);
                return "Ok";

            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository RecallApplication: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion

        #region Check IN-OUT
        public List<PassingGoodsDetailModel> GetDetailForSecurity(bool isImport, DateTime? fromDate, DateTime? toDate, string userId)
        {
            try
            {
                var list = (from l in _db.SP_PASSINGGOODS_DETAIL_GET_FOR_SECURITY(isImport, fromDate, toDate, userId)
                            select new PassingGoodsDetailModel()
                            {
                                Id = l.Id,

                                MasterId = l.MasterId,
                                Code = l.Code,
                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,
                                ApplicationDate = l.ApplicationDate,
                                ExportDate = l.ExportDate,

                                ItemName = l.ItemName,
                                ItemLocation = l.ItemLocation,
                                Serial = l.Serial,
                                Description = l.Description,
                                Quantity = l.Quantity,

                                ReImport = l.ReImport ?? false,
                                ReImportDate = l.ReImportDate,
                                IsAttachment = l.IsAttachment,

                                Remark = l.Remark,

                                ImportDate = l.ImportDate,
                                ImportGate = l.ImportGate,
                                ImportName = l.ImportName,
                                ImportUid = l.ImportUid,

                                IsView = l.ISVIEW == 1 ? true : false
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("PassingGoodsRepository GetDetailForSecurity: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string CheckOut(int masterId, string userId)
        {
            try
            {
                var goods = _db.PassingGoodsMaster.Where(i => i.Id == masterId).FirstOrDefault();
                if (goods == null)
                    return "Empty";
                goods.ExportDate = DateTime.Now;
                goods.ExportUid = userId;

                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository CheckOut: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.Message + " Inner Exception: " + ex.InnerException.Message;
            }
        }
        public string Import(List<PassingGoodsDetailModel> list, string userId)
        {
            try
            {
                if (list == null)
                    return "Empty";
                foreach (var item in list)
                {
                    var goods = _db.PassingGoodsDetail.Where(i => i.Id == item.Id).FirstOrDefault();
                    if (goods == null)
                        continue;
                    goods.ImportDate = DateTime.Now;
                    goods.ImportUid = userId;
                }

                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository Import: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.Message + " Inner Exception: " + ex.InnerException.Message;
            }
        }
        #endregion

    }
}