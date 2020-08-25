public class Gifup.GifupApp : Gtk.Application {
    private Window window;
    public static Settings settings;

    public GifupApp () {
        Object (
            application_id: "com.github.bharatkalluri.gifup",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {
        settings = new Settings ("com.github.bharatkalluri.gifup");
    }

    public override void activate () {
        int window_x, window_y;
        settings.get ("window-position", "(ii)", out window_x, out window_y);

        window = new Window ();
        window.set_application (this);

        if (window_x != -1 || window_y != -1) { // Not a first time launch
            window.move (window_x, window_y);
        } else { // First time launch
            window.window_position = Gtk.WindowPosition.CENTER;
        }

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
        Gtk.init (ref args);
        Gst.init (ref args);
        var err = GtkClutter.init (ref args);
        if (err != Clutter.InitError.SUCCESS) {
            error ("Could not initalize clutter! "+err.to_string ());
        }
        return app.run (args);
    }
}
