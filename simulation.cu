#include "simulation.h"
#include "timer.h"

#include <cuda_runtime.h>
#include <curand.h>
#include <curand_kernel.h>
#include <device_launch_parameters.h>
#include <iostream>

__global__ void simulateGravelers(uint64_t seed, uint8_t* results, curandState* state, uint64_t simulations)
{
	uint64_t idx = blockDim.x * blockIdx.x + threadIdx.x;
	if (idx < simulations)
	{
		curand_init(seed, idx, 0, &state[idx]);
		uint8_t zeroes = 5;
		for (uint8_t i = 0; i < 231; i++) if (curand(&state[idx]) % 4 == 0) zeroes++;
		results[idx] = zeroes;
	}
}

uint8_t* simulate(uint64_t seed, uint64_t simulations)
{
	// Allocate cuRAND states
	curandState* d_state;
	cudaMalloc(&d_state, simulations * sizeof(curandState));

	// Allocate results buffer
	uint8_t* d_results;
	cudaMalloc(&d_results, simulations);

	// Run simulation kernel
	int threadsPerBlock = 256;
	int blockCount = static_cast<int>(std::ceil(simulations / static_cast<double>(threadsPerBlock)));
	simulateGravelers<<<blockCount, threadsPerBlock>>>(seed, d_results, d_state, simulations);
	
	// Get results
	uint8_t* results = new uint8_t[simulations];
	cudaMemcpy(results, d_results, simulations, cudaMemcpyDeviceToHost);

	cudaFree(d_state);
	cudaFree(d_results);
	return results;
}
