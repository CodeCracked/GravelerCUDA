#ifndef ANALYSIS_H
#define ANALYSIS_H

#include <stdint.h>

struct AnalysisResult
{
	uint8_t min = 255;
	uint8_t max = 0;
};

AnalysisResult analyze(uint8_t* array, uint64_t count);

#endif