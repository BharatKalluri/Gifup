using Gtk;
Subprocess subprocess;

namespace Gifup { 
    class Window : Gtk.Window {
        // Init all UI elements
        private Gtk.Grid grid;
        private Gtk.Grid grid_basic;
        private Gtk.Grid grid_advance;
        private Gtk.Label label;
        private Gtk.Entry entry_start;
        private Gtk.Entry entry_end;

        public Gtk.Entry entry_height;
        
        private Gtk.Entry entry_fps;
        private Gtk.Button button;
        private Gtk.Button file_button;
        private Gtk.FileChooserDialog file_choooser;
        private Gtk.Image image_start;
        private Gtk.Image image_end;

        private string selected_file;
        private string selected_path;
        private string selected_filename;

        public Utils utils;

        public Window () {
            utils = new Utils ();

            //  Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
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

            //File Open button row 0
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

            // A stack to row 1
            Stack stack = new Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stack.margin_start = 10;

            // Basic Options
            // giving widgets to stack
            grid_basic = new Grid ();
            grid_basic.column_spacing = 12;
            grid_basic.row_spacing = 6;
            //  Start Time at row 1 of grid_basic
            llabel ("<b>Start Time (In seconds) </b>", 5, 10, 10);
            entry_start = new Gtk.Entry ();
            entry_start.margin_top = 5;
            entry_start.margin_end = 10;
            entry_start.activate.connect ( () => {
                frame_picture(entry_start.get_text(), "gifup_start", "start");
            });
            grid_basic.attach (this.label, 0, 1, 1, 1);
            grid_basic.attach (entry_start, 1, 1, 1, 1);
            //  End time at row 2 of grid_basic
            llabel ("<b>End Time (In seconds) </b>", 5, 10, 10);
            entry_end = new Gtk.Entry ();
            entry_end.activate.connect ( () => {
                frame_picture(entry_end.get_text(), "gifup_end", "end");
            });
            entry_end.margin_top = 5;
            entry_end.margin_end = 10;
            grid_basic.attach (label, 0, 2, 1, 1);
            grid_basic.attach (entry_end, 1, 2, 1, 1);

            // Start Image from row 3 of grid_basic
            image_start = new Image ();
            image_start.margin_start = 10;
            grid_basic.attach(image_start, 0, 3, 1, 1);
            // End Image from row 3 of grid_basic
            image_end = new Image ();
            image_start.margin_start = 10;
            grid_basic.attach(image_end, 1, 3, 1, 1);
            // Basic Options end
            stack.add_titled (grid_basic, "Basic", "Basic Options");

            // Advance Options start

            grid_advance = new Grid ();
            grid_advance.column_spacing = 12;
            grid_advance.row_spacing = 6;
            //  Gif Height at row 4 of grid_advance
            llabel ("<b>Gif Height </b>", 5, 10, 10);
            entry_height = new Gtk.Entry ();
            entry_height.set_text ("300");
            entry_height.margin_top = 5;
            entry_height.margin_end = 10;
            grid_advance.attach (label, 0, 4, 1, 1);
            grid_advance.attach (entry_height, 1, 4, 1, 1);
            //  FPS at row 5 of grid_advance
            llabel ("<b>Frames Per Seconds</b>", 5, 10, 10);
            entry_fps = new Gtk.Entry ();
            entry_fps.set_text ("10");
            entry_fps.margin_top = 5;
            entry_fps.margin_end = 10;
            grid_advance.attach (label, 0, 5, 1, 1);
            grid_advance.attach (entry_fps, 1, 5, 1, 1);
            
            stack.add_titled (grid_advance, "Advanced", "Advanced Options");
            // Advance Options End

            Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.set_stack (stack);
            stack_switcher.margin_start = 10;

            grid.attach (stack_switcher, 0, 1, 1, 1);
            grid.attach (stack, 0, 2, 1, 1);

            //  Button For making GIF at row 6 of grid_advance
            button = new Gtk.Button.with_label ("Make GIF!");
            button.get_style_context ().add_class ("suggested-action");
            button.margin_start = 10;
            button.margin_end = 10;
            button.margin_bottom = 10;
            button.margin_top = 10;
            grid.attach (button,0, 6, 2, 1);
            // Event for gif create button
            button.clicked.connect (() => {
                gif_create();
            });

            add (grid);
        }

        public void llabel (string text, int margin_top, int margin_start, int margin_end) {
            this.label = new Gtk.Label (text);
            this.label.margin_start = margin_top;
            this.label.margin_top = margin_start;
            this.label.margin_end = margin_end;
            this.label.set_use_markup (true);
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
                selected_file = file_choooser.get_filename ();
            }
            file_choooser.destroy();
        }

        void gif_create () {
            //  create gif using the file selected and the timings given
            string [] cmd = {"ffmpeg", "-ss", this.entry_start.get_text(), "-i", this.selected_file, "-to", this.entry_end.get_text(), "-r", this.entry_fps.get_text(), "-vf", "scale=" + this.entry_height.get_text() + ":-1", this.selected_path + "gifout.gif", "-y"};
            utils.execute_command_async.begin (cmd, (obj, async_res) => {
                try {
                    if(subprocess.wait_check ()) {
                        create_dialog ("Gif is Up! at " + this.selected_path);
                    }
        
                } catch (Error e) {
                    create_dialog ("An error occurred, Please try again.");
                }
            });
        }

        void frame_picture (string frame_number, string file_name, string location) {
            string [] cmd = {"ffmpeg", "-ss", frame_number, "-i", this.selected_file, "-frames:v", "1", "-filter:v", "scale=150:-1", "/tmp/" + file_name + ".bmp", "-y"};
            utils.execute_command_async.begin (cmd, (obj, async_res) => {
                try {
                    if(subprocess.wait_check ()) {
                        print ("Image file sucess!");
                        if (location == "start") {
                            if (FileUtils.test("/tmp/gifup_start.bmp", GLib.FileTest.EXISTS) == true && this.selected_file!=null) {
                                image_start.set_from_file ("/tmp/gifup_start.bmp");
                            }
                        } else {
                            if (FileUtils.test("/tmp/gifup_end.bmp", GLib.FileTest.EXISTS) == true && this.selected_file!=null) {
                                image_end.set_from_file ("/tmp/gifup_end.bmp");
                            }
                        }
                    }
        
                } catch (Error e) {
                    create_dialog ("An error occurred,Check and try again!");
                }
            });  
        }

    }
}