//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Security___Material.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Attachment
    {
        public int AttachId { get; set; }
        public System.Guid ModuleId { get; set; }
        public int MasterId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string FileType { get; set; }
        public Nullable<int> FileSize { get; set; }
    
        public virtual SysCategoryValue SysCategoryValue { get; set; }
    }
}
