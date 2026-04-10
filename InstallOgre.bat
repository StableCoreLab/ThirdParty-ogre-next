@echo off
setlocal

cd /d "%~dp0"

set "OGRE_SOURCE_DIR=%CD%"
set "OGRE_BUILD_DIR=%~dp0..\Build\OgreNextVS2022"
set "OGRE_SDK_DIR=%~dp0..\sdk"
set "OGRE_BIN_ROOT=%~dp0..\bin\x64"

if not exist "%OGRE_BUILD_DIR%\include\OgreBuildSettings.h" (
    echo Missing generated headers in "%OGRE_BUILD_DIR%\include".
    echo Build OgreNext first, then run this script.
    exit /b 1
)

if not exist "%OGRE_SDK_DIR%\include" mkdir "%OGRE_SDK_DIR%\include"
if not exist "%OGRE_SDK_DIR%\lib" mkdir "%OGRE_SDK_DIR%\lib"
if not exist "%OGRE_SDK_DIR%\bin" mkdir "%OGRE_SDK_DIR%\bin"

rem Copy generated build settings headers
copy /Y "%OGRE_BUILD_DIR%\include\OgreBuildSettings.h" "%OGRE_SDK_DIR%\include\" >nul
copy /Y "%OGRE_BUILD_DIR%\include\OgreGL3PlusBuildSettings.h" "%OGRE_SDK_DIR%\include\" >nul
copy /Y "%OGRE_BUILD_DIR%\include\OgreVulkanBuildSettings.h" "%OGRE_SDK_DIR%\include\" >nul

rem Copy public headers from the source tree
if not exist "%OGRE_SDK_DIR%\include\OGRE-Next" mkdir "%OGRE_SDK_DIR%\include\OGRE-Next"
robocopy "%OGRE_SOURCE_DIR%\OgreMain\include" "%OGRE_SDK_DIR%\include\OGRE-Next" *.h *.inl /E /NFL /NDL /NJH /NJS /NP >nul
for /d %%D in ("%OGRE_SOURCE_DIR%\Components\*\include") do (
    robocopy "%%~fD" "%OGRE_SDK_DIR%\include" *.h *.inl /E /NFL /NDL /NJH /NJS /NP >nul
)
for /d %%D in ("%OGRE_SOURCE_DIR%\RenderSystems\*\include") do (
    robocopy "%%~fD" "%OGRE_SDK_DIR%\include" *.h *.inl /E /NFL /NDL /NJH /NJS /NP >nul
)

rem Copy binaries produced by the build into the SDK layout
for %%C in (Debug Release RelWithDebInfo MinSizeRel) do (
    if exist "%OGRE_BIN_ROOT%\%%C" (
        if not exist "%OGRE_SDK_DIR%\bin\%%C" mkdir "%OGRE_SDK_DIR%\bin\%%C"
        if not exist "%OGRE_SDK_DIR%\lib\%%C" mkdir "%OGRE_SDK_DIR%\lib\%%C"
        robocopy "%OGRE_BIN_ROOT%\%%C" "%OGRE_SDK_DIR%\bin\%%C" *.dll *.pdb /NFL /NDL /NJH /NJS /NP >nul
        robocopy "%OGRE_BIN_ROOT%\%%C" "%OGRE_SDK_DIR%\lib\%%C" *.lib /NFL /NDL /NJH /NJS /NP >nul
    )
)

echo SDK updated at "%OGRE_SDK_DIR%".
endlocal
