using Gtk;

namespace Gifup { 
    class GifupApp : Granite.Application {
        private Window window;
        construct {
            //a full list of fields can be found at
            //https://valadoc.org/granite/Granite.Application.html
            program_name = "Gifup";
            exec_name = "gifup";
            app_years = "2016";
            app_launcher =  "com.github.bharatkalluri.gifup.desktop";
            application_id = "com.github.bharatkalluri.gifup";
            about_license_type = Gtk.License.GPL_3_0;
            about_comments = "The best GIF maker for elementary OS.";
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.textdomain ("com.github.bharatkalluri.gifup");
        }
        
        public override void activate () {
            window = new Window ();
        }

        public static int main (string [] args) {
            var app = new GifupApp ();
            return app.run (args);
        }
    }
}
