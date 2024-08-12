#include <iostream>
#include <string>
#include <sstream>
#include <cstdlib>

#include "simulation.h"
#include "analysis.h"
#include "timer.h"

uint64_t prompt_uint64(std::string prompt, uint64_t default = 0);
AnalysisResult runSimulations(uint64_t count);

int main()
{
	int seed = time(NULL);
	srand(seed);

	// Prompt Simulation Count
	uint64_t simulations = prompt_uint64("Enter the number of simulations", 100000000);
	uint64_t batchSize = prompt_uint64("Enter the batch size", 100000000);

	// Run Simulation
	__INIT_TIMER__;
	__START_TIMER__;
	AnalysisResult result{};
	uint64_t batchCount = static_cast<uint64_t>(std::ceil(simulations / static_cast<double>(batchSize)));
	uint64_t currentBatch = 1;
	while (simulations > 0)
	{
		uint64_t thisBatchSize = std::min(batchSize, simulations);
		simulations -= thisBatchSize;

		AnalysisResult batchResult = runSimulations(thisBatchSize);
		result.min = std::min(result.min, batchResult.min);
		result.max = std::max(result.max, batchResult.max);
		std::cout << "Finished Batch " << currentBatch++ << " of " << batchCount << std::endl;
	}
	__END_TIMER__
	
	// Print Results
	std::cout << std::endl;
	std::cout << "Minimum Ones Rolled: " << static_cast<int>(result.min) << ", Maximum Ones Rolled: " << static_cast<int>(result.max) << std::endl;
	std::cout << "Time elapsed: " << (elapsedMs / 1000) << " seconds." << std::endl;
	std::cout << "Seed: " << seed << std::endl;

	// Pause
	system("pause");
	return 0;
}

uint64_t prompt_uint64(std::string prompt, uint64_t default)
{
	std::string buffer;
	std::cout << prompt << " (default: " << default << "): ";
	std::getline(std::cin, buffer);

	do
	{
		if (buffer.size() == 0) return default;
		try { return std::stoull(buffer); }
		catch (std::invalid_argument const& ex) {}
		catch (std::out_of_range const& ex) {}
	} while (true);
}
AnalysisResult runSimulations(uint64_t count)
{
	uint8_t* simulationResults = simulate(rand(), count);
	AnalysisResult analysis = analyze(simulationResults, count);
	delete[] simulationResults;
	return analysis;
}