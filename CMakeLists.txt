project (com.github.bharatkalluri.gifup)
cmake_minimum_required (VERSION 2.6)

include (GNUInstallDirs)

set (PKGDATADIR "${CMAKE_INSTALL_DATAROOTDIR}/gifup")
set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
set (EXEC_NAME "${CMAKE_PROJECT_NAME}")
set (VERSION "0.0.1")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED
    gtk+-3.0
    granite
)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

add_definitions ("-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Gifup.vala
    src/Window.vala
    src/Utils.vala
PACKAGES
    granite
    gtk+-3.0
)

add_executable(${EXEC_NAME} ${VALA_C})

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.bharatkalluri.gifup.desktop DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/com.github.bharatkalluri.gifup.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/32x32/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/48/com.github.bharatkalluri.gifup.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/48x48/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/com.github.bharatkalluri.gifup.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/64x64/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/com.github.bharatkalluri.gifup.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/128x128/apps)

install(
    CODE
        "execute_process (COMMAND gtk-update-icon-cache -t -f ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor)"
    CODE
        "message (STATUS \"Updated icon cache in ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor\")"
)

#translation files
add_subdirectory (po)

# install our .appdata.xml file so AppCenter will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.bharatkalluri.gifup.appdata.xml DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/metainfo/)
