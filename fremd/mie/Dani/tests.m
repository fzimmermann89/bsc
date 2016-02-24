% clear all

AccAng=10000;

% R=37e-9; % in m

ThetaMin=0;

% lambda = 60e-9;
% % Re = 1-5.50089339e-07;
% % Im = 0;%-3.43e-7;
% Re = 1.0023;
% Im = 0;
% ThetaMax=40;

lambda = 1.053e-9;
% Re = 1-5.50089339e-07;
% Im = 0;%-3.43e-7;
Re = 1-0.000353208394;
Im = 0.000220323403;

% %rho = 1
% Re = 1-9.34413765e-5;
% Im = -5.8286616e-5;
% %rho = 2
% Re = 1-0.000186882753;
% Im = -0.000116573232;
% %rho = 3
% Re = 1-0.000280324108;
% Im = -0.000174859844;
% %rho = 4
% Re = 1-0.000373765506;
% Im = 0.000233146464;

ThetaMax=5;

% lambda = 13.5e-9;
% % Re = 1+4.83081112e-6;
% % Im = -7.34339483e-5;
% % Re = 1+0.00311051914;
% % Im = -0.0471498296;
% ThetaMax=5;

% %rho = 1
% Re = 1+0.000820589659;
% Im = 0.0124739166;
% %rho = 2
% Re = 1+0.0016411793;
% Im = 0.0249478333;
% %rho = 3
% Re = 1+0.0024617689;
% Im = 0.0374217518;
% %rho = 4
% Re = 1+0.00328235864;
% Im = 0.0498956665;


k0=2*pi/lambda;

InputMatrix(1,1)=R*k0;
InputMatrix(1,2)=R*k0;
InputMatrix(1,3)=AccAng;
InputMatrix(2,1)=Re;
InputMatrix(2,2)=Re;
InputMatrix(2,3)=ThetaMin;
InputMatrix(3,1)=Im;
InputMatrix(3,2)=Im;
InputMatrix(3,3)=ThetaMax;
fid=fopen('Parameter_in.txt','w');
fprintf(fid,'%5.0f %1.8f %1.8f \n', InputMatrix);
fclose(fid);
Parameter{1,1}=InputMatrix;

system('MieCalculation_CoatedSphere_ShenJianqi_Intensity.exe')
pause(1)
fid=fopen('Mie_Coated_TA.txt','r');
Streumatrix=textscan(fid,'%f32 %f64 %f64 %f64','HeaderLines', 1);
% Streumat = dlmread('Mie_Coated_TA.txt','\t','A2..end');
fclose(fid);
Winkel=Streumatrix{1,1};
Itotal = (Streumatrix{1,4});
Itotal = Itotal/max(Itotal);
% Isenkrecht=double(Streumatrix{1,2});
% Isenkrecht = Isenkrecht/max(Isenkrecht);
figure (1); 
plot(Winkel,log(Itotal)); xlim([ThetaMin,ThetaMax]);hold on;

% GUINIER
theta = double(Winkel)/360*2*pi;
q = theta*2*pi/lambda;

G = (3*(sin(q.*R)-q.*R.*cos(q.*R))./(q.^3*R^3)).^2;
G = G/max(G);

plot(Winkel,log(G),'-.g'); 

% AIRY
BZ = besselj(1,q*R)./(q*R/2);
BZ2 = BZ.^2;
BZ2 = BZ2/max(BZ2);

plot(Winkel,log(BZ2),'-.r');hold off;
legend('Mie','Guinier','Airy');

% über q

sc = q*R/2/pi;
figure(2);
plot(sc,log(Itotal),sc,log(G),sc,log(BZ2))
legend('Mie','Guinier','Airy');
title(['lambda = ',num2str(lambda*1e9),'nm']);
ylabel('log(Intensity) [arb. units]');
xlabel('qR');
hold on;