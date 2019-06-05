setlocal
attrib +r utils.cpp
del /Q /S "*.cpp"
attrib -r utils.cpp
del /Q /F /S "*.html"
del /Q /F /S "*.pyd"
rd /S /Q "build"