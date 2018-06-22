
namespace SSO_Material.ViewModels.Common
{
    public class AttachmentModel
    {
        public int AttachId { get; set; }
        public string ModuleId { get; set; }
        public int MasterId { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
        public string Type { get; set; }
        public int? Size { get; set; }
    }
}