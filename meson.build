project('com.github.bharatkalluri.gifup', 'vala', 'c', version: '0.0.21')

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

subdir('src')

executable(
    meson.project_name(),
    sources,
    dependencies: [
        dependency('gtk+-3.0'),
    ],
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
