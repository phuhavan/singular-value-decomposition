# Singular Value Decomposition algorithm for estimating channel in UWB, OFDM/MIMO

Singular value decomposition (SVD) allows the factorization of real or complex matrices providing quantitative information
with fewer dimensions along which data points exhibit more variation. These days SVD computation is being used in
numerous applications, and because of its importance, different approaches for SVD hardware computation have been
proposed. In this project, I focus on comparison of architecture variants in the context of resource allocation, speed and
accuracy. An implementation of an SVD hardware for 8 x 4 matrices over complex fixed-point signed fraction data, based
on the CORDIC algorithm. It uses parallel-architecture-supported CORDIC cores that are suitable for streamed data
processing. A prototype was implemented on FPGA development boards (Xilinx XC6SLX45).
