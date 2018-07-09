namespace Gifup.Utils {

    public void complete_gif_create (string selected_file, Gtk.SpinButton entry_fps, Gtk.SpinButton entry_width, Gtk.Spinner spinner) {
        var selected_path = GLib.Path.get_dirname (selected_file);
        var gifout_path = GLib.Path.build_filename (selected_path, "gifout.gif");
        //  create gif using the entire file selected
        string [] cmd = {"ffmpeg", "-i", selected_file, "-r", entry_fps.text, "-vf", "scale=" + entry_width.text + ":-1", gifout_path, "-y"};
        execute_command_async.begin (cmd, (obj, async_res) => {
            var subprocess = Utils.execute_command_async.end (async_res);
            try {
                if (subprocess != null && subprocess.wait_check ()) {
                    create_dialog (_("Gif is Up at %s!").printf (selected_path));
                }

                } catch (Error e) {
                    critical (e.message);
                    create_dialog (_("Check if all fields have sane values and try again."));
                }
                spinner.active = false;
            });
    }

    public void create_dialog (string text) {
        var dialog = new Gtk.MessageDialog(null,Gtk.DialogFlags.MODAL,Gtk.MessageType.INFO, Gtk.ButtonsType.OK, text);
        dialog.set_title (_("Status"));
        dialog.run ();
        dialog.destroy ();
    }

    public Gtk.Label create_left_label (string text) {
            var label = new Gtk.Label (GLib.Markup.printf_escaped ("<b>%s</b>", text));
            label.xalign = 1;
            label.use_markup = true;
            return label;
    }

    public int duration_in_seconds (string duration) {
        string[] str = duration.split (".");
        string[] time = str[0].split (":");
        int hours = 0;
        int mins = 0;
        int secs = 0;
        if (time.length==1){
            secs = int.parse (time[0]);
        } else if (time.length==2){
            secs = int.parse (time[1]);
            mins = int.parse (time[0]);
        } else if (time.length==3){
            secs = int.parse (time[2]);
            mins = int.parse (time[1]);
            hours = int.parse (time[0]);
        }

        var converted_int =  secs + (hours * 3600) + (mins * 60);
        return converted_int;
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
                   GLib.message (str_return);
                }
            }
        } catch (Error e) {
            GLib.message("Erro %s", e.message);
            return null;
        }
    }

    void frame_picture (string selected_file, string frame_number, string file_name, Gtk.Image image_widget) {
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

    public void gif_create (string selected_file, Gtk.Entry entry_end, Gtk.Entry entry_start, Gtk.SpinButton entry_fps, Gtk.SpinButton entry_width, Gtk.Spinner spinner) {
            var selected_path = GLib.Path.get_dirname (selected_file);
            var gifout_path = GLib.Path.build_filename (selected_path, "gifout.gif");
            int difference = Utils.duration_in_seconds (entry_end.text) - Utils.duration_in_seconds (entry_start.text);
            //  create gif using the file selected and the timings given
            string [] cmd = {"ffmpeg", "-ss", duration_in_seconds (entry_start.text).to_string(), "-i", selected_file, "-to", difference.to_string(), "-r", entry_fps.text, "-vf", "scale=" + entry_width.text + ":-1", gifout_path, "-y"};
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
               spinner.active = false;
            });
    }
}
