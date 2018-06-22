using System.Web;
using System.Web.Optimization;

namespace SSO_Material
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            //bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
            //            "~/Scripts/common/jquery-{version}.js"));
            //bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
            //            "~/Scripts/common/jquery.validate*"));
            bundles.Add(new ScriptBundle("~/bundles/common").Include(
                        "~/Content/assets/js/libs/bootstrap/bootstrap.min.js",
                        "~/Content/assets/js/libs/autosize/jquery.autosize.min.js",
                         "~/Content/assets/js/libs/jquery/jquery-1.11.2.min.js",
                         "~/Content/assets/js/libs/jquery/jquery-migrate-1.2.1.min.js",
                         "~/Content/assets/js/libs/spin.js/spin.min.js",
                         "~/Content/assets/js/libs/autosize/jquery.autosize.min.js",
                         "~/Content/assets/js/libs/moment/moment.min.js",
                         "~/Content/assets/js/libs/jquery-validation/dist/jquery.validate.min.js",
                         "~/Content/assets/js/libs/jquery-validation/dist/additional-methods.min.js",
                         "~/Content/assets/js/libs/bootstrap-datepicker/bootstrap-datepicker.js",
                         "~/Content/assets/js/libs/bootstrap-tagsinput/bootstrap-tagsinput.min.js",
                         "~/Content/assets/js/libs/wizard/jquery.bootstrap.wizard.min.js",
                         "~/Scripts/dropzone/dropzone.min.js",
                        "~/Content/assets/js/libs/inputmask/jquery.inputmask.bundle.min.js",
                         "~/Content/assets/js/libs/flot/jquery.flot.min.js",
                         "~/Content/assets/js/libs/flot/jquery.flot.time.min.js",
                         "~/Content/assets/js/libs/flot/jquery.flot.resize.min.js",
                         "~/Content/assets/js/libs/flot/jquery.flot.orderBars.js",
                         //"~/Content/assets/js/libs/flot/jquery.flot.pie.js",
                         //"~/Content/assets/js/libs/flot/curvedLines.js",
                         "~/Content/assets/js/libs/jquery-knob/jquery.knob.min.js",
                         //"~/Content/assets/js/libs/sparkline/jquery.sparkline.min.js",
                         "~/Content/assets/js/libs/nanoscroller/jquery.nanoscroller.min.js",
                         "~/Content/assets/js/libs/d3/d3.min.js",
                         //"~/Content/assets/js/libs/d3/d3.v3.js",
                         //"~/Content/assets/js/libs/rickshaw/rickshaw.min.js",
                         "~/Content/assets/js/core/source/App.js",
                         "~/Content/assets/js/core/source/AppNavigation.js",
                         //"~/Content/assets/js/core/source/AppOffcanvas.js",
                         "~/Content/assets/js/core/source/AppCard.js",
                         "~/Content/assets/js/core/source/AppForm.js",
                         "~/Content/assets/js/core/source/AppNavSearch.js"
                         //"~/Content/assets/js/core/source/AppVendor.js"
                         //"~/Content/assets/js/core/demo/Demo.js"
                         //,"~/Content/assets/js/core/demo/DemoDashboard.js"
                         ));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            //bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
            //            "~/Scripts/modernizr-*"));

            //bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
            //          "~/Scripts/bootstrap.js",
            //          "~/Scripts/respond.js"));

            //bundles.Add(new StyleBundle("~/Content/css").Include(
            //          "~/Content/bootstrap.css",
            //          "~/Content/site.css"));
        }
    }
}
