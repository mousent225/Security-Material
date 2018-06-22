using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories
{
    public class UserRepository
    {
        PortalEntities _db = new PortalEntities();
        public UserModel Login(LoginModel model)
        {
            try
            {
                var item = (from u in _db.SP_SYS_USER_LOGIN(model.LoginID, model.Password)
                            select new UserModel()
                            {
                                LoginID = u.Code,
                                Name = u.LocalName,
                                Email = u.Email ?? "",
                                EmpId = u.EmpId,
                                ImgBinary = u.Img,
                                DeptId = u.DeptCode,
                                DeptName = u.DeptFullName,
                                Status = u.uStatus,
                                RoleId = u.RoleId,
                                RoleName = u.RoleName,
                                Password = u.Password,
                                Posistion = u.PositionName,
                                JobTitle = u.JobTitle,
                                JoinDate = u.JoinDate
                            }).FirstOrDefault();

                if (item == null)
                {
                    item = (from u in _db.SP_SYS_USER_LOGIN_GUARD(model.LoginID, model.Password)
                            select new UserModel()
                            {
                                LoginID = u.Code,
                                Name = u.LocalName,
                                Email = u.Email ?? "",
                                EmpId = u.EmpId,
                                ImgBinary = u.Img,
                                DeptId = u.DeptCode,
                                DeptName = u.DeptFullName,
                                Status = u.uStatus,
                                RoleId = u.RoleId,
                                RoleName = u.RoleName,
                                Password = u.Password,
                                Posistion = u.PositionName,
                                JobTitle = u.JobTitle,
                                JoinDate = u.JoinDate
                            }).FirstOrDefault();
                }
                if (item == null)
                    return null;
                if(item.ImgBinary != null)
                    item.Img = Util.ScaleImage(item.ImgBinary);
                return item;
            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository: Login: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public UserModel GetUser(string id)
        {
            try
            {
                var item = (from u in _db.SysUser
                            from u1 in _db.SysUser.Where(u1 => u1.LoginID == u.CreateUid || u1.LoginID == u.UpdateUid).DefaultIfEmpty()
                            where u.Deleted == false && u.LoginID == id
                            select new UserModel
                            {
                                LoginID = u.LoginID,
                                Password = u.Password,
                                //IMG = u.IMG,
                                Name = u.Name,
                                Email = u.Email,
                                Mobile = u.Mobile,
                                Actived = u.Actived,
                                ModifyDate = u.UpdateDate ?? u.CreateDate,
                                ModifyUID = u.UpdateUid ?? u.CreateUid,
                                ModifyName = u1.Name
                            }).FirstOrDefault();

                return item;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository: GetUser: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public IEnumerable<EmployeeInfor> GetEmployeeInfor(string empId, string empName)
        {
            try
            {
                var item = (from u in _db.SP_EMPLOYEE_INFOR(empName, empId)
                            select new EmployeeInfor
                            {
                                //ID = u.,
                                EmpId = u.Code,
                                EmpName = u.LocalName,
                                DeptId = u.DeptId,
                                DeptName = u.DeptName,
                                CostCenter = u.Costcenter
                            }).ToList();

                return item;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository: GetEmployeeInfor: " + ex.Message + " Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public bool CheckExists(UserModel model)
        {
            throw new NotImplementedException();
        }

        public bool InsertUser(UserModel model)
        {
            if (model == null)
                return false;
            try
            {
                var user = new SysUser()
                {

                    //user.ID = Guid.NewGuid();
                    LoginID = model.LoginID,
                    Password = ED5Helper.Encrypt(model.Password),
                    Name = model.Name,
                    Email = model.Email,
                    Mobile = model.Mobile,
                    CreateUid = model.ModifyUID,
                    CreateDate = DateTime.Now,
                    Deleted = false,
                    Actived = true
                };
                _db.SysUser.Add(user);
                _db.SaveChanges();
                return true;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository:InsertUser: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public bool UpdateUser(UserModel model)
        {
            if (model == null)
                return false;
            try
            {

                var user = (from u in _db.SysUser where u.LoginID == model.LoginID select u).FirstOrDefault();
                user.Name = model.Name;
                user.Email = model.Email;
                user.Mobile = model.Mobile;
                user.UpdateUid = model.ModifyUID;
                user.UpdateDate = DateTime.Now;
                user.Actived = model.Actived;
                if (model.PasswordNew != null)
                    user.Password = ED5Helper.Encrypt(model.PasswordNew); ;
                _db.SaveChanges();
                return true;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository:UpdateUser: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public bool ResetPassword(string loginId)
        {
            var list = loginId.Split(';');
            try
            {

                foreach (var login in list)
                {
                    if (string.IsNullOrEmpty(login))
                        continue;
                    var user = (from u in _db.HrEmpMaster where u.Code == login select u).FirstOrDefault();
                    user.Password = loginId;
                    user.uStatus = new Guid(AppDictionary.UserStatus.FirstOrDefault(a => a.Key == "Reset").Value);
                    _db.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository:UpdateUser: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public bool DeleteUser(UserModel model)
        {
            if (model == null)
                return false;
            try
            {
                var user = (from u in _db.SysUser where u.LoginID == model.LoginID select u).FirstOrDefault();
                user.DeleteUid = model.ModifyUID;
                user.DeleteDate = DateTime.Now;
                user.Deleted = true;
                _db.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository:UpdateUser: " + ex.Message);
                return false;
            }
        }

        public string GetPassword(string empId)
        {

            var user = (from u in _db.HrEmpMaster where u.Code.ToLower() == empId.ToLower() select u).FirstOrDefault();
            if (user == null)
                return "";
            return user.Password;
        }

        public string GetStatus(string empId)
        {
            var user = (from u in _db.HrEmpMaster where u.Code.ToLower() == empId.ToLower() select u).FirstOrDefault();
            if (user != null)
                return user.uStatus.ToString();

            var guard = (from g in _db.Guard where g.GuardId.ToLower() == empId.ToLower() select g).FirstOrDefault();
            if (guard == null)
                return "";
            else
                return "beb23056-8602-4da6-9fa8-ee29f86381a7";
        }

        public bool ChangePassword(string empId, string pass)
        {
            var active = new Guid(AppDictionary.UserStatus.FirstOrDefault(d => d.Key == "Active").Value);
            try
            {
                var item = _db.HrEmpMaster.FirstOrDefault(i => i.Code.ToLower() == empId.ToLower());
                if (item == null)
                    return false;
                item.Password = pass;
                item.uStatus = active;
                item.UpdateDate = DateTime.Now;
                _db.SaveChanges();
                return true;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository:UpdatePassword: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }
        //cập nhật password cho nhân viên mới
        public int UpdatePassword()
        {
            var resetPass = new Guid(AppDictionary.UserStatus.FirstOrDefault(d => d.Key == "Reset").Value);
            var newUser = new Guid(AppDictionary.UserStatus.FirstOrDefault(d => d.Key == "New").Value);
            try
            {

                var list = _db.HrEmpMaster.Where(e => e.uStatus == newUser).ToList();
                list.ForEach(l =>
                {
                    l.uStatus = resetPass;
                    l.Password = ED5Helper.Encrypt(l.Code);
                });
                _db.SaveChanges();
                return list.Count;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository: UpdatePassword: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return -1;
            }
        }

        public IEnumerable<DepartmentModel> GetListDept(int deptId)
        {
            try
            {

                var list = (from u in _db.SP_SYS_DEPT_GET_TREE(deptId)
                            select new DepartmentModel
                            {
                                id = u.ID ?? 0,
                                Name = u.NAME,
                                parentid = u.PARENTID,
                                ParentName = u.NAME
                            }).ToList();
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository GetListDept: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public IEnumerable<DepartmentModel> GetListMailGroup(int deptId, string deptName)
        {
            try
            {

                var list = (from u in _db.SP_SYS_GET_MAIL_GROUP(deptId, deptName)
                            select new DepartmentModel
                            {
                                OrganizeName = u.OrganizationName,
                                PlantName = u.PlantName,
                                DeptName = u.DeptName,
                                SectionName = u.SectName,
                                Name = u.NAME,
                                MailGroup = u.MAILGROUP,
                                KoName = u.KONAME
                            }).ToList();
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository GetListMailGroup: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public IEnumerable<ListMail> GetListMail(int searchType, string empId, string empName, string sex, string nation, int deptId, bool hasEmail)
        {
            try
            {

                var list = (from u in _db.SP_SYS_MAIL_LIST(searchType, empId, empName, sex, nation, deptId, hasEmail)
                            select new ListMail
                            {
                                OrganizeName = u.OrganizationName,
                                PlantName = u.PlantName,
                                DeptName = u.DeptName,
                                SectionName = u.SectName,
                                EmpId = u.Code,
                                EmpName = u.LocalName,
                                Email = u.Email
                            }).ToList();
                return list;

            }
            catch (Exception ex)
            {
                LogHelper.Error("UserRepository GetListMailGroup: " + ex.Message + " Inner exception: " + ex.InnerException.Message);
                return null;
            }
        }

    }
}