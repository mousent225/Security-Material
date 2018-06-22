using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels
{
    public class CategoryValueModel
    {
        public Guid ID { get; set; }
        [Display(Name = "Name")]
        [Required(ErrorMessage = "Required")]
        public string Name { get; set; }
        [Display(Name = "Dictionary")]
        public Guid? Dictionary { get; set; }

        [Display(Name = "Dictionary")]
        public string DictionaryName { get; set; }
        [Display(Name = "Seq")]
        public byte? Sequence { get; set; }
        [Display(Name = "Actived")]
        public bool Actived { get; set; }

        public Guid Category { get; set; }
        [Display(Name = "CategoryName")]
        public string CategoryName { get; set; }

        public Guid? ParentID { get; set; }
        [Display(Name = "Parent")]
        public string ParentName { get; set; }
        [Display(Name = "Remark")]
        public string RemarkValue { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreateUID { get; set; }
        [Display(Name = "ModifyDate")]
        public DateTime? ModifyDate { get; set; }
        [Display(Name = "ModifyUser")]
        public string ModifyUID { get; set; }

        public string ModifyName { get; set; }
        public bool? Deleted { get; set; }
        public DateTime? DeleteDate { get; set; }
        public string DeleteUID { get; set; }
        [Display(Name = "SubCode")]
        public string SubCode { get; set; }

        public bool HasChild { get; set; }
    }
}