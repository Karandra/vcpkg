vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kiconthemes
    REF v5.88.0
    SHA512 197fa4bfeabb459e22c7522d5358bf37c0bf5adc7b6a0605e1ef884dee8d1a02df7fb988b0e2d4821e5c889cd4de2c2fe0d9b7da0266f0869f6779edf57aa5be
    HEAD_REF master
)

vcpkg_check_features(
     OUT_FEATURE_OPTIONS FEATURE_OPTIONS
     FEATURES
         designerplugin BUILD_DESIGNERPLUGIN
 )

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE ${SOURCE_PATH}/.clang-format "DisableFormat: true\nSortIncludes: false\n")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_PLUGINDIR=plugins
        -DKDE_INSTALL_QTPLUGINDIR=plugins
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME KF5IconThemes CONFIG_PATH lib/cmake/KF5IconThemes)
vcpkg_copy_pdbs()

vcpkg_copy_tools(
    TOOL_NAMES kiconfinder5
    AUTO_CLEAN
)

if(VCPKG_TARGET_IS_OSX)
    vcpkg_copy_tools(
        TOOL_NAMES ksvg2icns
        AUTO_CLEAN
    )
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${SOURCE_PATH}/LICENSES/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright")

