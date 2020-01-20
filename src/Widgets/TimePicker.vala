public class Gifup.TimePicker : Gtk.Grid {
    public signal void value_changed (int time);

    private Gtk.SpinButton hr_picker;
    private Gtk.SpinButton min_picker;
    private Gtk.SpinButton sec_picker;

    construct {
        hr_picker = new Gtk.SpinButton.with_range (0, 60, 1);
        min_picker = new Gtk.SpinButton.with_range (0, 60, 1);
        sec_picker = new Gtk.SpinButton.with_range (0, 60, 1);
        hr_picker.set_orientation (Gtk.Orientation.VERTICAL);
        min_picker.set_orientation (Gtk.Orientation.VERTICAL);
        sec_picker.set_orientation (Gtk.Orientation.VERTICAL);
        attach (hr_picker, 0, 0, 1, 1);
        attach (new Gtk.Label (":"), 1, 0, 1, 1);
        attach (min_picker, 2, 0, 1, 1);
        attach (new Gtk.Label (":"), 3, 0, 1, 1);
        attach (sec_picker, 4, 0, 1, 1);

        hr_picker.value_changed.connect (() => {
            value_changed (duration_in_sec ());
        });
        min_picker.value_changed.connect (() => {
            value_changed (duration_in_sec ());
        });
        sec_picker.value_changed.connect (() => {
            value_changed (duration_in_sec ());
        });
    }

    public int duration_in_sec () {
        return (int)hr_picker.value * (60 * 60) + (int)min_picker.value * 60 + (int)sec_picker.value;
    }
}
