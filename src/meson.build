# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'HeaderBar.vala',
    'MainWindow.vala',
    'Application.vala',
    dependencies: [
        dependency('gtk+-3.0')
    ],
    install: true
)