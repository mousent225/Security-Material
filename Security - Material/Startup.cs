using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SSO_Material.Startup))]
namespace SSO_Material
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            app.MapSignalR();
        }
    }
}
