function [rdat,xcoord,ycoord] = rscan(data,varargin),
%https://de.mathworks.com/matlabcentral/fileexchange/18102-radial-scan
% RDAT = RSCAN(M0,VARARGIN)
% Get radial scan of a matrix using the following procedure:
% [1] Get coordinates of a circle around an origin.
% [2] Average values of points where the circle passes through.
% [3] Change radius of the circle and repeat [1] until rprofile is obtained.
%
% For DEMO, run
% >> rscan_qavg();
% or
% >> rscan_qavg('demo','dispflag',0);
% >> plot(ans);
% or
% >> rdat = rscan_qavg();
% >> plot(rdat);
% or
% >> a = peaks(300);
% >> rscan_qavg(a);
% >> rscan_qavg(a,'rlim',50,'xavg',100);
% >> rscan_qavg(a,'rlim',25,'xavg',100,'dispflag',1,'dispflagc',1);
% >> rscan_qavg(a,'rlim',25,'xavg',100,'dispflag',1,'dispflagc',1, ...
%    'squeezx',0.7,'rot',pi/4);
%
% Draw Circle:
% [ref] http://www.mathworks.com/matlabcentral/fileexchange/
%       loadFile.do?objectId=2876&objectType=file


yxz = size(data);
xcenter = yxz(2)/2+1;
ycenter = yxz(1)/2+1;

Rlim = floor(min(yxz)/2)-1;

rstep = 1;

for nRho = 1:rstep:Rlim,
    NOP = round(2*pi*nRho);
    THETA=linspace(0,2*pi,NOP);
    RHO=ones(1,NOP)*round(nRho);
    [X,Y] = pol2cart(THETA,RHO);
    X = round(X + xcenter);
    Y = round(Y + ycenter);


    clear dat uxy pxy mxy mx nx my ny;
    dat = [X;Y];
    uxy = diff(dat,1,2);
    uxy = [[1;1],uxy];
    pxy = union(find(uxy(1,:)~=0),find(uxy(2,:)~=0));
    dat = dat(:,pxy);
    integ=data(yxz(1)*(dat(1,:)-1) + dat(2,:));
    integ=integ(integ>0);
    norm = length(integ);
    rdat(nRho) = sum(integ)/norm;
end



