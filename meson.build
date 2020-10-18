# project name and programming language
project('com.github.laloinsane.gidde', 'vala', 'c')

subdir('src')

# Install our .desktop file so the Applications Menu will see it
install_data(
    join_paths('data', 'gidde.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications'),
    rename: meson.project_name() + '.desktop'
)

# Install our .appdata.xml file so AppCenter will see it
install_data(
    join_paths('data', 'gidde.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
    rename: meson.project_name() + '.appdata.xml'
)
