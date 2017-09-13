namespace Gifup { 
    class Utils : Gtk.Window {


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