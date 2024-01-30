@echo off

del /q build
cmake .
make
