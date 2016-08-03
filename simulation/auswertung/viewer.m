function varargout = viewer(varargin)
    % viewer MATLAB code for viewer.fig
    % Explorer for beta, delta, radius multirun data
    
    % Last Modified by GUIDE v2.5 10-Jun-2016 18:07:16
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @viewer_OpeningFcn, ...
        'gui_OutputFcn',  @viewer_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before viewer is made visible.
function viewer_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    if (length(varargin)==1) && ischar(varargin{1}) && (exist(varargin{1}, 'file') == 2)
        
        handles=loaddata(handles,varargin{1});
        draw(handles);
    end
    
    guidata(hObject, handles);
end


function handles=loaddata(handles,path)
    try
        data=load(path);
        handles.N=data.N;
        handles.wavelength=data.wavelength;
        handles.dx=data.dx;
        handles.dz=data.dz;
        handles.beta=data.beta;
        handles.delta=data.delta;
        handles.radius=data.radius;
        handles.x=data.profiles_x;
        handles.y=data.profiles_y;
        handles.mie=data.profile_mie;
        handles.error_abs=data.errors_abs;
        handles.profiles_min=data.profiles_min;
        handles.profiles_max=data.profiles_max;
        handles.profiles_stdev=data.profiles_stdev;
        clear data;
        
        handles.uN=unique(handles.N); handles.list_N.String=cellstr(num2str(handles.uN','%d'));
        handles.uwavelength=unique(handles.wavelength); handles.list_wavelength.String=cellstr(num2str(handles.uwavelength','%0.2f nm'));
        handles.udx=unique(handles.dx); handles.list_dx.String=cellstr(num2str(handles.udx','%.5g'));
        handles.udz=unique(handles.dz); handles.list_dz.String=cellstr(num2str(handles.udz','%.5g'));
        handles.ubeta=unique(handles.beta); handles.list_beta.String=cellstr(num2str(handles.ubeta','%.2e'));
        handles.udelta=unique(handles.delta); handles.list_delta.String=cellstr(num2str(handles.udelta','%.2e'));
        handles.uradius=unique(handles.radius); handles.list_radius.String=cellstr(num2str(handles.uradius','%.2f nm'));
        
        handles.list_N.Value=1;
        handles.list_wavelength.Value=1;
        handles.list_dx.Value=1;
        handles.list_dz.Value=1;
        handles.list_radius.Value=1;
        handles.list_beta.Value=1;
        handles.list_delta.Value=1;
        
        
        handles.axes.Visible='on';
        handles.p_param.Visible='on';
        handles.p_settings.Visible='on';
    catch
        warning('could not load data')
    end
end


function draw(handles)
    cla(handles.axes);
    N=handles.uN(handles.list_N.Value);
    wavelength=handles.uwavelength(handles.list_wavelength.Value);
    dx=handles.udx(handles.list_dx.Value);
    dz=handles.udz(handles.list_dz.Value);
    beta=handles.ubeta(handles.list_beta.Value);
    delta=handles.udelta(handles.list_delta.Value);
    radius=handles.uradius(handles.list_radius.Value);
    
    id=find((handles.N==N)&(handles.wavelength==wavelength)&(handles.dx==dx)&(handles.dz==dz)&(handles.beta==beta)&(handles.delta==delta)&(handles.radius==radius));
    if numel(id)==1
        x=handles.x(:,id);
        valmie=normalize(handles.mie(:,id));
        valalgos= structfun(@(x)normalize(x),handles.y(id),'UniformOutput',false);
        
        labels={};
        if handles.rb_profile.Value
            %plot profiles, needs to plot mie
            
            
            %             [~,miesampled]=rprofil(mie_scatter(wavelength,radius,beta,delta,N,dx),N/2);
            %             m=handles.y(id).multislice;
            %             spanm=max(m(100:200))-min(m(100:200))
            %             offsetm=min(m(100:200))
            %             offsets=min(miesampled(100:200))
            %             spans=max(miesampled(100:200))-min(miesampled(100:200))
            %             miesampled=((miesampled-offsets)*(spanm/spans))+offsetm;
            %             x(100)
            %             x(200)
            
            
            
            
            
            
            %             ipx=(interp1(1:numel(x),x(:),linspace(1,numel(x),4*numel(x))))';
            %             [~,ipmie,~,~]=mie(1,radius,beta,delta,ipx);
            %             ipmie=(ipmie./max(ipmie(:)));
            %             hold on;
            %             plot(handles.axes,ipx,ipmie);
            
            hold on;
            plot(handles.axes,x,valmie,'-');
            labels{end+1}='mie';
            y=valalgos;
            %             plot(handles.axes,x,miesampled);
            %             labels{end+1}='miesampled';
        elseif handles.rb_abserr.Value
            
            %plot abs errors
%             offset=structfun(@(x)fminsearch(@(offset)sum(abs((offset+x(2:end/2)-valmie(2:end/2))./valmie(2:end/2))),0,optimset('Display','none','TolX',1e-10,'TolFun',1e-10)),valalgos,'UniformOutput',false)
%             a=structfun(@(x)sum(abs(x(2:end/2)-valmie(2:end/2))),valalgos,'UniformOutput',false)
%             f=fieldnames(valalgos);
%             for n=1:numel(f)
%                 valalgos.(f{n})=valalgos.(f{n})+offset.(f{n});
%             end
%             b=structfun(@(x)sum(abs(x(2:end/2)-valmie(2:end/2))),valalgos,'UniformOutput',false)
%             
%             y= structfun(@(x)abs((x-valmie)),valalgos,'UniformOutput',false);
%             
%             
%             offsetspan=structfun(@(x)fminsearch(@(offsetspan)sum(abs((((x(2:end/4)-min(x(2:end/4))*offsetspan(1)+offsetspan(2)))-valmie(2:end/4)))),[1,0],optimset('Display','none','TolX',1e-10,'TolFun',1e-10)),valalgos,'UniformOutput',false)
%                          offsetspan=structfun(@(x)fminsearch(...
%                        @(offsetspan) sum(abs(((x(2:end/4)-min(x(2:end/4)))*offsetspan(1)+offsetspan(2))-valmie(2:end/4))) ...
%                        ,[1,0], optimset('Display','none','TolX',1e-10,'TolFun',1e-10)),valalgos,'UniformOutput',false)
     offsetspan=structfun(@(x)fminsearch(...
                       @(offsetspan) sum(abs(((x(2:end/4)-offsetspan(3))*offsetspan(1)+offsetspan(2))-valmie(2:end/4))./valmie(2:end/4)) ...
                       ,[1,0,0], optimset('Display','none','TolX',1e-15,'TolFun',1e-15)),valalgos,'UniformOutput',false)
            
a=structfun(@(x)sum(abs(x(2:end/4)-valmie(2:end/4)))./numel(x(2:end/4)),valalgos,'UniformOutput',false)
            f=fieldnames(valalgos);
            for n=1:numel(f)
                val=valalgos.(f{n});
                curoffsetspan=offsetspan.(f{n});
                valalgos.(f{n})=(val-min(val(2:end/4)))*curoffsetspan(1)+curoffsetspan(2);
            end
            
            b=structfun(@(x)sum(abs(x(2:end/4)-valmie(2:end/4)))./numel(x(2:end/4)),valalgos,'UniformOutput',false)
            y= structfun(@(x)abs((x-valmie)),valalgos,'UniformOutput',false);
            
            
            
            %             algos = fieldnames(handles.error_abs(id));
            %             for n = 1:numel(algos)
            %                 cury=handles.y(id).(algos{n});
            %                 curerr=handles.error_abs(id).(algos{n});
            %                 y.(algos{n}) =abs( curerr);
            %             end
        else
            %plot rel errors
            
            %             algos = fieldnames(handles.error_abs(id));
            %             for n = 1:numel(algos)
            %                 cury=handles.y(id).(algos{n});
            %                 curerr=handles.error_abs(id).(algos{n});
            %                 y.(algos{n}) =abs( curerr./ cury);
            %             end
            %             y= structfun(@(a)log10(abs((a)./(handles.mie(:,id)))),handles.y(id),'UniformOutput',false);
            %             y= structfun(@(a)smooth((a-handles.mie(:,id))./handles.mie(:,id),10,'rloess'),handles.y(id),'UniformOutput',false);
            %             y= structfun(@(a)((a-handles.mie(:,id))./handles.mie(:,id)),handles.y(id),'UniformOutput',false);
            % offset=structfun(@(x)fminsearch(@(offset)sum((abs(x-valmie+offset)./valmie)),0),valalgos,'UniformOutput',false);
            %
            % f=fieldnames(valalgos);
            % for n=1:numel(f)
            %     valalgos.(f{n})=valalgos.(f{n})+offset.(f{n});
            % end
%             a=structfun(@(x)sum(abs(x(2:end/2)-valmie(2:end/2))./valmie(2:end/2)),valalgos,'UniformOutput',false)

%             offset=structfun(@(x)fminsearch(@(offset)sum(abs((offset+x(2:end/2)-valmie(2:end/2))./valmie(2:end/2))),0,optimset('Display','none','TolX',1e-10,'TolFun',1e-10)),valalgos,'UniformOutput',false)
%             a=structfun(@(x)sum(abs(x(2:end/2)-valmie(2:end/2))./valmie(2:end/2)),valalgos,'UniformOutput',false)
%             f=fieldnames(valalgos);
%             for n=1:numel(f)
%                 valalgos.(f{n})=valalgos.(f{n})+offset.(f{n});
%             end
            
            offsetspan=structfun(@(x)fminsearch(@(offsetspan)sum(abs((((x(2:end/4)-min(x(2:end/4)))*offsetspan(1)+offsetspan(2))-valmie(2:end/4))./valmie(2:end/4))),[1,0],optimset('Display','none','TolX',1e-10,'TolFun',1e-10)),valalgos,'UniformOutput',false)
            %-min(x(2:end/4))       
            offsetspan=structfun(@(x)fminsearch(...
                       @(offsetspan) sum(abs(((x(2:end/4)-offsetspan(3))*offsetspan(1)+offsetspan(2))-valmie(2:end/4))./valmie(2:end/4)) ...
                       ,[1,0,0], optimset('Display','none','TolX',1e-15,'TolFun',1e-15)),valalgos,'UniformOutput',false)
            
            a=structfun(@(x)sum(abs(x(2:end/4)-valmie(2:end/4))./valmie(2:end/4))./numel(x(2:end/4)),valalgos,'UniformOutput',false)
            f=fieldnames(valalgos);
            for n=1:numel(f)
                val=valalgos.(f{n});
                curoffsetspan=offsetspan.(f{n});
                valalgos.(f{n})=(val-curoffsetspan(3))*curoffsetspan(1)+curoffsetspan(2);
            end
            
            b=structfun(@(x)sum(abs(x(2:end/4)-valmie(2:end/4))./valmie(2:end/4))./numel(x(2:end/4)),valalgos,'UniformOutput',false)
            
            y= structfun(@(x)(abs(x-valmie)./valmie),valalgos,'UniformOutput',false);
            %                           structfun(@(x)(abs(x-valmie)./valmie),valalgos,'UniformOutput',false)
            %                              y= structfun(@(x)smooth(x,10,'moving'),y,'UniformOutput',false);
            
            
        end
        
        %         fac=@(a)exp(- (a-handles.mie(:,id)).^2 ./ handles.mie(:,id));
        %         structfun(@(a)prod(fac(a)),y,'UniformOutput',false)
        
        if handles.cb_msft.Value;
            plot(handles.axes,x,y.msft,'x');
            hold on;
            labels{end+1}='msft';
        end
        
        if handles.cb_thibault.Value;
            plot(handles.axes,x,y.thibault,'x');
            hold on;
            labels{end+1}='thibault';
        end
        
        if handles.cb_multislice.Value;
            plot(handles.axes,x,y.multislice,'x');
            hold on;
            labels{end+1}='multislice';
        end
        
        if handles.cb_FTproj.Value;
            plot(handles.axes,x,y.FTproj,'x');
            hold on;
            labels{end+1}='ft proj';
        end
        
        hold off;
        if handles.rb_profile.Value || handles.rb_abserr.Value
            %plot profiles, log scale
            handles.axes.YScale='log';
        else
            handles.axes.YScale='linear';
        end
        
        hold off;
        axis(handles.axes,'auto')
        handles.axes.XLim=[0 0.5];
        if ~isempty(labels); legend(handles.axes,labels); end
        drawnow;
        %
        %     figure(2)
        %     fn=fieldnames(handles.error_abs);
        %     for n=1:numel(fn)
        %         t=[handles.error_abs.(fn{n})];
        %         t=sum(abs(t(3:end/2,:)));
        %         plot(handles.radius,t);hold on;
        %     end
        %     hold off;
        %     legend(fn);
    end
end

function x=normalize(x)
    %     x=x./sum(x(2:end));
    x=x./sum(abs(x(2:end/2)));
    %        x=x./x(2);
    % x=x-x(2)+1;
    
    %     x=x-x(2)+1;
end
% --- Outputs from this function are returned to the command line.
function varargout = viewer_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end


% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
    [filename,path]=uigetfile({'*.mat';'*.dat'},'File Selector');
    file=fullfile(path,filename);
    handles=loaddata(handles,file);
    guidata(hObject, handles);
    draw(handles);
end


% --- Executes on button press in rb_profile.
function rb_profile_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in rb_relerr.
function rb_relerr_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in rb_abserr.
function rb_abserr_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_msft.
function cb_msft_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_multislice.
function cb_multislice_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_thibault.
function cb_thibault_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on button press in cb_FTproj.
function cb_FTproj_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes on selection change in list_beta.
function list_beta_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_beta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_delta.
function list_delta_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_delta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_radius.
function list_radius_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_radius_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_wavelength.
function list_wavelength_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_wavelength_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_dx.
function list_dx_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_dx_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_dz.
function list_dz_Callback(hObject, eventdata, handles)
    draw(handles);
end

% --- Executes during object creation, after setting all properties.
function list_dz_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in list_N.
function list_N_Callback(hObject, eventdata, handles)
    draw(handles);
end


% --- Executes during object creation, after setting all properties.
function list_N_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
