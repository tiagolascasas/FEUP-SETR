# distutils: language=c++

cdef extern from "utils.cpp":
    void test()

cdef extern from "utils.cpp":
   float timer_monotonic()