%%%%%%%%%% Only for cubic model (odd)
clear;
clc
load UCLAsample.mat

Ssize = 7;
Tsize = 23;  

HSsize = (Ssize-1)/2;
Scenter = HSsize+1;
Tcenter = (Tsize+1)/2;
Od_cal = pi*(Tsize*Tsize) / (2*Ssize*Ssize*Ssize)

Rtot = zeros(Tsize,Tsize,Tsize);
Rtot(Tcenter-HSsize:Tcenter+HSsize,Tcenter-HSsize:Tcenter+HSsize,Tcenter-HSsize:Tcenter+HSsize) = UCLAsample;

Fktot = fftshift(fftn(Rtot));
Ftot = abs(Fktot);

%%%%%%%%%% Count k-points in the shell
Mcount = zeros(Tsize,Tsize,Tsize);
for a = 1:Tsize
    for b = 1:Tcenter
        for c = 1:Tsize
            if (sqrt((a-Tcenter)^2+(b-1)^2+(c-Tcenter)^2)<(Tcenter-1+0.5))&(sqrt((a-Tcenter)^2+(b-1)^2+(c-Tcenter)^2)>(Tcenter-1-0.5))
                Mcount(a,b,c) = 1;
            end
        end
    end
end
for l = 1:Tsize
    Mcount(:,Tcenter+1:Tsize,l) = fliplr(Mcount(:,1:Tcenter-1,l));
end

Kpointnum = sum(sum(sum(Mcount)));
Rhonum = Ssize*Ssize*Ssize;
Od_real = Kpointnum / (2*Rhonum)
%%%%%%%%%%

Ftot(Mcount==0) = -1;
[R3D_best Min_errorF] = HIO3D(Ftot,[Ssize Ssize Ssize],500,1);
