#include "analysis.h"
#include "timer.h"

#include <iostream>
#include <cstdlib>

AnalysisResult analyze(uint8_t* array, uint64_t count)
{
	AnalysisResult result{ array[0], array[0] };
	for (uint64_t i = 1; i < count; i++)
	{
		uint8_t value = array[i];
		result.min = std::min(result.min, value);
		result.max = std::max(result.max, value);
	}

	return result;
}
