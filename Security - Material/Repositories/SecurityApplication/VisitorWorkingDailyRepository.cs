using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.SecurityApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories.SecurityApplication
{
    public class VisitorWorkingDailyRepository
    {
        PortalEntities _db = new PortalEntities();
        #region Visitor
        public List<VisitorWorkingDailyModel> GetListVisitor(int? applicationId, DateTime? workdate, string gateId,  bool? isCheckOut, int? applicationType, string apprStatus, string userId)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_WORKINGDAILY_GET(applicationId, workdate, isCheckOut, gateId, applicationType, userId, apprStatus)
                            select new VisitorWorkingDailyModel()
                            {
                                Code = l.Code,
                                VisitorId = l.Id,
                                VisitorName = l.FullName,
                                IdentityCard = l.IdentityCard,
                                PhoneNumber = l.PhoneNumber,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,

                                WorkHourOfficle = l.IsWorkHourOfficial ?? false,
                                WorkHourOfficleName = l.IsWorkHourOfficialName,
                                VisitorCard = l.VisitorCard,                                

                                Vendor = l.Vendor ?? 0,
                                VendorName = l.CompanyName,
                                TermsOfUse = l.TermsOfUse ?? false,
                                
                                GateIdRegis = l.GateRegis,
                                GateNameRegis = l.GateNameRegis,

                                IsCheckIn = l.IsCheckIn ?? false,
                                NumCheck = l.NumCheck ?? 0,

                                Image = l.Image
                            }).ToList();
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository GetListVisitor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VisitorWorkingDailyDetailModel> GetListDetail(int visitorId)
        {
            try
            {
                var list = (from l in _db.SP_VISITOR_WORKINGDAILY_GET_DETAIL(visitorId)
                            select new VisitorWorkingDailyDetailModel()
                            {
                                Id = l.Id,
                                VisitorId = l.VisitorId,
                                ScanTime = l.ScanTime,
                                IsCheckIn = l.IsCheckIn ?? false,
                                IsCheckInName = l.IsCheckInName,
                                GateId = l.GateId.ToString(),
                                GateName = l.GateName,
                                Remark = l.Remark,
                                VisitorCard = l.VisitorCard,
                                WorkDate = l.WorkDate,
                                
                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository VisitorWorkingDailyDetailModel: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        //public List<VisitorWorkingDailyModel> GetHistory(DateTime fromDate, DateTime toDate, string identityCard)
        //{
        //    try
        //    {
        //        var list = (from l in _db.SP_VISITOR_WORKINGDAILY_GET_HISTORY(fromDate, toDate, identityCard)
        //                    select new VisitorWorkingDailyModel()
        //                    {
        //                        Id = l.Id ?? 0,
        //                        VisitorName = l.FullName,
        //                        IdentityCard = l.IdentityCard,
        //                        PhoneNumber = l.PhoneNumber,
        //                        FromDate = l.FromDate,
        //                        ToDate = l.ToDate,

        //                        WorkHourOfficle = l.IsWorkHourOfficial ?? false,
        //                        Vendor = l.Vendor ?? 0,
        //                        VendorName = l.CompanyName,

        //                        GateIdRegis = l.GateRegis,
        //                        GateNameRegis = l.GateNameRegis,
                                
        //                        GateId = l.GateId.ToString(),
        //                        GateName = l.GateName,
        //                        WorkDate = l.WorkDate,
        //                        TimeIn = l.TimeIn,
        //                        TimeOut = l.TimeOut,
        //                        VisitorCard = l.VisitorCard,

        //                        CreateUid = l.SecrityNameCreate,
        //                        CreateDate = l.CreateDate,

        //                    }).ToList();
        //        return list;

        //    }
        //    catch (Exception ex)
        //    {
        //        LogHelper.Error("VisitorWorkingDailyRepository GetListVisitor: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
        //        return null;
        //    }
        //}

        public string Insert(int visitorId, string visitorCard, string remark, string userId, bool isCheckIn, int applicationType)
        {
            try
            {                
                _db.SP_VISITOR_WORKINGDAILY_INSERT(visitorId, userId, visitorCard, remark, isCheckIn, applicationType);                
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository Insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        public string CheckOff(List<VisitorWorkingDailyModel> list, string userId)
        {
            try
            {
                if (list == null)
                    return "List Empty";
                foreach (var item in list)
                {
                    var vehicle = new VisitorWorkingDaily
                    {
                        VisitorId = item.VisitorId,
                        VisitorCard = item.VisitorCard,
                        WorkDate = DateTime.Now,
                        CreateUid = userId,
                        CreateDate = DateTime.Now
                    };
                    _db.VisitorWorkingDaily.Add(vehicle);
                    _db.SaveChanges();
                }
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository VehicleCheckOff: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion

        #region Vehicle
        public List<VehicleCheckingDailyModel> GetListVehicle(int? applicationId, DateTime? workdate, string gateId, bool? isCheckOut, int? applicationType, string apprStatus, string userId)
        {
            try
            {
                var list = (from l in _db.SP_VEHICLE_CHECKINGDAILY_GET(applicationId, workdate, isCheckOut, gateId, applicationType, userId, apprStatus)
                            select new VehicleCheckingDailyModel()
                            {
                                Code = l.Code,
                                VehicleId = l.Id,
                                DriverPlate = l.DriverPlate,
                                VehicleType = l.VehicleType.ToString(),
                                VehicleTypeName = l.VehicleTypeName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,

                                VehicleCard = l.VehicleCard,
                                DriverName = l.DriverName,
                                PhoneDriver = l.PhoneDriver,

                                Vendor = l.Vendor ?? 0,
                                VendorName = l.CompanyName,
                                TermsOfUse = l.TermsOfUse ?? false,

                                GateIdRegis = l.GateRegis,
                                GateNameRegis = l.GateNameRegis,
                                IsCheckIn = l.IsCheckIn ?? false,
                                ChangeDriver = l.ChangeDriver,
                                NumCheck = l.NumCheck ?? 0

                            }).ToList();
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository GetListVehicle: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VehicleCheckingDailyDetailModel> GetListVehicleDetail(int visitorId)
        {
            try
            {
                var list = (from l in _db.SP_VEHICLE_CHECKINGDAILY_GET_DETAIL(visitorId)
                            select new VehicleCheckingDailyDetailModel()
                            {
                                Id = l.Id,
                                vehicleId = l.VehicleId,
                                ScanTime = l.ScanTime,
                                IsCheckIn = l.IsCheckIn ?? false,
                                IsCheckInName = l.IsCheckInName,
                                GateId = l.GateId.ToString(),
                                GateName = l.GateName,
                                Remark = l.Remark,
                                VehicleCard = l.VehicleCard,
                                WorkDate = l.WorkDate,
                                ChangeDriver = l.ChangeDriver,

                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository VisitorWorkingDailyDetailModel: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<VehicleGetInModel> GetListVehicleCurrent()
        {
            try
            {
                var list = (from l in _db.SP_VEHICLE_GET_IN()
                            select new VehicleGetInModel()
                            {
                                VehicleId = l.VehicleId,
                                DriverPlate = l.DriverPlate,
                                DriverName = l.DriverName,
                                WorkDate = l.WorkDate,
                                ScanTime = l.ScanTime
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository GetListVehicleCurrent: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string VehicleInsert(int vehicleId, string vehicleCard, string remark, string userId, bool isCheckIn, string newDriver)
        {
            try
            {
                _db.SP_VEHICLE_CHECKINGDAILY_INSERT(vehicleId, userId, vehicleCard, remark, isCheckIn, newDriver == "" ? null : newDriver);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository VehicleInsert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }

        public string VehicleCheckOff(List<VehicleCheckingDailyModel> list, string userId)
        {
            try
            {
                if (list == null)
                    return "List Empty";
                foreach (var item in list)
                {
                    var vehicle = new VehicleCheckingDaily
                    {
                        VehicleId = item.VehicleId,
                        VehicleCard = item.VehicleCard,
                        WorkDate = DateTime.Now,
                        //TimeIn = "08:00",
                        //TimeOut = "17:00",
                        CreateUid = userId,
                        CreateDate = DateTime.Now
                    };
                    _db.VehicleCheckingDaily.Add(vehicle);
                    _db.SaveChanges();                    
                }
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository VehicleCheckOff: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }

        #endregion

        #region Container

        public List<ContainerTrackingDailyModel> GetListContainer(int? applicationId, DateTime workDate, string gateId, string userId)
        {
            try
            {
                var list = (from l in _db.SP_CONTAINER_TRACKINGDAILY_GET(applicationId, workDate, gateId, userId)
                            select new ContainerTrackingDailyModel
                            {
                                Id = l.Id,
                                Code = l.Code,
                                ContainerNum = l.ContainerNum,
                                VendorId = l.VendorId,
                                CompanyName = l.CompanyName,
                                FromDate = l.FromDate,
                                ToDate = l.ToDate,
                                IsImport = l.IsImport,
                                IsImportName = l.IsImportName,
                                GateId = l.GateRegis,
                                GateName = l.GateNameRegis,
                                IsCheckIn = l.IsCheckIn ?? false,
                                NumCheck = l.NumCheck ?? 0
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository GetListContainer: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public List<ContainerTrackingDailyDetailModel> GetListContainerDetail(int containerId)
        {
            try
            {
                var list = (from l in _db.SP_CONTAINER_TRACKINGDAILY_GET_DETAIL(containerId)
                            select new ContainerTrackingDailyDetailModel
                            {
                                Id = l.Id,
                                ContainerId = l.ContainerId,
                                ContainerNum = l.ContainerNum,
                                WorkDate = l.WorkDate,
                                ScanTime = l.ScanTime,
                                IsCheckIn = l.IsCheckIn,
                                IsCheckinName = l.IsCheckInName,
                                GateId = l.GateId.ToString(),
                                GateName = l.GateName,
                                Remark = l.Remark,
                                VehicleId = l.VehicleId,
                                VehiclePlate = l.DriverPlate,
                                DriverName = l.DriverName,
                                CreateUid = l.CreateUid,
                                CreateName = l.CreateName,
                                CreateDate = l.CreateDate
                            }).ToList();
                return list;
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository GetListContainer: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
        public string ContainerTrackingInsert(int containerId, int vehicleId, string remark, bool isCheckIn, string userId)
        {
            try
            {
                var result = _db.SP_CONTAINER_TRACKINGDAILY_INSERT(containerId, userId, vehicleId, remark, isCheckIn);
                return "Ok";
            }
            catch (Exception ex)
            {
                LogHelper.Error("VisitorWorkingDailyRepository ContainerTrackingInsert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return ex.InnerException.Message;
            }
        }
        #endregion
    }
}