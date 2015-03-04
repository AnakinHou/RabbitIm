MACRO(INSTALL_QT_LIBRARY _NAME)
  IF(WIN32)
    SET(_PREFIX "Qt5")
    SET(_EXT "dll")
  ELSE(WIN32)
    SET(_PREFIX "libQt5")
    SET(_EXT "so")
  ENDIF(WIN32)
  SET(_LIB "${QT_INSTALL_DIR}/bin/${_PREFIX}${_NAME}.${_EXT}")
  IF(EXISTS ${_LIB})
    INSTALL(FILES ${_LIB} DESTINATION .)
  ENDIF(EXISTS ${_LIB})
ENDMACRO(INSTALL_QT_LIBRARY)

MACRO(INSTALL_QT_PLUGINS _PLUGINS_PARA)
    FOREACH(_plugins ${ARGV})
        FOREACH(_plugin ${${_plugins}})
            get_target_property(_plugin_file ${_plugin} LOCATION)
            #MESSAGE("plugin:${_plugin_file}")
            if(_plugin_file)
                STRING(REGEX REPLACE "^.*(plugins.*)/.*$" "\\1" _des_plugin_file ${_plugin_file})
                INSTALL(FILES ${_plugin_file} DESTINATION "${_des_plugin_file}")
            endif()
        ENDFOREACH()
    ENDFOREACH()
ENDMACRO(INSTALL_QT_PLUGINS)

MACRO(INSTALL_QT_LIBRARYS _LIBS)
    FOREACH(_file  ${ARGV})
        get_target_property(_location ${_file} LOCATION)
        MESSAGE("Libs:${_location};link:${_location_LINK}")
        IF(EXISTS ${_location})
            INSTALL(FILES ${_location} DESTINATION .)
        ENDIF(EXISTS ${_location})
    ENDFOREACH()
ENDMACRO(INSTALL_QT_LIBRARYS)

MACRO(GENERATED_DEPLOYMENT_SETTINGS)
    SET(_file_name "${PROJECT_BINARY_DIR}/android-libRabbitIm.so-deployment-settings.json")
    
    FILE(WRITE ${_file_name} "{\n")
    FILE(APPEND ${_file_name} "\"description\": \"This file is generated by qmake to be read by androiddeployqt and should not be modified by hand.\",\n")
    FILE(APPEND ${_file_name} "\"qt\":\"${QT_INSTALL_DIR}\",\n") 
    FILE(APPEND ${_file_name} "\"sdk\":\"$ENV{ANDROID_SDK}\",\n")
    FILE(APPEND ${_file_name} "\"ndk\":\"$ENV{ANDROID_NDK}\",\n")
    FILE(APPEND ${_file_name} "\"toolchain-prefix\":\"${ANDROID_TOOLCHAIN_MACHINE_NAME}\",\n")
    FILE(APPEND ${_file_name} "\"tool-prefix\":\"${ANDROID_TOOLCHAIN_MACHINE_NAME}\",\n")
    FILE(APPEND ${_file_name} "\"toolchain-version\":\"${ANDROID_COMPILER_VERSION}\",\n")
    IF(CMAKE_HOST_WIN32)
        FILE(APPEND ${_file_name} "\"ndk-host\":\"windows\",\n")
    ELSE()
		IF(ANDROID_NDK_HOST_X64)
            FILE(APPEND ${_file_name} "\"ndk-host\":\"linux-x86_64\",\n")
		ELSE()
			FILE(APPEND ${_file_name} "\"ndk-host\":\"linux\",\n")
        ENDIF()
    ENDIF()
    FILE(APPEND ${_file_name} "\"target-architecture\":\"${ANDROID_ABI}\",\n")
    FILE(APPEND ${_file_name} "\"android-package-source-directory\":\"${PROJECT_SOURCE_DIR}/android\",\n")
    IF(ANDROID_EXTRA_LIBS)
        FILE(APPEND ${_file_name} "\"android-extra-libs\":\"${ANDROID_EXTRA_LIBS}\",\n")
    ENDIF(ANDROID_EXTRA_LIBS)
    FILE(APPEND ${_file_name} "\"application-binary\":\"${PROJECT_BINARY_DIR}/libRabbitIm.so\"\n")
    FILE(APPEND ${_file_name} "}")
ENDMACRO(GENERATED_DEPLOYMENT_SETTINGS)
