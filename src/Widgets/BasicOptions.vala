using Gtk;

namespace Gifup {
    public class BasicOptions : Gtk.Grid {
        private Gtk.Entry entry_start;
        private Gtk.Entry entry_end;
        private Gtk.Image image_start;
        private Gtk.Image image_end;
        public BasicOptions (string selected_file) {
                //Grid properties
                column_spacing = 12;
                row_spacing = 6;
                margin_start = 12;
                margin_end = 12;
                //  Start Time at row 1 of grid_basic
                entry_start = new Gtk.Entry ();
                attach (Gifup.Utils.create_left_label (_("Start Time (hh:mm:ss):")), 0, 1, 1, 1);
                attach (entry_start, 1, 1, 1, 1);
                //  End time at row 2 of grid_basic
                entry_end = new Gtk.Entry ();
                attach (Gifup.Utils.create_left_label (_("End Time (hh:mm:ss):")), 0, 2, 1, 1);
                attach (entry_end, 1, 2, 1, 1);

                // Start Image from row 3 of grid_basic
                image_start = new Image ();
                attach(image_start, 0, 3, 1, 1);
                // End Image from row 3 of grid_basic
                image_end = new Image ();
                attach(image_end, 1, 3, 1, 1);
                // Basic Options end
                entry_start.activate.connect ( () => {
                    Gifup.Utils.frame_picture (selected_file, entry_start.text, "gifup_start", image_start);
                });
                entry_end.activate.connect ( () => {
                    Gifup.Utils.frame_picture (selected_file, entry_end.text, "gifup_end", image_end);
                });
        }
    }
}