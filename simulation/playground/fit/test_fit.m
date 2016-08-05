
%% prepare
N=4*1024;
%all units are in nm
wavelength=1;
dx=wavelength;
dz=dx/2;

radius=2.5;
beta=1e-2;
delta=1e-4;

objects=cell(1);
objects{1}=scatterObjects.sphere();
objects{1}.beta=beta;%0.01;%1.78E-4;
objects{1}.delta=delta;%0.01%0.01;%1.34E-5;
objects{1}.radius=radius;


currun=singlerun(N,dx,dz,wavelength,objects);

x=currun.profiles_x;
rmulti=currun.profiles_y.multislice;

%% fit besser

[f,gof]=fitmie(x,rmulti,wavelength,radius,beta,delta);
f
gof
figure(2)
plot(f,x,log(rmulti));
%% minima

rmulti=rmulti(2:end);
x=x(2:end);
[ymin,xmin]=findpeaks(-log(rmulti),x,'MinPeakDistance',0.02);ymin=-ymin;


%% fit
% ft = fittype( 'log(fitmie(x,radius,beta,delta))' );
% options = fitoptions(ft);
% options.StartPoint=[ beta, delta,radius];
% % options.Lower=[beta/10,delta/10,radius/2];
% % options.Upper=[beta*10,delta*10,radius*2];
% 
% 
% options.Algorithm='Levenberg-Marquardt';
% options.DiffMinChange=0;
% options.Display='Iter';
% options.MaxFunEvals= 1000;
% options.MaxIter= 100;
% options.TolFun=0;
% options.TolX=0;
% 
% 
% [f,gof] =  fit( x, log(rmulti), ft,options);
% % ft = fittype( 'log(fitmie(x,radius))' );
% 
% % f = fit( x, rmulti, ft, 'StartPoint', [radius],   'Lower', [radius/2],'Upper',[radius*2]);
% 
% figure(1)
% plot( f, x, log(rmulti) )
% 
% % set(gca, 'yscale', 'log')
% 

%% fit minima
n=length(xmin);
fun=@(r) fitmin(x,r,n)-xmin;
options = optimoptions('lsqnonlin');
options.DiffMinChange=0;
options.Display='Iter';
options.MaxFunEvals= 1000;
options.MaxIter= 1000;
options.TolFun=0;
options.TolPCG=0;
options.TolX=0;
f2 = lsqnonlin(fun,2,1,3,options);

%% fit minima2
n=length(xmin);
fun=@(r) sum((fitmin(x,r,n)-xmin).^2);
options = optimoptions('fminunc');
options.DiffMinChange=0;
options.Display='Iter';
options.MaxFunEvals= 1000;
options.MaxIter= 1000;
options.TolFun=0;
options.TolPCG=0;
options.TolX=0;
f3 = fminunc(fun,radius,options);