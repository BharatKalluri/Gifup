public class Gifup.Window : Gtk.ApplicationWindow {
    public static string selected_dir { get; private set; }
    private uint configure_id;

    // Init all UI elements
    private BasicOptions grid_basic;

    private Gtk.Button gif_button;
    private Gtk.Button complete_gif;
    private string selected_file;

    public Window () {
        Object (
            resizable: false
        );
    }

    construct {
        // Header Bar
        var headerbar = new Gtk.HeaderBar ();
        headerbar.title = _("Gifup");
        headerbar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        headerbar.show_close_button = true;
        headerbar.has_subtitle = false;
        this.set_titlebar (headerbar);

        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.column_spacing = 6;
        grid.row_spacing = 12;
        grid.hexpand = true;
        grid.margin_start = 12;
        grid.margin_end = 12;
        grid.margin_top = 12;
        grid.margin_bottom = 12;

        //File Open button row 0
        var file_button = new Gtk.FileChooserButton (_("Open your favourite file"), Gtk.FileChooserAction.OPEN);
        file_button.margin_top = 10;
        file_button.margin_start = 10;
        file_button.margin_end = 10;
        grid.add (Gifup.Utils.create_left_label (_("Select video:")));
        grid.add (file_button);
        // File open button events
        file_button.selection_changed.connect (() => {
            selected_file = file_button.get_filename ();
            grid_basic.selected_file = selected_file;
            if (selected_dir != null) {
                gif_button.sensitive = true;
                complete_gif.sensitive = true;
            }
        });

        var save_dir_button = new Gtk.FileChooserButton ("Select save directory", Gtk.FileChooserAction.SELECT_FOLDER);
        save_dir_button.margin_top = 10;
        save_dir_button.margin_start = 10;
        save_dir_button.margin_end = 10;
        grid.add (Gifup.Utils.create_left_label (_("Select save directory:")));
        grid.add (save_dir_button);
        // File open button events
        save_dir_button.selection_changed.connect (() => {
            selected_dir = save_dir_button.get_filename ();
            if (selected_file != null) {
                gif_button.sensitive = true;
                complete_gif.sensitive = true;
            }
        });


        // A stack to row 1
        var stack = new Gtk.Stack ();
        stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

        grid_basic = new BasicOptions ();
        stack.add_titled (grid_basic, "Basic", _("Basic Options"));
        var grid_advance = new AdvanceOptions ();
        stack.add_titled (grid_advance, "Advanced", _("Advanced Options"));

        Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.homogeneous = true;
        stack_switcher.set_stack (stack);

        grid.add (stack_switcher);
        grid.add (stack);

        // A spinner to indicate program is working
        var spinner = new Gtk.Spinner ();
        grid.add (spinner);

        //  Button For making GIF at row 6 of grid_advance
        gif_button = new Gtk.Button.with_label (_("Make GIF!"));
        gif_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        gif_button.margin_start = 12;
        gif_button.margin_end = 12;
        gif_button.sensitive = false;
        grid.add (gif_button);
        // Event for gif create button
        gif_button.clicked.connect (() => {
            Gifup.Utils.gif_create (selected_file, grid_basic.entry_end, grid_basic.entry_start, grid_advance.entry_fps, grid_advance.entry_height, grid_advance.entry_width , spinner);
            spinner.active = true;
        });

        complete_gif = new Gtk.Button.with_label (_("Convert Complete Video"));
        complete_gif.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        complete_gif.margin_start = 12;
        complete_gif.margin_end = 12;
        complete_gif.margin_bottom = 12;
        complete_gif.sensitive = false;
        grid.add (complete_gif);
        // Event for complete gif create button
        complete_gif.clicked.connect (() => {
            Gifup.Utils.complete_gif_create (selected_file, grid_advance.entry_fps, grid_advance.entry_height, grid_advance.entry_width, spinner);
            spinner.active = true;
        });

        add (grid);
    }

    protected override bool configure_event (Gdk.EventConfigure event) {
        if (configure_id != 0) {
            GLib.Source.remove (configure_id);
        }

        configure_id = Timeout.add (100, () => {
            configure_id = 0;
            int x, y;
            get_position (out x, out y);
            GifupApp.settings.set ("window-position", "(ii)", x, y);

            return false;
        });

        return base.configure_event (event);
    }
}
