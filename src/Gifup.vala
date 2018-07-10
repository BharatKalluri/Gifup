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
        }

        public static int main (string [] args) {
            Gst.init (ref args);
            var app = new GifupApp ();
            return app.run (args);
        }
    }
}
