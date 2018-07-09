using Gtk;

namespace Gifup { 
    class Window : Gtk.Window {
        // Init all UI elements
        private Gtk.Grid grid;
        private AdvanceOptions grid_advance;
        private BasicOptions grid_basic;

        public Gtk.Button gif_button;
        public Gtk.Button complete_gif;
        public Gtk.FileChooserButton file_button;
        public Gtk.Spinner spinner;

        public string selected_file;
        public Window () {
            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
            this.resizable = false;
            this.window_position = Gtk.WindowPosition.CENTER;

            // Header Bar
            var headerbar = new Gtk.HeaderBar ();
            headerbar.title = "Gifup";
            headerbar.get_style_context ().add_class(Gtk.STYLE_CLASS_FLAT);
            headerbar.show_close_button = true;
            this.set_titlebar (headerbar);

            build_ui();

            this.destroy.connect ( Gtk.main_quit );
            show_all();
            
            Gtk.main ();
        }

        void build_ui () {
            grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.column_spacing = 6;
            grid.row_spacing = 12;
            grid.hexpand = true;

            //File Open button row 0
            file_button = new Gtk.FileChooserButton ("Open your favourite file", Gtk.FileChooserAction.OPEN);
            file_button.margin_top = 10;
            file_button.margin_start = 10;
            file_button.margin_end = 10;
            grid.add (file_button);
            // File open button events
            file_button.selection_changed.connect (() => {
                selected_file = file_button.get_uri().substring (7).replace ("%20"," ");
                grid_basic.selected_file = selected_file;
                gif_button.sensitive = true;
                complete_gif.sensitive = true;
            });

            // A stack to row 1
            var stack = new Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

            grid_basic = new BasicOptions ();
            stack.add_titled (grid_basic, "Basic", _("Basic Options"));
            grid_advance = new AdvanceOptions ();
            stack.add_titled (grid_advance, "Advanced", _("Advanced Options"));

            Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.set_stack (stack);

            grid.add (stack_switcher);
            grid.add (stack);

            // A spinner to indicate program is working
            spinner = new Gtk.Spinner ();
            grid.add (spinner);

            // A tip saying hit enter for frame preview
            var tip_label = Gifup.Utils.create_left_label (_("Tip: Click enter after entering time for previews!"));
            tip_label.margin_start = 6;
            tip_label.margin_end = 6;
            tip_label.xalign = 0.5f;
            grid.add (tip_label);

            //  Button For making GIF at row 6 of grid_advance
            gif_button = new Gtk.Button.with_label (_("Make GIF!"));
            gif_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            gif_button.margin_start = 12;
            gif_button.margin_end = 12;
            gif_button.sensitive = false;
            grid.add (gif_button);
            // Event for gif create button
            gif_button.clicked.connect (() => {
                Gifup.Utils.gif_create(selected_file, grid_basic.entry_end, grid_basic.entry_start, grid_advance.entry_fps, grid_advance.entry_width, spinner);
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
                Gifup.Utils.complete_gif_create (selected_file, grid_advance.entry_fps, grid_advance.entry_width, spinner);
                spinner.active = true;
            });

            add (grid);
        }
    }
}
