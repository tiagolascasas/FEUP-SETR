setlocal
for %i in (*.c) do if not "%~i" == utils.c del "%~i"
del /Q /F /S "*.html"
del /Q /F /S "*.pyd"
rd /S /Q "build"