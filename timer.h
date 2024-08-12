#ifndef TIMER_H
#define TIMER_H

#include <chrono>

#define __INIT_TIMER__ std::chrono::steady_clock::time_point startTime, endTime; uint64_t elapsedMs;
#define __START_TIMER__ startTime = std::chrono::high_resolution_clock::now();
#define __END_TIMER__   endTime = std::chrono::high_resolution_clock::now(); elapsedMs = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();

#endif