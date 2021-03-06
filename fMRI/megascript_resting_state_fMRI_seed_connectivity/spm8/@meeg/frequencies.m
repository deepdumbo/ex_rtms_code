function res = frequencies(this, ind, f)
% Method for getting/setting frequencies of TF data
% FORMAT res = frequencies(this, ind, values)
% _________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Stefan Kiebel
% $Id: frequencies.m 3579 2009-11-18 16:21:55Z vladimir $

if nargin < 3
    if strncmpi(transformtype(this), 'TF',2)
        res = this.transform.frequencies;
    else
        res = [];
        return
    end
    if exist('ind', 'var') == 1 && ~isempty(ind)
        res = res(ind);
    end    
else       
     if ~strncmpi(transformtype(this), 'TF',2)
         error('Frequencies can only be assigned to a TF dataset');
     end
    
    if any(f) <= 0 || any(~isnumeric(f))
        error('Frequencies must be positive numbers');
    end
    
    if isempty(ind) || isequal(ind, ':')
        ind = 1:size(this.data.y, 2);
    end
    
    if length(ind)~=length(f) || max(ind)>size(this.data.y, 2)
          error('Wrong frequency axis or indices'); 
    end

    this.transform.frequencies(ind) = f;
    
    res = this;    
end
