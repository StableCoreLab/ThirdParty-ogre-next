@echo off
setlocal

cd /d "%~dp0"

set "OGRE_SOURCE_DIR=%CD%"
REM Set build directory to sibling 'Build\OgreNextVS2022' (parallel to ThirdParty-SARibbon)
set "OGRE_BUILD_DIR=%~dp0..\Build\OgreNextVS2022"
set "OGRE_DEPENDENCIES_DIR=%CD%\..\FreeImage\Dist\x64"
set "FREEIMAGE_HOME=%OGRE_DEPENDENCIES_DIR%"

if not exist "%OGRE_SOURCE_DIR%\CMakeLists.txt" (
    echo Source directory not found: "%OGRE_SOURCE_DIR%"
    exit /b 1
)

if not exist "%OGRE_BUILD_DIR%" (
    mkdir "%OGRE_BUILD_DIR%"
)

cmake --fresh -S "%OGRE_SOURCE_DIR%" -B "%OGRE_BUILD_DIR%" -G "Visual Studio 17 2022" -A x64 ^
    -DOGRE_DEPENDENCIES_DIR="%OGRE_DEPENDENCIES_DIR%" ^
    -DOGRE_CONFIG_ENABLE_FREEIMAGE=OFF ^
    -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=OFF ^
    -DOGRE_BUILD_RENDERSYSTEM_VULKAN=OFF ^
    -DOGRE_BUILD_SAMPLES2=OFF ^
    -DOGRE_BUILD_TOOLS=OFF ^
    -DOGRE_BUILD_PLUGIN_PFX=OFF ^
    -DOGRE_BUILD_PLUGIN_PFX2=OFF

endlocal
