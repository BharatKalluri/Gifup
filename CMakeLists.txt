project (gifup)
cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/apollo11")

set (EXEC_NAME "gifup")
set (RELEASE_NAME "Hello Houston")
set (VERSION "0.1")
set (VERSION_INFO "space_age")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED
    gtk+-3.0
    granite
)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Gifup.vala
    src/Window.vala
    src/Utils.vala
    src/SettingsDialog.vala
    
PACKAGES
    granite
    gtk+-3.0
)

add_executable(${EXEC_NAME} ${VALA_C})

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/gifup.app.desktop DESTINATION ${DATADIR}/applications/)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/gifup.svg" DESTINATION ${DATADIR}/pixmaps/)


#translation files
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_subdirectory (po)