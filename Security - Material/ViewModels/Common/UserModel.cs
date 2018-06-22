using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels
{
    public class UserModel
    {//public Guid ID { get; set; }
        [Display(Name = "Login ID")]
        public string LoginID { get; set; }
        [Display(Name = "Name")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Required")]
        [EmailAddress(ErrorMessage = "Invalid Email Address!")]
        [Display(Name = "Email")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Required")]
        [Display(Name = "Mobile")]
        [RegularExpression("^[0]{1}[19]{1}[0-9]{8,9}$", ErrorMessage = "Please enter valid phone no.")]
        public string Mobile { get; set; }
        [Display(Name = "Password")]
        public string Password { get; set; }

        public string Img { get; set; }
        public Byte[] ImgBinary { get; set; }
        public bool Actived { get; set; }

        [Display(Name = "Status")]
        public Guid Status { get; set; }

        public string StatusName { get; set; }

        [Display(Name = "Modify Date")]
        public DateTime? ModifyDate { get; set; }
        [Display(Name = "Modify UID")]
        public string ModifyUID { get; set; }
        [Display(Name = "Modify Name")]
        public string ModifyName { get; set; }

        [Required(ErrorMessage = "Required")]
        [Display(Name = "Old Password")]
        public string PasswordOld { get; set; }

        [Required(ErrorMessage = "Required")]
        [Display(Name = "New Password")]
        public string PasswordNew { get; set; }

        [Compare("PasswordNew", ErrorMessage = "The password and confirmation password do not match.")]
        [Display(Name = "Repeat Password")]
        public string PasswordRepeat { get; set; }

        public int DeptId { get; set; }
        public string OrganizeName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectionName { get; set; }
        public string RoleId { get; set; }
        public string EmpId { get; set; }
        public string RoleName { get; set; }
        public string DeptFullName { get; set; }
        public string CostCenter { get; set; }
        public string Posistion { get; set; }
        public string JobTitle { get; set; }
        public string JoinDate { get; set; }

        public string HandPhoneNumber { get; set; }
        public string PhoneNumber { get; set; }
    }

    public class ListMail
    {
        public string OrganizeName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectionName { get; set; }
        public string EmpId { get; set; }
        public string EmpName { get; set; }
        public string Email { get; set; }
    }

    public class EmployeeInfor
    {
        public string EmpId { get; set; }
        public string EmpName { get; set; }
        public int? DeptId { get; set; }
        public string DeptName { get; set; }
        public string CostCenter { get; set; }
    }
}