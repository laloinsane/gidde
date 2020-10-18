public class Gidde.HeaderBar : Gtk.HeaderBar {
    construct {
        title = "Gidde";
        has_subtitle = false;
        show_close_button = true;

        var open_folder_button = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
        open_folder_button.valign = Gtk.Align.CENTER;
        pack_start (open_folder_button);
        
        var settings_button = new Gtk.Button.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        settings_button.valign = Gtk.Align.CENTER;
        pack_end (settings_button);
    }
}