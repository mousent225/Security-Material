using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;

namespace SSO_Material.Repositories.SecurityApplication
{
    public class VisitorApplicationMasterRepository
    {
        PortalEntities _db = new PortalEntities();
        #region Visitor Application Master
        public List<VisitorApplicationMasterModel> GetAll(int? id, DateTime? fromDate, DateTime? toDate, int? applicationType, string userId, string approvalStatus)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_MASTER_GET(id, fromDate, toDate, applicationType, userId, approvalStatus)
                            select new VisitorApplicationMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                PhoneNumber = l.PhoneNumber,
                                HandPhoneNumber = l.HandPhoneNumber,

                                Purpose = l.Purpose.ToString(),
                                PurposeName = l.PurposeName,
                                Gate = l.Gate.ToString(),
                                GateName = l.GateName,
                                ApplicationType = l.ApplicationType,
                                ApplicationTypeName = l.ApplicationTypeName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,

                                ApprovalKind = l.ApprovalKind.ToString(),
                                ApprovalKindName = l.KindName,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalLine = l.ApprovalLine,
                                ApprovalStatus = l.ApprovalStatus.ToString(),
                                ApprovalStatusName = l.ApprovalStatusName,
                                NextApprover = l.NextApprover,
                                NextApproverName = l.NextApproverName,
                                ConfirmDate = l.ConfirmDate,

                                Location = l.Location,
                                LocationName = l.LocationName,
                                LocationOther = l.LocationOther,

                                Vendor = l.Vendor,
                                VendorName = l.CompanyName,
                                ContactPerson = l.ContactPerson,
                                ContactNumber = l.ContactPhone,
                                ContactEmail = l.ContactEmail,
                                VendorAddress = l.VendorAddress,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                IsView = l.ISVIEW != 0
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.IdEncrypt = Util.Encrypt(item.Id.ToString() + "_" + item.ApplicationType.ToString() + "_" + string.Format("hhss", DateTime.Now));
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VisitorApplicationMasterModel> GetForSecurity(int? id, DateTime? fromDate, DateTime? toDate, int? applicationType, string approvalStatus, string userId)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_MASTER_GET_FOR_SECURITY(id, fromDate, toDate, applicationType, approvalStatus, userId)
                            select new VisitorApplicationMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                PhoneNumber = l.PhoneNumber,
                                HandPhoneNumber = l.HandPhoneNumber,

                                Purpose = l.Purpose.ToString(),
                                PurposeName = l.PurposeName,
                                Gate = l.Gate.ToString(),
                                GateName = l.GateName,
                                ApplicationType = l.ApplicationType,
                                ApplicationTypeName = l.ApplicationTypeName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,

                                ApprovalKind = l.ApprovalKind.ToString(),
                                ApprovalKindName = l.KindName,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalLine = l.ApprovalLine,
                                ApprovalStatus = l.ApprovalStatus.ToString(),
                                ApprovalStatusName = l.ApprovalStatusName,
                                NextApprover = l.NextApprover,
                                NextApproverName = l.NextApproverName,
                                ConfirmDate = l.ConfirmDate,

                                Location = l.Location,
                                LocationName = l.LocationName,
                                LocationOther = l.LocationOther,

                                Vendor = l.Vendor,
                                VendorName = l.CompanyName,
                                ContactPerson = l.ContactPerson,
                                ContactNumber = l.ContactPhone,
                                ContactEmail = l.ContactEmail,
                                VendorAddress = l.VendorAddress,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                TermsOfUse = l.TermsOfUse ?? false,
                                IsView = l.ISVIEW != 0
                            }).ToList();
                foreach (var item in list)
                {
                    item.IdEncrypt = Util.Encrypt(item.Id.ToString() + "_" + item.ApplicationType.ToString() + "_" + string.Format("hhss", DateTime.Now));
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetForSecurity: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VisitorApplicationMasterModel> GetForIssued( DateTime? fromDate, DateTime? toDate, string userId)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_MASTER_ISSUED_GET(fromDate, toDate, userId)
                            select new VisitorApplicationMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                PhoneNumber = l.PhoneNumber,
                                HandPhoneNumber = l.HandPhoneNumber,

                                Purpose = l.Purpose.ToString(),
                                PurposeName = l.PurposeName,
                                Gate = l.Gate.ToString(),
                                ApplicationType = l.ApplicationType,
                                ApplicationTypeName = l.ApplicationTypeName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,

                                Location = l.Location,
                                LocationName = l.LocationName,
                                LocationOther = l.LocationOther,

                                Vendor = l.Vendor,
                                VendorName = l.CompanyName,
                                ContactPerson = l.ContactPerson,
                                ContactNumber = l.ContactPhone,
                                ContactEmail = l.ContactEmail,
                                VendorAddress = l.VendorAddress,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                TotalVisitor = l.TotalVisitor,
                                TotalVehicle = l.ToTalVehicle,
                                NumIssuedVehicle = l.NumIssuedVehicle,
                                NumIssuedVisitor = l.NumIssuedVisitor,

                                IsSendMail = l.IsSendMail ?? false
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    item.IdEncrypt = Util.Encrypt(item.Id.ToString() + "_" + item.ApplicationType.ToString() + "_" + string.Format("hhss", DateTime.Now));
                }
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public VisitorApplicationMasterModel GetMasterDetail(int id, string userId)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_MASTER_GETDETAIL(id, userId)
                            select new VisitorApplicationMasterModel()
                            {
                                Id = l.Id,
                                Code = l.Code,

                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                PhoneNumber = l.PhoneNumber,
                                HandPhoneNumber = l.HandPhoneNumber,

                                Purpose = l.Purpose.ToString(),
                                PurposeName = l.PurposeName,
                                Gate = l.Gate.ToString(),
                                GateName = l.GateName,
                                ApplicationType = l.ApplicationType,
                                ApplicationTypeName = l.ApplicationTypeName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                Remark = l.Remark,

                                ApprovalKind = l.ApprovalKind.ToString(),
                                ApprovalKindName = l.KindName,
                                ApprovalLineJson = l.ApprovalLineJson,
                                ApprovalLine = l.ApprovalLine,
                                ApprovalStatus = l.ApprovalStatus.ToString(),
                                ApprovalStatusName = l.ApprovalStatusName,
                                NextApprover = l.NextApprover,
                                NextApproverName = l.NextApproverName,
                                ConfirmDate = l.ConfirmDate,

                                Location = l.Location,
                                LocationName = l.LocationName,
                                LocationOther = l.LocationOther,
                                LocationDeptName = l.LocationDeptName,

                                Vendor = l.Vendor,
                                VendorName = l.CompanyName,
                                ContactPerson = l.ContactPerson,
                                ContactNumber = l.ContactPhone,
                                ContactEmail = l.ContactEmail,
                                VendorAddress = l.VendorAddress,

                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectionName = l.SectName,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                IsRecall = l.IsRecall ?? false
                            }).FirstOrDefault();

                list.IdEncrypt = Util.Encrypt(list.Id.ToString() + "_" + list.ApplicationType.ToString() + "_" + string.Format("hhss", DateTime.Now));
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetDetail: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public int ApplicationMasterInsert(VisitorApplicationMasterModel model, string userId)
        {
            try
            {
                var result = (_db.SP_VISITOR_APPLICATION_MASTER_INSERT(model.DeptId, model.Applicant, model.PhoneNumber, model.HandPhoneNumber, model.ApplicationType,
                                                                        model.Vendor, model.Purpose, model.FromDate, model.ToDate, model.Gate, model.Location, model.LocationOther, model.Remark, userId)).FirstOrDefault();
                return int.Parse(result.ToString());
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationMasterInsert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return 0;
            }
        }
        public string ApplicationMasterCopy(int id, int applicationType, string userId)
        {
            try
            {
                var result = _db.SP_VISITOR_APPLICATION_MASTER_COPY(id, applicationType, userId).FirstOrDefault();
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationMasterCopy: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.Message + " Inner Exception: " + ex.InnerException.Message;
            }
        }
        public string ApplicationMasterUpdate(VisitorApplicationMasterModel model, string userId)
        {
            try
            {
                _db.SP_VISITOR_APPLICATION_MASTER_UPDATE(model.Id, model.DeptId, model.Applicant, model.PhoneNumber, model.HandPhoneNumber, model.ApplicationType,
                                                                        model.Vendor, model.Purpose, model.FromDate, model.ToDate, model.Gate, model.Location, model.LocationOther, model.Remark, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationMasterUpdate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        public string ApplicationMasterUpdateAll(VisitorApplicationMasterModel model, string userId)
        {
            try
            {
                _db.SP_VISITOR_APPLICATION_MASTER_UPDATE_ALLDATA(model.Id, model.ApplicationType, model.ApprovalLine, model.ApprovalLineJson, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationMasterUpdateAll: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        public string ApplicationMasterDelete(int id)
        {
            try
            {
                _db.SP_VISITOR_APPLICATION_MASTER_DELETE(id);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationMasterDelete: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        public string ApplicationMasterDeleteUpdate(int id, string userId)
        {
            try
            {
                var item = (from d in _db.VisitorApplicationMaster
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
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationDelete: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion
        #region Detail

        //public VisitorApplicationDetailPerson GetPersonInfor(string identity)
        //{
        //    try
        //    {
        //        var item = _db.VisitorApplicationDetailPerson.Where(i => i.IdentityCard == identity && i.DeleteUid == null).FirstOrDefault();
        //        if (item == null)
        //            return null;
        //        var person = new VisitorApplicationDetailPerson()
        //        {
        //            IdentityCard = item.IdentityCard,
        //            FullName = item.FullName,
        //            PhoneNumber = item.PhoneNumber
        //        };
        //        return person;
        //    }
        //    catch (Exception ex)
        //    {
        //        LogHelper.Error("VisitorApplicationMasterRepository GetPersonInfor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
        //        return null;
        //    }
        //}

        public List<VisitorApplicationDetailModel> GetDetail(int? applicationMasterId, int? Id)
        {
            if (applicationMasterId == 0)
                return null;
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_DETAIL_GET(applicationMasterId, Id)
                            select new VisitorApplicationDetailModel()
                            {
                                Id = l.Id,
                                ApplicationMaster = l.ApplicationMaster,
                                Image = l.Image,
                                FullName = l.FullName,
                                IdentityCard = l.IdentityCard,
                                PhoneNumber = l.PhoneNumber,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                IsWorkHourOfficial = l.IsWorkHourOfficial ?? true,
                                IsWorkHourOfficialName = l.IsWorkHourOfficialName,

                                VisitorCard = l.VisitorCard,
                                IssuedDate = l.IssuedDate,
                                IssuedUid = l.IssuedUid,

                                OtherCode = l.Code
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetDetail: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VisitorApplicationDetailModel> GetDetailVehicle(int? applicationMasterId, int? Id)
        {
            if (applicationMasterId == 0)
                return null;
            try
            {
                var list = (from l in _db.SP_VISITOR_APPLICATION_DETAIL_VEHICLE_GET(applicationMasterId, Id)
                            select new VisitorApplicationDetailModel()
                            {
                                Id = l.Id,
                                ApplicationMaster = l.ApplicationMaster,
                                VehicleType = l.VehicleType.ToString(),
                                VehicleTypeName = l.VehicleTypeName,
                                DriverPlate = l.DriverPlate,
                                PhoneDriver = l.PhoneDriver,
                                DriverName = l.DriverName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                VehicleCard = l.VehicleCard,
                                IssuedDate = l.IssuedDate,
                                IssuedUid = l.IssuedUid,

                                OtherCode = l.Code
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetDetailVehicle: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VisitorApplicationDetailModel> GetListViaVendor(int? id,string identityCard , int? vendorId, DateTime fromDate, DateTime toDate)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_GET(id, identityCard, vendorId, fromDate, toDate)
                            select new VisitorApplicationDetailModel()
                            {
                                Id = l.Id,
                                ApplicationMaster = l.ApplicationMaster,
                                //Image = l.Image,
                                FullName = l.FullName,
                                IdentityCard = l.IdentityCard,
                                PhoneNumber = l.PhoneNumber,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                IsWorkHourOfficial = l.IsWorkHourOfficial ?? true,
                                
                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate,

                                VendorId = l.Vendor ?? 0,
                                VendorName = l.CompanyName
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetDetail: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string DetailInsert(VisitorApplicationDetailModel model, string userId)
        {
            try
            {
                var result = (from i in _db.SP_VISITOR_APPLICATION_DETAIL_INSERT(model.ApplicationMaster, model.Image, model.FullName, model.IdentityCard, model.PhoneNumber,
                                                    model.FromDate, model.ToDate, model.DriverPlate, model.VehicleType, model.IsWorkHourOfficial, model.PhoneDriver, model.DriverName, userId)
                              select i).FirstOrDefault();
                if (result != "" && result.IndexOf('|') != -1)
                {
                    var code = result.Split('|')[1];
                    result = Util.Encrypt(result.Split('|')[0]) + "|" + result.Split('|')[1] + "|" + result.Split('|')[2];
                    
                    var applicationType = result.Split('|')[1].IndexOf("_ST_") == -1 ? 9 : 8;

                    result = result.Split('|')[2].Replace(code,"<a style='color: blue' href='javascript:void(0);' onclick='fnShowDetailView(&apos; "+result.Split('|')[0]+"&apos; , &apos; "+ applicationType + "&apos; )' > {{" + result.Split('|')[1] + "}} </a>");
                    
                }
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository DetailInsert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }

        public string InsertMulti(List<VisitorApplicationDetailModel> list, string userId)
        {
            try
            {
                var lastResult = "";
                foreach (var model in list)
                {
                    var result = (from i in _db.SP_VISITOR_APPLICATION_DETAIL_INSERT(model.ApplicationMaster, model.Image, model.FullName, model.IdentityCard, model.PhoneNumber,
                                                    model.FromDate, model.ToDate, model.DriverPlate, model.VehicleType, model.IsWorkHourOfficial, model.PhoneDriver, model.DriverName, userId)
                                  select i).FirstOrDefault();
                    if (result != "" && result.IndexOf('|') != -1)
                    {
                        var code = result.Split('|')[1];
                        result = Util.Encrypt(result.Split('|')[0]) + "|" + result.Split('|')[1] + "|" + result.Split('|')[2];
                        
                        var applicationType = result.Split('|')[1].IndexOf("_ST_") == -1 ? 9 : 8;

                        result = result.Split('|')[2].Replace(code, "<a style='color: blue' href='javascript:void(0);' onclick='fnShowDetailView(&apos; " + result.Split('|')[0] + "&apos; , &apos; " + applicationType + "&apos; )' > {{" + result.Split('|')[1] + "}} </a>");

                    }

                    if (result != "Ok")
                    {
                        lastResult = (lastResult == "" ? result : (lastResult + "<br />" + result));
                        lastResult += "<br/> <b>CLICK ON EACH DOC NO TO VIEW DETAIL</b>";
                    }
                    
                }
                return lastResult == "" ? "Ok" : lastResult;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository InsertMulti: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }


        public string DetailUpdate(VisitorApplicationDetailModel model, string userId)
        {
            try
            {
                var result = (from i in _db.SP_VISITOR_APPLICATION_DETAIL_UPDATE(model.Id, model.ApplicationMaster, model.Image, model.FullName, model.IdentityCard, model.PhoneNumber,
                                                    model.FromDate, model.ToDate, model.DriverPlate, model.VehicleType, model.IsWorkHourOfficial, model.PhoneDriver, model.DriverName, userId)
                              select i).FirstOrDefault();
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository DetailUpdate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        public string DetailPersonDelete(int[] id, string userId)
        {
            try
            {
                var list = _db.VisitorApplicationDetailPerson.Where(i => id.Contains(i.Id));
                if (list == null)
                    return "Please select visitor to delete";
                foreach (var item in list)
                {
                    item.DeleteDate = DateTime.Now;
                    item.DeleteUid = userId;
                }

                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository DetailPersonDelete: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }       
        public string DetailVehicleDelete(int[] id, string userId)
        {
            try
            {
                var list = _db.VisitorApplicationDetailVehicle.Where(i => id.Contains(i.Id));
                if (list == null)
                    return "Please select vehicle to delete";
                foreach (var item in list)
                {
                    item.DeleteDate = DateTime.Now;
                    item.DeleteUid = userId;
                }
                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository DetailPersonDelete: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }

        
        public string SetSameDate(int masterId, DateTime fromDate, DateTime toDate, string userId)
        {
            try
            {
                var listVehicle = _db.VisitorApplicationDetailVehicle.Where(i => i.ApplicationMaster == masterId);
                if (listVehicle != null)
                {
                    foreach (var item in listVehicle)
                    {
                        item.FromDate = fromDate;
                        item.ToDate = toDate;
                        item.UpdateDate = DateTime.Now;
                        item.UpdateUId = userId;
                    }
                    _db.SaveChanges();
                }

                var listVisitor = _db.VisitorApplicationDetailPerson.Where(i => i.ApplicationMaster == masterId);

                if (listVisitor != null)
                {
                    foreach (var item in listVisitor)
                    {
                        item.FromDate = fromDate;
                        item.ToDate = toDate;
                        item.UpdateDate = DateTime.Now;
                        item.UpdateUId = userId;
                    }
                    _db.SaveChanges();
                }
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository SetSameDate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        #endregion
        #region Vendor
        public List<VendorModel> GetListVendor(int? id, DateTime fromDate, DateTime toDate, string userId, string vendorType)
        {
            try
            {
                var list = (from l in _db.SP_VENDOR_GET(id, userId, fromDate, toDate, vendorType)
                            select new VendorModel()
                            {
                                Id = l.Id,
                                CompanyName = l.CompanyName,
                                Address = l.Address,
                                DeptId = l.DeptId,
                                PersonInCharge = l.PersonInCharge,
                                PersonInChargeName = l.PersonInChargeName,
                                ContactPerson = l.ContactPerson,
                                TaxCode = l.TaxCode,
                                PhoneNumber = l.PhoneNumber,
                                Email = l.Email,
                                IsActive = l.IsActive,
                                CreateUid = l.CreateUid,
                                CreateDate = l.CreateDate,
                                OrgName = l.OrganizationName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectName = l.SectName,
                                CreateName = l.CreateName,
                                TermOfUse = l.TermsOfUse
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository GetListVendor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VendorModel> VendorFind(string value, string vendorType)
        {
            try
            {
                var list = (from l in _db.SP_VENDOR_FIND(value, vendorType)
                            select new VendorModel()
                            {
                                Id = l.Id,
                                CompanyName = l.CompanyName,
                                Address = l.Address,
                                DeptId = l.DeptId,
                                PersonInCharge = l.PersonInCharge,
                                PersonInChargeName = l.PersonInChargeName,
                                ContactPerson = l.ContactPerson,
                                TaxCode = l.TaxCode,
                                PhoneNumber = l.PhoneNumber,
                                Email = l.Email,
                                IsActive = l.IsActive,
                                CreateUid = l.CreateUid,
                                CreateDate = l.CreateDate,
                                OrgName = l.OrganizationName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectName = l.SectName,
                                CreateName = l.CreateName,
                                TermOfUse = l.TermsOfUse
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository VendorFind: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string VendorInsert(VendorModel model, string userId)
        {
            try
            {
                if (model == null)
                    return "Model null";

                var item = (from i in _db.Vendor
                            where i.TaxCode == model.TaxCode && i.DeleteUid == null
                            select i).FirstOrDefault();
                if (item != null)
                    return "This vendor already exists";                

                _db.SP_VENDOR_INSERT(model.CompanyName, model.Address, model.DeptId, model.PersonInCharge, model.ContactPerson, model.TaxCode, model.PhoneNumber, model.Email, model.IsActive, userId, model.VendorType);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository VendorInsert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        public string VendorUpdate(VendorModel model, string userId)
        {
            try
            {
                if (model == null)
                    return "Model null";

                var item = (from i in _db.Vendor
                            where i.TaxCode == model.TaxCode && i.Id != model.Id && i.DeleteUid == null
                            select i).FirstOrDefault();
                if (item != null)
                    return "This vendor already exists";

                _db.SP_VENDOR_UPDATE(model.Id, model.CompanyName, model.Address, model.DeptId, model.PersonInCharge, model.ContactPerson, model.TaxCode, model.PhoneNumber, model.Email, model.IsActive, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository VendorUpdate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }

        public string VendorUpdateTermOfUse(int id, bool isChecked, string userId)
        {
            try
            {
                var item = (from i in _db.Vendor
                            where i.Id == id
                            select i).FirstOrDefault();
                item.TermsOfUse = isChecked;
                item.UpdateDate = DateTime.Now;
                item.UpdateUId = userId;
                _db.SaveChanges();
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository VendorUpdate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }

        public string VendorDelete(int id, string userId)
        {
            try
            {
                var result =  _db.SP_VENDOR_DELETE(id, userId).FirstOrDefault();
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository VendorDelete: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion
        #region Common
        public string GetDefaultApproval(int applicationId)
        {
            try
            {

                var approvalLine = (from l in _db.ApplicationConfig
                                    where l.Id == applicationId
                                    select l.ApprovalLineJson + "|" + l.ApprovalKind.ToString()).FirstOrDefault();
                return approvalLine;

            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationConfigRepository GetDefaultApproval: " + applicationId.ToString() + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public List<ApprovalHistoryModel> ApprovalHistoryGetList(string userId, int applicationId)
        {
            try
            {

                var list = (from d in _db.SP_APPROVAL_HISTORY(userId, applicationId)
                            select new ApprovalHistoryModel()
                            {
                                Id = d.Id,
                                ApprovalLine = d.ApprovalLine,
                                ApprovalLineJson = d.ApprovalLineJson,
                                CreateDate = d.CreateDate,
                                MasterId = d.MasterId,
                                ApplicationMasterName = d.ApplicationMasterName,
                                ApplicationSubject = d.ApplicationSubject,
                                ApplicationId = d.ApplicationId
                            }).ToList();
                if (list == null)
                    return null;
                foreach (var item in list)
                {
                    if (item.ApprovalLine.Split('|').Length == 5)
                    { 
                        item.ApprName = item.ApprovalLine == "" ? "" : item.ApprovalLine.Split('|')[1];
                        item.CirName = item.ApprovalLine == "" ? "" : item.ApprovalLine.Split('|')[4];
                    }
                }
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("ApplicationMasterRepository ApprovalHistoryGetList: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return null;
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
                var list = (from l in _db.SP_VISITOR_APPLICATION_MASTER_APPROVAL_HISTORY(masterId, applicationId)
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
        public string ApplicationConfirm(int id, bool isConfirm, string linkApplication)
        {
            try
            {
                var result = _db.SP_VISITOR_APPLICATION_MASTER_CONFIRM(id, isConfirm, linkApplication);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApplicationConfirm: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        public string ApproveApplication(ApprovalModel model, string userId)
        {
            try
            {
                if (model == null)
                    return "Error: model null";

                var result = _db.SP_VISITOR_APPLICATION_MASTER_APPROVE(model.MasterId, model.ApplicationId, model.IsApprove, model.Comment, userId, model.LinkApplication);
                return "Ok";

            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ApproveApplication: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        public string RecallApplication(int masterId, int applicationId, string userId)
        {
            try
            {

                var result = _db.SP_VISITOR_APPLICATION_MASTER_RECALL(masterId, applicationId, userId);
                return "Ok";

            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository RecallApplication: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion
        #region Container

        public List<ContainerDetailModel> ContainerGetList(int? id, int? masterId)
        {
            try
            {
                var list = (from l in _db.SP_CONTAINER_GET(id, masterId)
                            select new ContainerDetailModel()
                            {
                                Id = l.Id,
                                MasterId = l.MasterId,
                                TaxCode = l.TaxCode,
                                VendorId = l.VendorId,
                                CompanyName = l.CompanyName,
                                ContainerNum = l.ContainerNum,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                IsImport = l.IsImport,
                                IsImportName = l.IsImportName,
                                OtherCode = l.Code
                            }).ToList();
                return list;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ContainerGetList: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string ContainerInsertMulti(List<ContainerDetailModel> list, string userId)
        {
            try
            {
                var lastResult = "";
                foreach (var model in list)
                {
                    var vendorId = model.VendorId;
                    if (vendorId == 0)
                    {
                        var vendor = _db.Vendor.Where(v => v.TaxCode == model.TaxCode).FirstOrDefault();
                        if (vendor == null)
                        {
                            lastResult = lastResult + model.ContainerNum + ", ";
                            continue;
                        }
                        vendorId = vendor.Id;
                    }
                    var result = (from i in _db.SP_CONTAINER_INSERT(model.MasterId, vendorId, model.ContainerNum, model.FromDate, model.ToDate, model.IsImport, userId)
                                  select i).FirstOrDefault();
                    if (result != "Ok")
                        lastResult = (lastResult == "" ? result : (lastResult + "<br />" + result));
                }
                return lastResult == "" ? "Ok" : lastResult;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ContainerInsert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return "Error: " + ex.Message + " Inner Exception: " + ex.InnerException.Message;
            }
        }
        public string ContainerUpdate(ContainerDetailModel model, string userId)
        {
            try
            {
                var result = _db.SP_CONTAINER_UPDATE(model.Id, model.MasterId, model.VendorId, model.ContainerNum, model.FromDate, model.ToDate, model.IsImport, userId).FirstOrDefault();
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ContainerUpdate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return "Error: " + ex.Message + " Inner Exception: " + ex.InnerException.Message;
            }
        }
        public string ContainerDelete(int[] list, string userId)
        {
            try
            {
                foreach (var item in list)
                {
                    var i = _db.ContainerDetail.Where(c => c.Id == item).FirstOrDefault();
                    if (i == null)
                        continue;
                    i.DeleteUid = userId;
                    i.DeleteDate = DateTime.Now;
                    _db.SaveChanges();
                }
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository ContainerDelete: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return "Error: " + ex.Message + " Inner Exception: " + ex.InnerException.Message ;
            }
        }
        public string ContainerSetSameDate(int masterId, DateTime fromDate, DateTime toDate, string userId)
        {
            try
            {
                var listVehicle = _db.ContainerDetail.Where(i => i.MasterId == masterId);
                if (listVehicle != null)
                {
                    foreach (var item in listVehicle)
                    {
                        item.FromDate = fromDate;
                        item.ToDate = toDate;
                        item.UpdateDate = DateTime.Now;
                        item.UpdateUId = userId;
                    }
                    _db.SaveChanges();
                }
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository SetSameDate: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        #endregion

        #region Card Insuance
        public string CardIssuance(List<VisitorApplicationDetailModel> list, bool isVisitor, string userId)
        {
            try
            {
                if (isVisitor)
                {
                    foreach (var item in list)
                    {
                        var visitor = _db.VisitorApplicationDetailPerson.Where(v => v.Id == item.Id).FirstOrDefault();
                        if (visitor == null)
                            return "Error";
                        visitor.VisitorCard = item.VisitorCard;
                        visitor.IssuedDate = DateTime.Now;
                        visitor.IssuedUid = userId;
                        _db.SaveChanges();
                    }
                }
                else
                {
                    foreach (var item in list)
                    {
                        var vehicle = _db.VisitorApplicationDetailVehicle.Where(v => v.Id == item.Id).FirstOrDefault();
                        if (vehicle == null)
                            return "Error";
                        vehicle.VehicleCard = item.VisitorCard;
                        vehicle.IssuedDate = DateTime.Now;
                        vehicle.IssuedUid = userId;
                        _db.SaveChanges();
                    }
                }
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository CardIssuance: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }

        }
        public string SendMail(int masterId, string userId)
        {
            try
            {
                _db.SP_VISITOR_LONGTERM_SENDMAIL(masterId, userId);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository SendMail: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        public string SendMailVehicle(int masterId, string userId, int type)
        {
            try
            {
                _db.SP_VEHICLE_SENDMAIL(masterId, userId, type);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository SendMail: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.ToString();
            }
        }
        #endregion
        #region Report
        public List<Visitor> Visitor(int? applicationType, DateTime? fromDate, DateTime? toDate, DateTime? workDateFrom, DateTime? workDateTo, int? status)
        {
            try
            {
                var list = (from l in _db.SP_REPORT_VISITOR(applicationType, fromDate, toDate, workDateFrom, workDateTo, status)
                            select new Visitor()
                            {
                                Code = l.CODE,
                                WorkDateIn = l.WorkDateIn,
                                WorkDateOut = l.WorkDateOut,
                                VisitorId = l.VisitorId,
                                IdentityCard = l.IdentityCard,
                                FullName = l.FullName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                CompanyName = l.CompanyName,
                                PhoneNumber = l.PhoneNumber,
                                In = l.IN,
                                Out = l.OUT,
                                GateIn = l.GateIn,
                                GateOut = l.GateOut,
                                RemarkIn = l.RemarkIn,
                                RemarkOut = l.RemarkOut,
                                VisitorCard = l.VisitorCard,
                                CreateDate = l.CreateDate,
                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectName = l.SectName
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository Visitor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public List<Visitor> Vehicle(int? applicationType, DateTime? fromDate, DateTime? toDate, DateTime? workDateFrom, DateTime? workDateTo, int? status)
        {
            try
            {
                var list = (from l in _db.SP_REPORT_VEHICLE(applicationType, fromDate, toDate, workDateFrom, workDateTo, status)
                            select new Visitor()
                            {
                                Code = l.CODE,
                                WorkDateIn = l.WorkDateIn,
                                WorkDateOut = l.WorkDateOut,
                                //VisitorId = l.VisitorId,
                                IdentityCard = l.DriverPlate,
                                //FullName = l.FullName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                CompanyName = l.CompanyName,
                                //PhoneNumber = l.PhoneNumber,
                                In = l.IN,
                                Out = l.OUT,
                                GateIn = l.GateIn,
                                GateOut = l.GateOut,
                                RemarkIn = l.RemarkIn,
                                RemarkOut = l.RemarkOut,
                                VisitorCard = l.VehicleCard,
                                CreateDate = l.CreateDate,
                                Applicant = l.Applicant,
                                ApplicantName = l.ApplicantName,
                                OrgName = l.OrgName,
                                PlantName = l.PlantName,
                                DeptName = l.DeptName,
                                SectName = l.SectName
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorApplicationMasterRepository Visitor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        #endregion
    }
}