function scatteringPicture = msft(handles)
% This function is the main scattering algorithm. It needs the handles-
% Object and returns the absolute square of the scattering picture. It
% implements a Multi Slice Fourier Transform algorithm without absorption
% and refractive index (see 'absorption.m'). 

N = size(handles.current_data,1);
fftN = str2double(get(handles.fftN_edit,'String'));
scatteringPicture = zeros(fftN,fftN);
temp = zeros (fftN,fftN); %#ok<NASGU>
% phaseMatrix = zeros(fftN,fftN);
tempPhase = zeros(fftN,fftN); %#ok<NASGU>
% eraseMatrix = zeros(fftN,fftN);
voxelScale = str2double(get(handles.voxel_edit,'String'));
kScaleQ = 4*pi*pi/(fftN*fftN)*voxelScale*voxelScale;
lambda = str2double(get(handles.lambda_edit,'String'));
% detDist = str2double(get(handles.detDist_edit,'String'));
% detSize = str2double(get(handles.detSize_edit,'String'));

kMag = 2*pi/lambda;
% kParMax = 2*pi/lambda*(detSize/2/detDist)/sqrt(1+(detSize/2/detDist)^2);
% maxRange = round(kParMax/2*pi*fftN/voxelScale/2)+1;

% maxRange = fftN/lambda/voxelScale/2;

tic

handles.current_data = absorption(handles);

wBar=waitbar(0,'0','Name', 'Calculating scattering picture ...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(wBar,'canceling',0);

[X Y] = meshgrid(-fftN/2+1:fftN/2,-fftN/2+1:fftN/2);
phaseMatrix =  1/voxelScale*(sqrt(kMag*kMag-(X.^2+Y.^2)*kScaleQ)-kMag);
eraseMatrix = kMag*kMag-(X.^2+Y.^2)*kScaleQ > 0;
phaseMatrix = phaseMatrix.*eraseMatrix;

% current_data = handles.current_data;

for m=1:N
    if getappdata(wBar,'canceling')
        break
    end
    
    temp = fftshift(fft2(handles.current_data(:,:,m),fftN,fftN)); % pick slice
    if any(temp)
        tempPhase = angle(temp)+ m*phaseMatrix;
        temp = abs(temp).*exp(1i*tempPhase);
        scatteringPicture = scatteringPicture + temp;
    end
    waitbar(m/N,wBar,strcat(num2str(toc),' seconds elapsed'));
end

% This part is for dependency of the scattering picture of the detector
% distance. Not yet implemented correctly.

% temp = scatteringPicture;
% detDist=str2num(get(handles.detDist_edit,'String')); %#ok<ST2NM>
% for i = -N/2+1 : N/2
%     for j = -N/2+1 : N/2
%         scatteringPicture(i+N/2,j+N/2) = temp(i+N/2,j+N/2)*kMag^2*(1-(i^2+j^2)/(detDist^2+i^2+j^2))/detDist^2*N^2;
%         %scatteringPicture(i+N/2,j+N/2) = temp(round(i/sqrt(i^2+j^2+detDist^2)*kMag+N/2),round(j/(i^2+j^2+detDist^2)*kMag+N/2))*kMag^2*(1-(i^2+j^2)/(detDist^2+i^2+j^2))^2/detDist^2*N^2/2/pi^2;
%     end
% end

toc
delete(wBar);
negLog2(handles,scatteringPicture); % zum Anschauen der Phase
scatteringPicture = eraseMatrix.*abs(scatteringPicture).^2;
scatteringPicture = scatteringPicture./max(max(scatteringPicture));
