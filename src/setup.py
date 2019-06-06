#cython: language_level=3
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(
        ["scheduler.pyx", "control.pyx", "alphabot.pyx", "utils.pyx", "test.pyx", "cpp_utils.pyx", "alphabot_hpi.pyx"], annotate=True, language_level=3),
    requires=['Cython'],
)
