using Gtk;

namespace Gifup {
    class GifupApp : Gtk.Application {
        private Window window;
        public GifupApp () {
            Object (
                application_id: "com.github.bharatkalluri.gifup",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }
        
        public override void activate () {
            window = new Window ();
            window.set_application (this);
            window.show_all ();

            var quit_action = new SimpleAction ("quit", null);
            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Control>q"});
            quit_action.activate.connect (() => {
                window.destroy ();
            });
        }

        public static int main (string [] args) {
            var app = new GifupApp ();
            return app.run (args);
        }
    }
}
