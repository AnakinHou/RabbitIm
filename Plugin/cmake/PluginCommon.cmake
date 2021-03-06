# RABBITIM_PLUG_NAME
# PLUGIN_SOURCES
# PLUGIN_UIS
# TRANSLATIONS_RESOURCE_FILES
# PLUGIN_RESOURCE_FILES
# PLUGIN_TYPE

IF(NOT PLUGIN_TYPE)
    SET(PLUGIN_TYPE App)
endif()

include(${CMAKE_SOURCE_DIR}/cmake/TranslationsPlugin.cmake)

#生成目标
IF(PLUGIN_SOURCES)
    add_library(${PROJECT_NAME}
            ${PLUGIN_SOURCES}
            ${PLUGIN_UIS}
            ${TRANSLATIONS_RESOURCE_FILES}
            ${PLUGIN_RESOURCE_FILES}
            )
    IF(BUILD_SHARED_LIBS)
        #windows下动态库
        target_compile_definitions(${PROJECT_NAME} PRIVATE -DBUILD_SHARED_LIBS)
    ENDIF()

    target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/Src)
    
    #链接库
    target_link_libraries(${PROJECT_NAME} RabbitIm ${RABBITIM_LIBS})

    IF(ANDROID)
        target_include_directories(${PROJECT_NAME} PRIVATE
            ${CMAKE_SOURCE_DIR}/android/QtAndroidUtils/android/QtAndroidUtilsModule/jni)
    ENDIF()
ENDIF(PLUGIN_SOURCES)

#为静态插件生成必要的文件  
IF(BUILD_SHARED_LIBS)
    #复制插件到 ${CMAKE_BINARY_DIR}/plugins/${PLUGIN_TYPE}/${PROJECT_NAME}
    #更改输出目录到根目录
    if(ANDROID)
        SET(PLUGIN_DIR "libs/${ANDROID_ABI}")
    else()
        SET(PLUGIN_DIR "plugins/${PLUGIN_TYPE}/${PROJECT_NAME}")
    endif()
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/${PLUGIN_DIR}")
        file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/${PLUGIN_DIR}")
    endif()
    set_target_properties(${PROJECT_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${PLUGIN_DIR}"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${PLUGIN_DIR}"
        )
    #set(LIBRARY_OUTPUT_PATH ${PLUGIN_DIR})
    #add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    #        COMMAND ${CMAKE_COMMAND} -E make_directory "${PLUGIN_DIR}"
    #        COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_BINARY_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${PROJECT_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}" "${CMAKE_BINARY_DIR}/${PLUGIN_DIR}/."
    #        )
    
    #安装
    INSTALL(TARGETS ${PROJECT_NAME}
            RUNTIME DESTINATION "${PLUGIN_DIR}"
                 COMPONENT Runtime
            LIBRARY DESTINATION "${PLUGIN_DIR}"
                 COMPONENT Runtime
            ARCHIVE DESTINATION "${PLUGIN_DIR}"
                 COMPONENT Runtime
            )
ELSE()
    IF(NOT RABBITIM_PLUG_NAME) 
        message("Please set RABBITIM_PLUG_NAME to plug class name")
    ENDIF()
    SET(FILE_NAME ${CMAKE_SOURCE_DIR}/Plugin/PluginStatic.cpp)
    SET(PLUG_CONTENT "Q_IMPORT_PLUGIN(${RABBITIM_PLUG_NAME})")
    IF(EXISTS ${FILE_NAME})
        FILE(READ ${FILE_NAME} FILE_CONTENT)
        STRING(FIND ${FILE_CONTENT} ${PLUG_CONTENT} POSTION)
        if(POSTION EQUAL "-1")
            SET(PLUG_CONTENT "\nQ_IMPORT_PLUGIN(${RABBITIM_PLUG_NAME})")
            FILE(APPEND ${FILE_NAME} ${PLUG_CONTENT})
        ENDIF()
    ENDIF()
    
    SET(FILE_NAME ${CMAKE_SOURCE_DIR}/Plugin/PluginStatic.cmake)
    SET(PLUG_CONTENT  "${PROJECT_NAME}")
    IF(EXISTS ${FILE_NAME})
        FILE(READ ${FILE_NAME} FILE_CONTENT)
    ENDIF()
    STRING(FIND ${FILE_CONTENT} ${PLUG_CONTENT} POSTION)
    if(POSTION EQUAL "-1")
        SET(PLUG_CONTENT "\nSET(RABBITIM_LIBS \${RABBITIM_LIBS} ${PROJECT_NAME})")
        FILE(APPEND ${FILE_NAME} ${PLUG_CONTENT})
    ENDIF()
ENDIF()
