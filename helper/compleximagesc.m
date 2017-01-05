% Plot complex-valued images in color. Modified by FZimmermann for using
% hsl
% 
% COMPLEXIMAGESC supports all the syntax supported by imagesc:
%
% Copyright (c) 2014, Peter Caday
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

function ih = compleximagesc(varargin)
    rlim = [];
    switch nargin,
        case 0,
            C_index = [];
        case 1,
            C_index = 1;
        otherwise,
            % Determine if last input is a radius limit
            % Taken from imagesc ver. 5.11.4.5, R2012b.
            if isequal(size(varargin{end}),[1 2])
                str = false(length(varargin),1);
                for n=1:length(varargin)
                    str(n) = ischar(varargin{n});
                end
                str = find(str);
                if isempty(str) || (rem(length(varargin)-min(str),2)==0),
                    rlim = varargin{end};
                    varargin(end) = []; % Remove last cell
                else
                    rlim = [];
                end
            else
                rlim = [];
            end
            
            % Determine whether we have x,y arguments
            if length(varargin) > 2 && ...
                    ~ischar(varargin{1}) && ...
                    ~ischar(varargin{2}),
                % Yes, C is argument 3
                C_index = 3;
            elseif ~ischar(varargin{1}) 
                % No x,y arguments and C is argument 1
                C_index = 1;
            else
                % No x,y or C arguments.
                C_index = [];
            end
    end

    if ~isempty(C_index),
        % Convert complex C to RGB image.
        C = varargin{C_index};
        
        if ~ismatrix(C), error('The image must be a matrix'); end

        % Convert complex image C to argument and magnitude.
        arg = angle(C);
        
        r = abs(C);

        if isempty(rlim),
            % Find magnitude limits if not specified.
            rmin = min(r(isfinite(r)));
            rmax = max(r(isfinite(r)));
        else
            rmin = rlim(1); rmax = rlim(2);
        end
        
        % Argument becomes hue
        h = mod(arg/(2*pi), 1);
        h=mod(h-median(h(:))+pi/2,1);
        % Saturation is always 1
        s = ones(size(h));
        % Magnitude becomes l
        l = (r - rmin) / (rmax - rmin);
        % Clamp value between 0 and 1 outside the magnitude range.
        l(r >= rmax) = 1.;
        l(r <= rmin) = 0.;
        
        hsl = cat(3, h, s, l);

        varargin{C_index} = hsl2rgb(hsl);
    end
    
    hh = image(varargin{:});
    
    if nargout > 0,
        ih = hh;
    end
end