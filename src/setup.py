from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(
        ["scheduler.pyx", "control.pyx", "alphabot.pyx", "test.pyx"], annotate=True),
)
