using Gtk;

namespace Gifup { 
    class Window : Gtk.Window {
        // Init all UI elements
        private Gtk.Grid grid;
        private Gtk.Grid grid_basic;
        private Gtk.Grid grid_advance;
        private Gtk.Entry entry_start;
        private Gtk.Entry entry_end;

        private Gtk.SpinButton entry_height;
        private Gtk.SpinButton entry_fps;
        private Gtk.Button gif_button;
        private Gtk.FileChooserButton file_button;
        private Gtk.Image image_start;
        private Gtk.Image image_end;
        private Gtk.Spinner spinner;

        private string selected_file;
        public Window () {
            //  Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
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
            	gif_button.sensitive = true;
            });

            // A stack to row 1
            var stack = new Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

            basic_options ();
            stack.add_titled (grid_basic, "Basic", _("Basic Options"));
            advance_options ();
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
            var tip_label = create_left_label (_("Tip: Click enter after entering time for previews!"));
            tip_label.margin_start = 6;
            tip_label.margin_end = 6;
            tip_label.xalign = 0.5f;
            grid.add (tip_label);

            //  Button For making GIF at row 6 of grid_advance
            gif_button = new Gtk.Button.with_label (_("Make GIF!"));
            gif_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            gif_button.margin = 12;
            gif_button.sensitive = false;
            grid.add (gif_button);
            // Event for gif create button
            gif_button.clicked.connect (() => {
                gif_create();
                spinner.active = true;
            });

            add (grid);
        }

        void basic_options () {
            // Basic Options
            // giving widgets to stack
            grid_basic = new Grid ();
            grid_basic.column_spacing = 12;
            grid_basic.row_spacing = 6;
            grid_basic.margin_start = 12;
            grid_basic.margin_end = 12;
            //  Start Time at row 1 of grid_basic
            entry_start = new Gtk.Entry ();
            grid_basic.attach (create_left_label (_("Start Time (hh:mm:ss):")), 0, 1, 1, 1);
            grid_basic.attach (entry_start, 1, 1, 1, 1);
            //  End time at row 2 of grid_basic
            entry_end = new Gtk.Entry ();
            grid_basic.attach (create_left_label (_("End Time (hh:mm:ss):")), 0, 2, 1, 1);
            grid_basic.attach (entry_end, 1, 2, 1, 1);

            // Start Image from row 3 of grid_basic
            image_start = new Image ();
            grid_basic.attach(image_start, 0, 3, 1, 1);
            // End Image from row 3 of grid_basic
            image_end = new Image ();
            grid_basic.attach(image_end, 1, 3, 1, 1);
            // Basic Options end
            entry_start.activate.connect ( () => {
                frame_picture (entry_start.text, "gifup_start", image_start);
            });
            entry_end.activate.connect ( () => {
                frame_picture (entry_end.text, "gifup_end", image_end);
            });
        }

        void advance_options () {
            // Advance Options start
            grid_advance = new Grid ();
            grid_advance.column_spacing = 12;
            grid_advance.row_spacing = 6;
            grid_advance.margin_start = 12;
            grid_advance.margin_end = 12;
            //  Gif Height at row 4 of grid_advance
            entry_height = new Gtk.SpinButton.with_range (12, 2000, 1);
            entry_height.hexpand = true;
            entry_height.value = 300;
            grid_advance.attach (create_left_label (_("Gif Height:")), 0, 0, 1, 1);
            grid_advance.attach (entry_height, 1, 0, 1, 1);
            //  FPS at row 5 of grid_advance
            entry_fps = new Gtk.SpinButton.with_range (1, 200, 1);
            entry_fps.value = 10;
            grid_advance.attach (create_left_label (_("Frames Per Seconds:")), 0, 1, 1, 1);
            grid_advance.attach (entry_fps, 1, 1, 1, 1);
            // Advance Options End
        }

        public Gtk.Label create_left_label (string text) {
            var label = new Gtk.Label (GLib.Markup.printf_escaped ("<b>%s</b>", text));
            label.xalign = 1;
            label.use_markup = true;
            return label;
        }

        void create_dialog (string text) {
            var dialog = new Gtk.MessageDialog(null,Gtk.DialogFlags.MODAL,Gtk.MessageType.INFO, Gtk.ButtonsType.OK, text);
            dialog.set_title (_("Status"));
            dialog.run ();
            dialog.destroy ();
        }

        void gif_create () {
            var selected_path = GLib.Path.get_dirname (selected_file);
            var gifout_path = GLib.Path.build_filename (selected_path, "gifout.gif");
            var difference = Utils.duration_in_seconds (entry_end.text) - Utils.duration_in_seconds (entry_start.text);
            //  create gif using the file selected and the timings given
            string [] cmd = {"ffmpeg", "-ss", Utils.duration_in_seconds (entry_start.text).to_string(), "-i", selected_file, "-to", difference.to_string(), "-r", entry_fps.text, "-vf", "scale=" + entry_height.text + ":-1", gifout_path, "-y"};
            Utils.execute_command_async.begin (cmd, (obj, async_res) => {
                var subprocess = Utils.execute_command_async.end (async_res);
                try {
                    if (subprocess != null && subprocess.wait_check ()) {
                        create_dialog (_("Gif is Up at %s!").printf (selected_path));
                    }

                } catch (Error e) {
                    critical (e.message);
                    create_dialog (_("Check if all fields have sane values and try again."));
                }
                this.spinner.active = false;
            });
        }

        void frame_picture (string frame_number, string file_name, Gtk.Image image_widget) {
            var path = GLib.Path.build_filename (GLib.Environment.get_tmp_dir (), file_name + ".bmp");
            string [] cmd = {"ffmpeg", "-ss", Utils.duration_in_seconds (frame_number).to_string(), "-i", selected_file, "-frames:v", "1", "-filter:v", "scale=150:-1", path, "-y"};
            Utils.execute_command_async.begin (cmd, (obj, async_res) => {
                var subprocess = Utils.execute_command_async.end (async_res);
                try {
                    if (subprocess != null && subprocess.wait_check ()) {
                        message ("Image file sucess!");
                        if (FileUtils.test("/tmp/gifup_start.bmp", GLib.FileTest.EXISTS) && selected_file != null) {
                            image_widget.set_from_file (path);
                        }
                    }
                } catch (Error e) {
                    critical (e.message);
                    create_dialog (_("Is a file selected?"));
                }
            });
        }

    }
}
