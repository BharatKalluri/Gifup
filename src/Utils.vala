namespace Gifup.Utils {
        public static string duration_in_seconds (string duration) {
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
            return converted_int.to_string ();
        }

        public static async Subprocess? execute_command_async (string[] spawn_args) {
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
}
