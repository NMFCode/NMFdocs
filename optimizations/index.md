# Optimizations

NMF Optimizations is a subproject that was intended to support any optimizations. So far, it only contains some code to support multi-criterial optimizations based on benchmarks.
In particular, a Pareto-filter has been implemented as well as a logic to repeat benchmarks and taking their average result.

For actually executing benchmarks and taking their time as a metric, NMF Optimizations is not a good choice (as is not intended to be), please use [Benchmark.NET](https://benchmarkdotnet.org/) in that case.