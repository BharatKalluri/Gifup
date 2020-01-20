public class Gifup.AdvanceOptions : Gtk.Grid {
    public Gtk.SpinButton entry_width { get; private set; }
    public Gtk.SpinButton entry_height { get; private set; }
    public Gtk.SpinButton entry_fps { get; private set; }

    public AdvanceOptions () {
        Object (
            column_spacing: 12,
            row_spacing: 6,
            margin_start: 12,
            margin_end: 12
        );
    }

    construct {
        //  Gif height at row 4 of grid_advance
        entry_height = new Gtk.SpinButton.with_range (500, 20000, 1);
        entry_height.hexpand = true;
        entry_height.value = 300;
        attach (Gifup.Utils.create_left_label (_("Gif height:")), 0, 0, 1, 1);
        attach (entry_height, 1, 0, 1, 1);

        //  Gif width at row 4 of grid_advance
        entry_width = new Gtk.SpinButton.with_range (500, 20000, 1);
        entry_width.hexpand = true;
        entry_width.value = 300;
        attach (Gifup.Utils.create_left_label (_("Gif width:")), 0, 1, 1, 1);
        attach (entry_width, 1, 1, 1, 1);

        //  FPS at row 5 of grid_advance
        entry_fps = new Gtk.SpinButton.with_range (1, 200, 1);
        entry_fps.value = 10;
        attach (Gifup.Utils.create_left_label (_("Frames Per Seconds:")), 0, 2, 1, 1);
        attach (entry_fps, 1, 2, 1, 1);
    }
}
