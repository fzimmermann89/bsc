function output = absorption(handles)
% This function implements the absorption and adds a phase to the
% scattering data depending on the refractive index. It needs the
% handles-Object and returns the scattering data. When two different
% absorption and/or refraction indices should be taken into account, the
% data for the second one must be > 1.

absFac1 = str2double(get(handles.absFac1_edit,'String'));
refFac1 = str2double(get(handles.refFac1_edit,'String'));
absFac2 = str2double(get(handles.absFac2_edit,'String'));
refFac2 = str2double(get(handles.refFac2_edit,'String'));

if absFac1~=0 || absFac2~=0 || refFac1~=0 || refFac2~=0
    % if all absorption and refraction indices are set to zero, the
    % function returns the unchanged scattering data.
    
    data = handles.current_data;
    lambda = str2double(get(handles.lambda_edit,'String'))*str2double(get(handles.voxel_edit,'String'));
    phasePerVoxel1 = 2*pi/lambda*refFac1;
    phasePerVoxel2 = 2*pi/lambda*refFac2;
    absFac1 = exp(-2*pi/lambda*absFac1);
    absFac2 = exp(-2*pi/lambda*absFac2);
    N = size(handles.current_data,1);
    output = zeros(N,N,N);
    tempAbs = zeros(N,N); %#ok<NASGU>
    tempPhase = zeros(N,N);
    
    wBar=waitbar(0,'0','Name', 'Calculating absorption ...',...
        'CreateCancelBtn',...
        'setappdata(gcbf,''canceling'',1)');
    setappdata(wBar,'canceling',0)
    
    output(:,:,1) = data(:,:,1);
    
    for k = 2:N
        if getappdata(wBar,'canceling')
            break
        end
        tempAbs = data(:,:,k);
        if sum(sum(tempAbs))>0
            tempLogic = data(:,:,k-1)>0 & data(:,:,k)>0;
            tempLogic2 = data(:,:,k-1)>1;
            tempAbs = tempAbs.*~tempLogic + tempLogic.*data(:,:,k-1)*absFac1...
                                          + tempLogic2.*data(:,:,k-1)*absFac2;
            tempLogic = data(:,:,k)>0;
            tempLogic2 = data(:,:,k)>1;
            tempPhase = tempPhase + tempLogic.*data(:,:,k)*phasePerVoxel1...
                                  + tempLogic2.*data(:,:,k)*phasePerVoxel2;
            output(:,:,k) = tempAbs.*exp(1i*tempPhase);
        end
        waitbar(k/N,wBar,strcat(num2str(toc),' seconds elapsed'));
    end
    
    delete(wBar);
    
else
    output=handles.current_data;
end