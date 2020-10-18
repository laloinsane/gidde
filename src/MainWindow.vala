/*
* Copyright (c) 2011-2018 Your Organization (https://dev-manage.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Michel Calisto <calisto.michel@gmail.com>
*/

public class Gidde.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Application application) {
        Object (
            application: application
        );
    }

    construct {
        default_height = 600;
        default_width = 900;

        var header_bar = new Gidde.HeaderBar ();
        set_titlebar (header_bar);

        var main_stack = new Gtk.Stack ();

        try {
            string directory = "";
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);
                if (FileUtils.test (path, FileTest.IS_REGULAR)) {
                    if (".gdd" in name) {            
                        string read;
                        FileUtils.get_contents (path, out read);

                        var view = new Gtk.ScrolledWindow(null, null);
                        view.set_border_width(5);
                        
                        var text = new Gtk.TextView();
                        text.get_buffer().set_text(read);
                        view.add (text);

                        main_stack.add_titled (view, name, name);
                    }
                }
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        var stack_sidebar = new Gtk.StackSidebar ();
        stack_sidebar.stack = main_stack;

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.add1 (stack_sidebar);
        paned.add2 (main_stack);

        add (paned);

        show_all ();
    }
}
