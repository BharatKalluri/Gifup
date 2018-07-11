using Gtk;

namespace Gifup {
    public class BasicOptions : Gtk.Grid {

        public Gifup.TimePicker entry_start;
        public Gifup.TimePicker entry_end;
        private Gtk.Image image_start;
        private Gtk.Image image_end;
        public string selected_file;
        public BasicOptions () {

                //Grid properties
                column_spacing = 12;
                row_spacing = 6;
                margin_start = 12;
                margin_end = 12;

                //  Start Time at row 1 of grid_basic
                entry_start = new Gifup.TimePicker ();
                attach (Gifup.Utils.create_left_label (_("Start Time :")), 0, 1, 1, 1);
                attach (entry_start, 1, 1, 1, 1);
                //  End time at row 2 of grid_basic
                entry_end = new Gifup.TimePicker ();
                attach (Gifup.Utils.create_left_label (_("End Time :")), 2, 1, 1, 1);
                attach (entry_end, 3, 1, 1, 1);

                // Start Image from row 3 of grid_basic
                image_start = new Image ();
                attach(image_start, 0, 2, 2, 1);
                // End Image from row 3 of grid_basic
                image_end = new Image ();
                attach(image_end, 2, 2, 2, 1);

                // Basic Options end
                entry_start.value_changed.connect ( (frame_number) => {
                    Gifup.Utils.frame_picture (selected_file, frame_number, "gifup_start", image_start);
                });
                entry_end.value_changed.connect ( (frame_number) => {
                    Gifup.Utils.frame_picture (selected_file, frame_number, "gifup_end", image_end);
                });
        }
    }
}