include (Translations)
    add_translations_directory(${GETTEXT_PACKAGE})
    add_translations_catalog(${GETTEXT_PACKAGE}
    ../src/
    DESKTOP_FILES
        ${CMAKE_SOURCE_DIR}/data/com.github.bharatkalluri.gifup.desktop
    APPDATA_FILES
        ${CMAKE_SOURCE_DIR}/data/com.github.bharatkalluri.gifup.appdata.xml
)
