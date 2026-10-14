@REM ----------------------------------------------------------------------------
@REM Maven Wrapper for Windows (DLMS Project)
@REM ----------------------------------------------------------------------------
@IF "%DEBUG%" == "" @ECHO OFF
@SETLOCAL EnableExtensions EnableDelayedExpansion

SET "DIRNAME=%~dp0"
IF "%DIRNAME%" == "" SET "DIRNAME=."

SET "WRAPPER_JAR=%DIRNAME%\.mvn\wrapper\maven-wrapper.jar"
SET "WRAPPER_PROPERTIES=%DIRNAME%\.mvn\wrapper\maven-wrapper.properties"

@REM If maven is already on path, use it directly
WHERE mvn >nul 2>nul
IF %ERRORLEVEL% EQU 0 (
    mvn %*
    EXIT /B %ERRORLEVEL%
)

@REM Check for installed Maven in common directories
IF EXIST "C:\ProgramData\chocolatey\lib\maven\apache-maven-*\bin\mvn.cmd" (
    FOR /D %%i IN ("C:\ProgramData\chocolatey\lib\maven\apache-maven-*") DO (
        "%%i\bin\mvn.cmd" %*
        EXIT /B %ERRORLEVEL%
    )
)

IF EXIST "C:\apache-maven-*\bin\mvn.cmd" (
    FOR /D %%i IN ("C:\apache-maven-*") DO (
        "%%i\bin\mvn.cmd" %*
        EXIT /B %ERRORLEVEL%
    )
)

ECHO Maven is not currently in PATH. Please install Maven or use VS Code Java Extension Pack.
ECHO In VS Code, open this folder and use the Maven panel or Command Palette: 'Java: Run'.
EXIT /B 1
