namespace Gifup.Utils {
    public void complete_gif_create (string selected_file, Gtk.SpinButton entry_fps, Gtk.SpinButton entry_height, Gtk.SpinButton entry_width, Gtk.Spinner spinner) {
        var gifout_path = GLib.Path.build_filename (Window.selected_dir, "gifout.gif");
        //  create gif using the entire file selected
        string [] cmd = {"ffmpeg", "-i", selected_file, "-r", entry_fps.text, "-vf", "scale=" + entry_width.text + ":" + entry_height.text , gifout_path, "-y"};
        execute_command_async.begin (cmd, (obj, async_res) => {
            var subprocess = Utils.execute_command_async.end (async_res);
            try {
                if (subprocess != null && subprocess.wait_check ()) {
                    create_dialog (_("Gif is Up at:\n %s!").printf (gifout_path));
                }
            } catch (Error e) {
                critical (e.message);
                create_dialog (_("Check if all fields have sane values and try again."));
            }

            spinner.active = false;
        });
    }

    public void gif_create (string selected_file, Gifup.TimePicker entry_end, Gifup.TimePicker entry_start, Gtk.SpinButton entry_fps, Gtk.SpinButton entry_height, Gtk.SpinButton entry_width, Gtk.Spinner spinner) {
        var gifout_path = GLib.Path.build_filename (Window.selected_dir, "gifout.gif");
        string difference = (entry_end.duration_in_sec () - entry_start.duration_in_sec ()).to_string ();
        //  create gif using the file selected and the timings given
        string [] cmd = {"ffmpeg", "-ss", entry_start.duration_in_sec ().to_string (), "-i", selected_file, "-to", difference, "-r", entry_fps.text, "-vf", "scale=" + entry_width.text + ":" + entry_height.text, gifout_path, "-y"};
        Utils.execute_command_async.begin (cmd, (obj, async_res) => {
            var subprocess = Utils.execute_command_async.end (async_res);
            try {
                if (subprocess != null && subprocess.wait_check ()) {
                    create_dialog (_("Gif is Up at:\n %s!").printf (gifout_path));
                }
            } catch (Error e) {
                critical (e.message);
                create_dialog (_("Check if all fields have sane values and try again."));
            }

            spinner.active = false;
        });
    }

    public void create_dialog (string text) {
        var dialog = new Gtk.MessageDialog (null, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, text);
        dialog.set_title (_("Status"));
        dialog.run ();
        dialog.destroy ();
    }

    public Gtk.Label create_left_label (string text) {
        var label = new Gtk.Label (GLib.Markup.printf_escaped ("<b>%s</b>", text));
        label.xalign = 0;
        label.use_markup = true;
        return label;
    }

    public async Subprocess? execute_command_async (string[] spawn_args) {
        // start the SubprocessLauncher by passing STDOUT_PIPE as parameter, since STDOUT did not return the ffmpeg output when I tried
        var launcher = new SubprocessLauncher (SubprocessFlags.STDOUT_PIPE);
        try {
            // start the subprocess by executing the values ​​you set to run without terminal
            var subprocess = launcher.spawnv (spawn_args);
            // Create a variable with arguments returned from the subprocess.
            var input_stream = subprocess.get_stdout_pipe ();

            // Create a DataInputStream to read these arguments.
            var data_input_stream = new DataInputStream (input_stream);

            while (true) {
                // The str_return string is the subprocess that arguments are being read. so that I get a new line or a reality that is displayed using the yield.
                string str_return = yield data_input_stream.read_line_async ();

                // If the string is null, then the ffmpeg process has been terminated.
                if (str_return == null) {
                    return subprocess;
                } else {
                   message (str_return);
                }
            }
        } catch (Error e) {
            message ("Error %s", e.message);
            return null;
        }
    }

    public void frame_picture (string selected_file, int frame_number, string file_name, Gtk.Image image_widget) {
        var path = GLib.Path.build_filename (GLib.Environment.get_tmp_dir (), file_name + ".bmp");
        string [] cmd = {"ffmpeg", "-hide_banner", "-loglevel", "debug", "-ss", frame_number.to_string (), "-i", selected_file, "-frames:v", "1", "-filter:v", "scale=150:-1", path, "-y"};
        Utils.execute_command_async.begin (cmd, (obj, async_res) => {
            var subprocess = Utils.execute_command_async.end (async_res);
            try {
                if (subprocess != null && subprocess.wait_check ()) {
                    message ("Image file sucess!");
                    var start_path = GLib.Path.build_filename (GLib.Environment.get_tmp_dir (), "gifup_start.bmp");
                    if (FileUtils.test (start_path, GLib.FileTest.EXISTS) && selected_file != null) {
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
