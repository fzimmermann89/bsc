clear all
lambda=13.5e-9; % in m
m1=0.99+1i*0.044; % m'+i*m''
SummenProfil=uint32(zeros(500,1));
R=600e-9; % in m

for j=1:10%70
m2=(0.97-j*0.005)+1i*(0.004); % m'+i*m''-j*0.006
AccAng=500;
ThetaMin=0;
ThetaMax=40;
Rem1=real(m1);
Imm1=imag(m1);
Rem2=real(m2);
Imm2=imag(m2);
d=20e-9+j*5e-9;%0.8* 9e-8-j*2e-9;%in m
pen=1.07e-9/Imm2;
d=pen;
if d>pen
    d=1.07e-9/Imm2;
end
% if j<3
%     m1=1.007+1i*0.04;
%     m2=m1;
% end
% if j>2&&j<5
%     
% end
Rem1=real(m1);
Imm1=imag(m1);
Rem2=real(m2);
Imm2=imag(m2);
a=R-d;
b=R;
k0=2*pi/lambda;
x=round(k0*a);
y=round(k0*b);
InputMatrix(1,1)=x;
InputMatrix(1,2)=y;
InputMatrix(1,3)=AccAng;
InputMatrix(2,1)=Rem1;
InputMatrix(2,2)=Rem2;
InputMatrix(2,3)=ThetaMin;
InputMatrix(3,1)=Imm1;
InputMatrix(3,2)=Imm2;
InputMatrix(3,3)=ThetaMax;
fid=fopen('Parameter_in.txt','w');
fprintf(fid,'%4.0f %8.3f %8.3f\n', InputMatrix);
fclose(fid);
Parameter{j,1}=InputMatrix;
system('MieCalculation_CoatedSphere_ShenJianqi_Intensity.exe')
pause(1)
fid=fopen('Mie_Coated_TA.txt','r');
Streumatrix=textscan(fid,'%f32 %u %u %u','HeaderLines', 1);
fclose(fid);
Winkel=Streumatrix{1,1};
Isenkrecht=Streumatrix{1,2}+1e3;
SummenProfil=SummenProfil+Isenkrecht*2*j;
figure (1)
semilogy(Winkel,Isenkrecht*(3*j)); xlim([5,30]); hold all%+j*2e4
Zehn=j/10-round(j/10);
if j>1%&&Zehn==0
figure (2)
semilogy(Winkel,SummenProfil); xlim([5,30]);hold all%+j*2e4
Legende(j,1)=d;
end
end
figure(1)
legend(num2str(Legende));
figure(2)
legend(num2str(Legende));

%%
m2=(0.938)+1i*(0.011);
AccAng=500;
ThetaMin=3;
ThetaMax=32;
Rem1=real(m1);
Imm1=imag(m1);
Rem2=real(m2);
Imm2=imag(m2);
d=0.6*1e-9/Imm2;%5e-8;%0.5*1.07e-9/Imm2; % in m
a=R-d;
b=R;
k0=2*pi/lambda;
x=round(k0*a);
y=round(k0*b);
InputMatrix(1,1)=x;
InputMatrix(1,2)=y;
InputMatrix(1,3)=AccAng;
InputMatrix(2,1)=Rem1;
InputMatrix(2,2)=Rem2;
InputMatrix(2,3)=ThetaMin;
InputMatrix(3,1)=Imm1;
InputMatrix(3,2)=Imm2;
InputMatrix(3,3)=ThetaMax;
fid=fopen('Parameter_in.txt','w');
fprintf(fid,'%4.0f %8.3f %8.3f\n', InputMatrix);
fclose(fid);
system('MieCalculation_CoatedSphere_ShenJianqi_Intensity.exe')
pause(1)
fid=fopen('Mie_Coated_TA.txt','r');
Streumatrix=textscan(fid,'%f32 %u %u %u','HeaderLines', 1);
fclose(fid);
Winkel=Streumatrix{1,1};
Isenkrecht=Streumatrix{1,2}+1e3;
figure (1)
semilogy(Winkel,Isenkrecht*(3*20)+20*2e4); xlim([5,30]); hold all%




