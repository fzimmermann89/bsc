function [xtetad, radprof] = SimulateMieProfile(mprime, m2prime, lambda, radius, nsteps)
% Simulate Mie profile for scattering of light on a small sphere
% Uses scripts for Mie Scattering by C. Mätzler

k0=2*pi/lambda;          % vacuum wave number in 1/nm
m=1-mprime-1i*m2prime;     % complex refractive-index ratio
type=0;                  % type ='pol' for polar diagram, else cartesian; z.B.: type=0;

%create array for x-axis
nx=(1:nsteps);
deltateta=pi/(nsteps-1);
xteta=(nx-1).*deltateta;
xtetad=xteta*180/pi;

x1=k0*radius;       %size parameter
MieEffMatrix = Mie_tetascan(m, x1, nsteps, type);          %calculate Matrix of mie efficiencies
SL1=MieEffMatrix(1,:);
SR1=MieEffMatrix(2,:);

radprof = SR1;