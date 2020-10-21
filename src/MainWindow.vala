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

        var stack_sidebar = new Gtk.StackSidebar ();
        var main_stack = new Gtk.Stack ();

        try {
            string directory = "";
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);
                if (FileUtils.test (path, FileTest.IS_REGULAR)) {
                    if (".gmd" in name) {
                        string read;
                        FileUtils.get_contents (path, out read);
                        var file = File.new_for_path (path);
                        var dis = new DataInputStream (file.read ());
                        string line;
                        var tag = "";
                        var code_out = "</code></pre></div>";
                        var title_in = "<h3>";
                        var title_out = "</h3>";
                        var paragraph_in = "<p>";
                        var paragraph_out = "</p>";
                        var final_html = "
                        <!DOCTYPE html>
                        <html>
                            <body style=\"margin: 10px\">
                        ";
                        var end = "
                        <script>
                        function copy(id) {
                            let div = document.getElementById(id);
                            let text = div.innerText;
                            let textArea  = document.createElement('textarea');
                            textArea.width  = \"1px\"; 
                            textArea.height = \"1px\";
                            textArea.background =  \"transparents\" ;
                            textArea.value = text;
                            document.body.append(textArea);
                            textArea.select();
                            document.execCommand('copy');
                            document.body.removeChild(textArea);
                        }
                    </script>
                </body>
            </html>
                        ";
                        int count = 0;
                        while ((line = dis.read_line (null)) != null) {
                            string string_number = count.to_string();
                                var code_in = "<div style=\"margin: 10px 0px;
                                font-size: 1em;
                                line-height: 1.3;
                                color: #fff;
                                background-color: #2B2B2B;
                                -webkit-border-radius: 6px 6px 6px 6px;
                                -moz-border-radius: 6px 6px 6px 6px;
                                border-radius: 6px 6px 6px 6px\">
                        <button style=\"margin: 10px;
                                        right: 10px;
                                        position: absolute;
                                        color: #2B2B2B;
                                        background-color: #fff;\" onclick=\"copy("+string_number+")\">Copiar</button>
                        <pre style=\"padding: 10px 10px;\">
                            <code id=\""+string_number+"\">
                                ";
                            if ("#" in line) {
                                string res = line.replace ("#", "");
                                line = tag + title_in + res;
                                tag = title_out;
                            } else {
                                if (".." in line) {
                                    string res = line.replace ("..", "");
                                    line = tag + code_in + res;
                                    tag = code_out;
                                } else {
                                    if ("**" in line) {
                                        string res = line.replace ("**", "");
                                        line = tag + paragraph_in + res;
                                        tag = paragraph_out;
                                    } else {
                                        if (line != "") {
                                            if (tag == title_out || tag == paragraph_out || tag == code_out) {
                                                line = "<br>" + line;
                                            }
                                        }
                                    }
                                }
                            }
                            if (line != "") {
                                final_html = final_html  + line;
                                stdout.printf ("%s\n", line);
                                count = count + 1;
                            }
                        }
                        final_html = final_html + tag + end;
                        stdout.printf ("%s\n", final_html);

                        var view = new WebKit.WebView();
                        view.load_html(final_html, null);
                        main_stack.add_titled (view, name, name);
                    }
                }

            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        stack_sidebar.stack = main_stack;

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        paned.add1 (stack_sidebar);
        paned.add2 (main_stack);
        
        add (paned);

        show_all ();
    }
}