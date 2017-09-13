using Gtk;
Subprocess subprocess;

namespace Gifup { 
    class Window : Gtk.Window {
        // Init all UI elements
        private Gtk.Grid grid;
        private Gtk.Label label;
        private Gtk.Entry entry_start;
        private Gtk.Entry entry_end;
        private Gtk.Entry entry_height;
        private Gtk.Entry entry_fps;
        private Gtk.Button button;
        private Gtk.Button file_button;
        private Gtk.FileChooserDialog file_choooser;

        private string selected_file;
        private string selected_path;
        private string selected_filename;

        public Window () {

            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
            this.screen = Gdk.Screen.get_default ();
            this.resizable = false;
            this.window_position = Gtk.WindowPosition.CENTER;

            // Header Bar
            var headerbar = new Gtk.HeaderBar ();
            headerbar.title = _("Gifup");
            headerbar.get_style_context ().add_class("flat");
            headerbar.show_close_button = true;
            this.set_titlebar (headerbar);

            build_ui();

            this.destroy.connect ( Gtk.main_quit );
            show_all();
            Gtk.main ();
        }

        void build_ui () {
            grid = new Gtk.Grid ();
            grid.column_spacing = 12;
            grid.row_spacing = 6;
            grid.hexpand = false;

            //File Open button
            file_button = new Gtk.Button.with_label ("Select a File!");
            file_button.margin_top = 10;
            file_button.margin_start = 10;
            file_button.margin_end = 10;
            grid.attach (file_button, 0, 0, 2, 1);
            // File open button events
            file_button.clicked.connect (() => {
                open_filechooser();
                if (this.selected_file != null) {
                    this.selected_path = "";
                    string[] filename_arr = this.selected_file.split ("/");
                    for (int i=0;i<filename_arr.length-1;i++) {
                        this.selected_path = this.selected_path + filename_arr[i] + "/";
                    }
                    print(this.selected_path);
                    selected_filename = filename_arr[filename_arr.length-1];
                    file_button.label = selected_filename;
                }
            });

            //  Start Time
            llabel ("<b>Start Time (In seconds) </b>", 5, 10, 10);
            entry_start = new Gtk.Entry ();
            entry_start.margin_top = 5;
            entry_start.margin_end = 10;
            grid.attach (label, 0, 1, 1, 1);
            grid.attach (entry_start, 1, 1, 1, 1);
            //  End time
            llabel ("<b>Gif length (In seconds) </b>", 5, 10, 10);
            entry_end = new Gtk.Entry ();
            entry_end.margin_top = 5;
            entry_end.margin_end = 10;
            grid.attach (label, 0, 2, 1, 1);
            grid.attach (entry_end, 1, 2, 1, 1);
            //  Gif Height
            llabel ("<b>Gif Height </b>", 5, 10, 10);
            entry_height = new Gtk.Entry ();
            entry_height.margin_top = 5;
            entry_height.margin_end = 10;
            grid.attach (label, 0, 3, 1, 1);
            grid.attach (entry_height, 1, 3, 1, 1);
            //  FPS
            llabel ("<b>Frames Per Seconds</b>", 5, 10, 10);
            entry_fps = new Gtk.Entry ();
            entry_fps.margin_top = 5;
            entry_fps.margin_end = 10;
            grid.attach (label, 0, 4, 1, 1);
            grid.attach (entry_fps, 1, 4, 1, 1);
            //  Button For making GIF
            button = new Gtk.Button.with_label ("Make GIF!");
            button.get_style_context ().add_class ("suggested-action");
            button.margin_start = 10;
            button.margin_end = 10;
            button.margin_bottom = 10;
            button.margin_top = 10;
            grid.attach (button,0, 5, 2, 1);
            // Event for gif create button
            button.clicked.connect (() => {
                gif_create();
            });

            add (grid);
        }

        void llabel (string text, int margin_top, int margin_start, int margin_end) {
            label = new Gtk.Label (text);
            label.margin_start = margin_top;
            label.margin_top = margin_start;
            label.margin_end = margin_end;
            label.set_use_markup (true);
        }

        void create_dialog (string text) {
            var dialog = new Gtk.MessageDialog(null,Gtk.DialogFlags.MODAL,Gtk.MessageType.INFO, Gtk.ButtonsType.OK, text);
            dialog.set_title ("Status");
            dialog.run ();
            dialog.destroy ();
        }

        void open_filechooser () {
            file_choooser = new FileChooserDialog ("Open File", this,
                                    FileChooserAction.OPEN,
                                    "_Cancel", ResponseType.CANCEL,
                                    "_Open", ResponseType.ACCEPT);
            if (file_choooser.run() == ResponseType.ACCEPT) {
                print (file_choooser.get_filename ());
                selected_file = file_choooser.get_filename ();
            }
            file_choooser.destroy();
        }

        void gif_create () {
            //  create gif using the file selected and the timings given
            string [] cmd = {"ffmpeg", "-ss", this.entry_start.get_text(), "-i", this.selected_file, "-to", this.entry_end.get_text(), "-r", this.entry_fps.get_text(), "-vf", "scale=" + this.entry_height.get_text() + ":-1", this.selected_path + "gifout.gif"};
            execute_command_async.begin (cmd, (obj, async_res) => {
                try {
                    if(subprocess.wait_check ()) {
                        create_dialog ("Gif is Up! at " + this.selected_path);
                    }
        
                } catch (Error e) {
                    create_dialog ("An error occurred, Please try again.");
                }
            });
        }

        public async void execute_command_async (string[] spawn_args) {
            try {
                // start the SubprocessLauncher by passing STDOUT_PIPE as parameter, since STDOUT did not return the ffmpeg output when I tried
                var launcher = new SubprocessLauncher (SubprocessFlags.STDOUT_PIPE);
        
                // start the subprocess by executing the values ​​you set to run without terminal
                subprocess = launcher.spawnv (spawn_args);
        
                // Create a variable with arguments returned from the subprocess.
                var input_stream = subprocess.get_stdout_pipe ();
        
                // Create a DataInputStream to read these arguments.
                var data_input_stream = new DataInputStream (input_stream);
        
                while (true) {
                    // The str_return string is the subprocess that arguments are being read. so that I get a new line or a reality that is displayed using the yield.
                    string str_return = yield data_input_stream.read_line_async ();
        
                    // If the string is null, then the ffmpeg process has been terminated.
                    if (str_return == null) {
                        break;
                    } else {
                       GLib.message (str_return);
                    }
                }
            } catch (Error e) {
                GLib.message("Erro %s", e.message);
            }
        }

    }
}