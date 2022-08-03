.PHONY: build clean debug release 

build:
	 cmake --build build

debug:
		mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug ..

release:
		cmake -S . -B build -D CMAKE_BUILD_TYPE=Release

clean:
	 @rm -rf build