public class Gifup.AdvanceOptions : Gtk.Grid {
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
        var entry_height = new Gtk.SpinButton.with_range (500, 20000, 1);
        entry_height.hexpand = true;
        attach (Gifup.Utils.create_left_label (_("Gif height:")), 0, 0, 1, 1);
        attach (entry_height, 1, 0, 1, 1);

        //  Gif width at row 4 of grid_advance
        var entry_width = new Gtk.SpinButton.with_range (500, 20000, 1);
        entry_width.hexpand = true;
        attach (Gifup.Utils.create_left_label (_("Gif width:")), 0, 1, 1, 1);
        attach (entry_width, 1, 1, 1, 1);

        //  FPS at row 5 of grid_advance
        var entry_fps = new Gtk.SpinButton.with_range (1, 200, 1);
        attach (Gifup.Utils.create_left_label (_("Frames Per Seconds:")), 0, 2, 1, 1);
        attach (entry_fps, 1, 2, 1, 1);

        GifupApp.settings.bind ("gif-height", entry_height, "value", SettingsBindFlags.DEFAULT);
        GifupApp.settings.bind ("gif-width", entry_width, "value", SettingsBindFlags.DEFAULT);
        GifupApp.settings.bind ("fps", entry_fps, "value", SettingsBindFlags.DEFAULT);
    }
}
