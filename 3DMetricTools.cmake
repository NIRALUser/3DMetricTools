
# Extension meta-information
set(EXTENSION_HOMEPAGE "https://www.nitrc.org/projects/meshmetric3d/")
set(EXTENSION_CATEGORY "Quantification")
set(EXTENSION_CONTRIBUTORS "Francois Budin (UNC), Juliette Pera (UNC), Beatriz Paniagua (UNC)")
set(EXTENSION_DESCRIPTION "This extension computes the distance between two 3D models")
set(EXTENSION_ICONURL "http://slicer.org/slicerWiki/images/4/43/Slicer4ExtensionModelToModelDistance.png")
set(EXTENSION_SCREENSHOTURLS "http://www.slicer.org/slicerWiki/images/thumb/7/7a/Slicer4Extensions-ModelToModelDistanceOriginalShapes.png/800px-Slicer4Extensions-ModelToModelDistanceOriginalShapes.png")
set(EXTENSION_STATUS "")
set(EXTENSION_DEPENDS "NA") # Specified as a space separated list or 'NA' if any
set(EXTENSION_BUILD_SUBDIRECTORY .)

#-----------------------------------------------------------------------------
# Prequisites
#-----------------------------------------------------------------------------
find_package(SlicerExecutionModel REQUIRED)
include(${SlicerExecutionModel_USE_FILE})

find_package(VTK REQUIRED)
include(${VTK_USE_FILE})

if(3DMetricTools_QT_VERSION VERSION_EQUAL "4")
  find_package(Qt4 REQUIRED)
  include(${QT_USE_FILE})
  set(3DMetricTools_VTK_USE_QVTKOPENGLWIDGET 0)
  set(3DMetricTools_VTK_USE_QVTKOPENGLNATIVEWIDGET 0)
else()
  set(qt_components Core Widgets)
  if(UNIX AND NOT APPLE)
    list(APPEND qt_components X11Extras)
  endif()
  find_package(Qt5 COMPONENTS ${qt_components} REQUIRED)
  if (VTK_VERSION VERSION_GREATER "7" AND VTK_RENDERING_BACKEND STREQUAL "OpenGL2")
    set(3DMetricTools_VTK_USE_QVTKOPENGLWIDGET 1)
    set(3DMetricTools_VTK_USE_QVTKOPENGLNATIVEWIDGET 0)

    # Detect if QVTKOpenGLNativeWidget.h is available (adapted from https://github.com/commontk/CTK)
    if(3DMetricTools_VTK_USE_QVTKOPENGLWIDGET)
      set(_msg "Checking if QVTKOpenGLNativeWidget.h exists")
      message(STATUS "${_msg}")
      foreach(include_dir IN ITEMS ${vtkGUISupportQt_INCLUDE_DIRS})
        if(EXISTS "${include_dir}/QVTKOpenGLNativeWidget.h")
          set(3DMetricTools_VTK_USE_QVTKOPENGLNATIVEWIDGET 1)
          break()
        endif()
      endforeach()
      if(3DMetricTools_VTK_USE_QVTKOPENGLNATIVEWIDGET)
        message(STATUS "${_msg} - found")
      else()
        message(STATUS "${_msg} - not found")
      endif()
    endif()
  endif()
  set(QT_LIBRARIES)
  foreach(lib IN LISTS qt_components)
    list(APPEND QT_LIBRARIES Qt5::${lib})
  endforeach()
endif()

#-----------------------------------------------------------------------------
if( NOT ${EXTENSION_NAME}_BUILD_SLICER_EXTENSION )
  # set RPATH
  if( UNIX )
    if(NOT APPLE)
      SET( CMAKE_INSTALL_RPATH "$ORIGIN/lib" )
    endif()
  endif()
  SETIFEMPTY( INSTALL_ARCHIVE_DESTINATION 3DMetricTools-static_lib )
  SETIFEMPTY( INSTALL_RUNTIME_DESTINATION 3DMetricTools-package )
  SETIFEMPTY( INSTALL_LIBRARY_DESTINATION ${INSTALL_RUNTIME_DESTINATION}/lib )
endif()

#-----------------------------------------------------------------------------
if( Build_ModelToModelDistance )
  add_subdirectory( ModelToModelDistance )
endif()

if( Build_3DMeshMetric )
  find_package( Qt4 REQUIRED )
  include( ${QT_USE_FILE} )

  set( MeshValmetLib_SOURCE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Libraries )
  if( Build_Static )
    set( MeshValmetLib_LIBRARY_TYPE STATIC )
    set( MeshValmetLib_BINARY_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} )
  else()
    set( MeshValmetLib_LIBRARY_TYPE SHARED )
    set( MeshValmetLib_BINARY_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} )
  endif()

  add_subdirectory( Libraries )
  add_subdirectory( 3DMeshMetric )
endif()

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------
if(3DMetricTools_BUILD_TESTING)
  include(CTest)
  include(ExternalData)
  ADD_SUBDIRECTORY(Testing)
endif()

#-----------------------------------------------------------------------------
# Packaging
#-----------------------------------------------------------------------------
if( ${EXTENSION_NAME}_BUILD_SLICER_EXTENSION )
  set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${CMAKE_BINARY_DIR};${EXTENSION_NAME};ALL;/")
  include(${Slicer_EXTENSION_GENERATE_CONFIG})
  include(${Slicer_EXTENSION_CPACK})
endif()
