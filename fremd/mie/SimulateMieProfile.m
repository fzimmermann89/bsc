%% Mie Simulation of radial profiles %%
% make Mie Simulation
% store
% made by Leonie
%%%%%%%%%%%%%%%%%%

%% make Mie Simulation
% clear all
mprime=1-1e-07;                % real part of refractive-index  
m2prime=-1e-07;             % imaginary part of refractive-index  
lambda=1;
k0=2*pi/lambda;          % vacuum wave number in 1/nm
m=mprime-1i*m2prime;     % complex refractive-index ratio
nsteps=10000;             % Number of steps
type=0;                  % type ='pol' for polar diagram, else cartesian; z.B.: type=0;
%create array for x-axis
nx=(1:nsteps);
deltateta=pi/(nsteps-1);
xteta=(nx-1).*deltateta;
xtetad=xteta*180/pi;

%% choose radius 
clear a SL1 SL2 
R1=37;         % choose sphere radius in nm
x1=k0*R1;                                             %size parameter
result1 = Mie_tetascan(m, x1, nsteps, type);          %calculate Matrix of mie efficiencies
SL1=result1(1,:);
SR1=result1(2,:);

%%
[maxtab,mintab]=peakdet(SR1,1e-8);
mintabTheta = xtetad(uint16(mintab(:,1)));

% % plot simulation with measured data
figure(1)
semilogy(xtetad,SR1,'r'); xlim([0 3]); hold on % mie simulation 
title(sprintf('simulated mie profile for cluster radius %g nm, lambda = %g nm, 1st min %g°',R1,lambda,mintabTheta(1,1))); hold off
xlabel('angle / degree');
ylabel('intensity / arb.u.');


% % save Mie simulation %%%%
radprofile = [rot90(xtetad) rot90(SR1)];
save(['SimulatedMieProfile_R=' num2str(R1) 'nm_lambda=' num2str(lambda) 'nm_n2=' num2str(m2prime) '.txt'], 'radprofile', '-ascii');




