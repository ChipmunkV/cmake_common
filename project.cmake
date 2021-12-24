cmake_minimum_required(VERSION 3.16)

function(required_variable name type)
	if(ARGN)
		list(GET ${ARGN} 0 description)
	else()
		set(description "${name}")
	endif()
	
	if(NOT DEFINED ${name})
		message(FATAL_ERROR "${name} is not defined")
	endif()

	set(${name} ${${name}} CACHE ${type} "${description}")
endfunction()


function(get_real_path out path)
	set(p ${path})
	get_filename_component(p ${p} REALPATH)
	set(${out} ${p} PARENT_SCOPE)
endfunction()


if(NOT DEFINED enable_warnings)
	set(enable_warnings ON)
endif()

if(NOT DEFINED enable_permissive)
	set(enable_permissive OFF)
endif()

if(NOT DEFINED enable_cli)
    set(enable_cli OFF)
endif()

if(NOT DEFINED enable_bigobj)
    set(enable_bigobj OFF)
endif()

if(NOT DEFINED create_translations)
	set(create_translations ON)
endif()

if(NOT DEFINED additional_translations)
	set(additional_translations "")
endif()

if(NOT DEFINED run_elevated)
	set(run_elevated OFF)
endif()


if(NOT WIN32)
	add_compile_definitions(QDLLEXPORT=)
	add_compile_definitions(DLLEXPORT=)
endif()

get_real_path(modorganizer_build_path "${CMAKE_CURRENT_LIST_DIR}/../..")
get_real_path(modorganizer_super_path "${modorganizer_build_path}/modorganizer_super")
get_real_path(uibase_path "${modorganizer_super_path}/uibase")
get_real_path(uibase_include_path "${uibase_path}/src")
get_real_path(modorganizer_install_path "${modorganizer_super_path}/../../install")
get_real_path(modorganizer_install_lib_path "${modorganizer_install_path}/libs")


if(${project_type} STREQUAL "plugin")
	include(${CMAKE_CURRENT_LIST_DIR}/plugin.cmake)
elseif(${project_type} STREQUAL "dll")
	include(${CMAKE_CURRENT_LIST_DIR}/dll.cmake)
elseif(${project_type} STREQUAL "lib")
	include(${CMAKE_CURRENT_LIST_DIR}/lib.cmake)
elseif(${project_type} STREQUAL "exe")
	include(${CMAKE_CURRENT_LIST_DIR}/exe.cmake)
elseif(${project_type} STREQUAL "tests")
	include(${CMAKE_CURRENT_LIST_DIR}/tests.cmake)
elseif(${project_type} STREQUAL "python_plugin")
	include(${CMAKE_CURRENT_LIST_DIR}/python_plugin.cmake)
elseif(${project_type} STREQUAL "python_module_plugin")
	include(${CMAKE_CURRENT_LIST_DIR}/python_module_plugin.cmake)
else()
	message(FATAL_ERROR "unknown project type '${project_type}'")
endif()


do_project()
