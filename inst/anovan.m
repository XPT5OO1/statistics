%  --Function File:  p = anovan (Y, GROUP, )
%  --Function File:  p = anovan (Y, GROUP, 'name', value, ...)
%  --Function File:  [p table] = anovan (...)
%  --Function File:  [p table stats] = anovan (...)
%  --Function File:  [p table stats terms] = anovan (...)
%
%  Perform a multi-way analysis of variance (ANOVA) for categorical factors.
%  When sample sizes are unequal, the sums-of-squared residuals are calculated 
%  sequentially (Type I).
% 
%  Data is a single vector Y with groups specified by a corresponding matrix of 
%  group labels GROUP, where GROUP has the same number of rows as @var{data}. 
%  For example, if Y = [1.1;1.2]; GROUP = [1,2,1; 1,5,2]; then observation 1.1 
%  was measured under conditions 1,2,1 and observation 1.2 was measured under 
%  conditions 1,5,2. Note that groups do not need to be sequentially numbered.
% 
%  By default, a 'linear' model is used, computing the N main effects
%  with no interactions. 
%
%  The settings of anovan can be configured with the following name-value pairs.
%  
%  p = anovan (data, groups, 'model', modeltype)
%  The model to use (modeltype) can specified as one of the following:
%  - modeltype = 'linear': compute N main effects
%  - modeltype = 'interaction': compute N effects and
%                                N*(N-1) two-factor interactions
%  - an integer representing the maximum interaction order
%  - an matrix of term definitions: each row is a term and each column is a factor
%    For example, a two-way ANOVA with interaction would be: [1 0; 0 1; 1 1]
% 
%  p = anovan (data, groups, 'varnames', varnames)
%  - varnames = {'X1','X2','X3',...}(default): cell array of character arrays
%  
%  p = anovan (data, groups, 'display', 'on')
%  - 'on' (default) | 'off': switch display of ANOVA table on/off
%
%  [p, table] = anovan (...) returns a cell array containing the ANOVA table
%
%  [p, table, stats] = anovan (...) returns a structure containing additional
%  statistics, including coefficients of the linear model, the model residuals, 
%  and the number of levels in each factor.
% 
%  [p, table, stats, terms] = anovan (...) returns the model term definitions
%
%  Author: Andrew Penn <a.c.penn@sussex.ac.uk>
%  Includes some code by: Christial Scholz, and Andy Adler <adler@ncf.ca>
% 
%  Copyright (C) 2022 Andrew Penn <A.C.Penn@sussex.ac.uk>
%  Copyright (C) 2003-2005 Andy Adler <adler@ncf.ca>
%
%  This program is free software; you can redistribute it and/or modify it under
%  the terms of the GNU General Public License as published by the Free Software
%  Foundation; either version 3 of the License, or (at your option) any later
%  version.
% 
%  This program is distributed in the hope that it will be useful, but WITHOUT
%  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%  details.
% 
%  You should have received a copy of the GNU General Public License along with
%  this program; if not, see <http://www.gnu.org/licenses/>.


function [p, ANOVA_table, STATS, TERMS] = aovn (data, grps, varargin)
      
    if nargin <= 1
      error ('anovan usage: ''anovan (data, grps)''; atleast 2 input arguments required');
    end

    % Check supplied parameters
    modeltype = 'linear';
    display = 'on';
    varnames = [];
    for idx = 3:2:nargin
      param= varargin{idx-2};
      value= varargin{idx-1};
      if strcmpi (param, 'model')
        modeltype = value;
      elseif strcmpi (param, 'varnames')
        varnames = value;
      elseif strcmpi (param, 'display')
        display = value;   
      else 
        error (sprintf('anovan: parameter %s is not supported', param));
      end
    end
     % Remove NaN or non-finite observations
    excl = logical (isnan(data) + isinf(data));
    data(excl) = [];
    grps(excl,:) = [];
    N = numel (data);
    if prod (size (data)) ~= N
      error ('anovan: for ''anovan (data, grps)'', data must be a vector');
    end
    if (size (data, 2) > 1)
      data = data(:);
    end
    n = size (grps,2); # number of anova "ways"
    if (size (grps,1) ~= N)
      error ('anovan: grps must be a matrix of the same number of rows as data');
    end
    if ~isempty (varnames) 
      if iscell (varnames)
        if all (cellfun (@ischar, varnames))
          ng = numel(varnames);
        else
          error ('anovan: all variable names must be character or character arrays');
        end
      elseif ischar (varnames)
        ng = 1;
        varnames = {varnames};
      elseif isstring (varnames)
        ng = 1;
        varnames = {char(varnames)};
      else
        error ('anovan: varnames is not of a valid type. Must be cell array of character arrays, character array or string');
      end
    else
      ng = n;
      varnames = arrayfun(@(x) ['X',num2str(x)], 1:n, 'UniformOutput', 0);
    end
    if (ng ~= n)
      error ('anovan: number of variable names is not equal to number of grouping variables');
    end
  
    % Evaluate model type input argument and create terms matrix if not provided
    if (isnumeric (modeltype) && numel (modeltype == 1))
      switch modeltype
        case 1
          modeltype = 'linear';
        case 2
          modeltype = 'interaction';
        otherwise
          error ('anovan: interactions involving more than two factors are not supported')
      end
    end
    if ~isnumeric (modeltype)
      if strcmpi (modeltype, 'full') && (n < 3)
        modeltype = 'interaction';
      end
      switch lower(modeltype)
        case 'linear'
          nx = 0;
          TERMS = zeros (n + nx, n);
          TERMS(1:n,:) = diag (ones (n, 1));
        case 'interaction'
          nx = nchoosek (n, 2);
          TERMS = zeros (n + nx, n);
          TERMS(1:n,:) = diag (ones (n, 1));
          for j = 1:n
            for i = j:n-1
              TERMS(n+j+i-1,j) = 1;
              TERMS(n+j+i-1,i+1) = 1;
            end
          end
        case 'full'
          error ('anovan: interactions involving more than two factors are not supported')
      end
    else
      % Assume that the user provided a terms matrix
    end
    TERMS = logical(TERMS);
    % Evaluate terms matrix
    ng = sum (TERMS, 2); 
    if any(diff(ng) < 0)
      error ('anovan: the model terms matrix must list main effects above interactions')
    end
    main = (ng == 1);
    inte = (ng == 2);
    if any (ng > 2)
      error ('anovan: interactions involving more than two factors are not supported')
    end
    nm = sum (main);
    nx = sum (inte);
    nt = nm + nx;

    % Calculate total sum-of-squares
    ct  = sum (data)^2 / N;   % correction term
    sst = sum (data.^2) - ct;
    dft = N - 1;

    % Fit linear models, and calculate sums-of-squares for ANOVA
    % Type I sequential sums-of-squares
    R = sst;
    ss = zeros (nt,1);
    df = zeros (nt,1);
    [X, grpnames, nlevels, df, termcols] = dummy_coder (grps, TERMS, main, inte, N, nm, nx);
    for j = 1:nt
      XS = cell2mat (X(1:j+1));
      [b, sse, resid] = lmfit (XS, data);
      ss(j) = R - sse;
      R = sse;
    end
    dfe = dft - sum (df);
    ms = ss ./ df;
    mse = sse / dfe;
    F = ms / mse;
    p = 1 - fcdf (F, df, dfe);
    
    % Prepare stats output structure
    % Note that the information provided by STATS is not sufficient for MATLAB's multcompare function
    STATS = struct ('source','anovan', ...
                    'resid', resid, ...
                    'coeffs', b, ...
                    'Rtr', [], ...           % Not used in Octave
                    'rowbasis', [], ...      % Not used in Octave
                    'dfe', dfe, ...
                    'mse', mse, ...
                    'nullproject', [], ...   % Not used in Octave
                    'terms', TERMS, ...
                    'nlevels', nlevels, ...  
                    'continuous', [], ...
                    'vmeans', [], ...        % Not used since 'continuous' argument name not supported
                    'termcols', termcols, ...
                    'coeffnames', [], ...    % Not used in Octave
                    'vars', [], ...          % Not used in Octave
                    'varnames', {varnames}, ...
                    'grpnames', {grpnames}, ...
                    'vnested', [], ...       % Not used since 'nested' argument name not supported
                    'ems', [], ...           % Not used since 'nested' argument name not supported
                    'denom', [], ...         % Not used since 'random' argument name not supported
                    'dfdenom', [], ...       % Not used since 'random' argument name not supported
                    'msdenom', [], ...       % Not used since 'random' argument name not supported
                    'varest', [], ...        % Not used since 'random' argument name not supported
                    'varci', [], ...         % Not used since 'random' argument name not supported
                    'txtdenom', [], ...      % Not used since 'random' argument name not supported
                    'txtems', [], ...        % Not used since 'random' argument name not supported
                    'rtnames', []);          % Not used since 'random' argument name not supported
    
    % Prepare cell array containing the ANOVA table
    ANOVA_table = cell (nt+3, 6);
    ANOVA_table(1,:) = {'Source','Sum Sq.','d.f.','Mean Sq.','F','Prob>F'};
    ANOVA_table(2:nt+1,2:6) = num2cell([ss df ms F p]);
    ANOVA_table(end-1,1:4) = {'Error',sse,dfe,mse};
    ANOVA_table(end,1:3) = {'Total',sst,dft};
    for i=1:nt
      str = sprintf('%s*',varnames{find(TERMS(i,:))});
      ANOVA_table(i+1,1) = str(1:end-1);
    end
    
    % Print ANOVA table 
    if strcmpi(display,'on')
      % Get dimensions of ANOVA_table
      [nrows,ncols] = size (ANOVA_table);
      % Scale p-values by 1000 so that we can format them in the printed table in APA style 
      ps = round (p * 1e+03);
      ps(ps>999) = 999;
      ANOVA_table(2:nrows-2,ncols) = num2cell(ps);
      % Print table
      printf('\n%d-way ANOVA Table:\n\n', nm);
      printf('Source                    Sum Sq.   d.f.   Mean Sq.           F  Prob>F\n');
      printf('***********************************************************************\n');  
      for i = 1:nt
        printf('%-22s  %9.5g %6d  %9.5g %11.2f    .%03u \n', ANOVA_table{i+1,:});
      end
      printf('Error                   %9.5g %6d %10.2f\n', ANOVA_table{end-1,2:4});               
      printf('Total                   %9.5g %6d \n', ANOVA_table{end,2:3});  
      printf('\n');
    elseif strcmp(display,'off')
      % do nothing
    else
      error ('anovan: unknown display option');    
    end
  
end


function [X, levels, nlevels, df, termcols] = dummy_coder (grps, TERMS, main, inte, N, nm, nx)
  
  % Returns a cell array of dummy-coded levels for each term in the linear model
  
  % Fetch factor levels from each column (i.e. factor) in grps
  levels = cell (nm, 1);
  gid = zeros (N, nm);
  nlevels = zeros (nm, 1);
  df = zeros (nm + nx, 1);
  termcols = ones (1 + nm + nx, 1);
  for j = 1:nm
    m = find (TERMS(j,:));
    [levels{j}, jnk, gid(:,j)] = unique (grps (:,m), 'legacy');
    nlevels(j) = numel (levels{j});
    termcols(j+1) = nlevels(j);
    df(j) = nlevels(j) - 1;
  end
 
  % Create contrast matrix C and dummy variables X
  % Prepare dummy variables for main effects
  X = cell (1, 1 + nm + nx);
  X(1) = ones (N, 1);
  for j = 1:nm
    C = contr_sum (nlevels(j));
    func = @(x) x(gid(:,j));
    X(1+j) = cell2mat (cellfun (func, num2cell (C, 1), 'UniformOutput', false));
  end
  % If applicable, prepare dummy variables for all two-factor interactions
  if (nx > 0)
    pairs = TERMS(inte,:);
    for i = 1:nx
      I = 1 + find (pairs(i,:));
      X(1+nm+i) = bsxfun (@times, X{I});
      df(nm+i) = prod (df(I-1));
      termcols(1+nm+i) = prod (df(I-1) + 1);
    end
  end

end


function C = contr_sum (n)

  % Create contrast matrix using deviation coding 
  % These contrasts sum to 0
  C = cat (1, diag (ones (n-1, 1)), - (ones (1,n-1)));
  
end


function [b, sse, resid] = lmfit (X,Y)
  
  % Solve linear equation by QR decomposition 
  % (this achieves the same thing as b = X \ Y)
  [Q, R] = qr (X,0); 
  b = R \ Q' * Y ; 
  fit = X * b;
  resid = Y - fit;
  sse = sum ((resid).^2);
  
end


#{
# Test Data from http://maths.sci.shu.ac.uk/distance/stats/14.shtml
data=[7  9  9  8 12 10 ...
      9  8 10 11 13 13 ...
      9 10 10 12 10 12]';
grp = [1,1; 1,1; 1,2; 1,2; 1,3; 1,3;
       2,1; 2,1; 2,2; 2,2; 2,3; 2,3;
       3,1; 3,1; 3,2; 3,2; 3,3; 3,3];
data=[7  9  9  8 12 10  9  8 ...
      9  8 10 11 13 13 10 11 ...
      9 10 10 12 10 12 10 12]';
grp = [1,4; 1,4; 1,5; 1,5; 1,6; 1,6; 1,7; 1,7;
       2,4; 2,4; 2,5; 2,5; 2,6; 2,6; 2,7; 2,7;
       3,4; 3,4; 3,5; 3,5; 3,6; 3,6; 3,7; 3,7];
# Test Data from http://maths.sci.shu.ac.uk/distance/stats/9.shtml
data=[9.5 11.1 11.9 12.8 ...
     10.9 10.0 11.0 11.9 ...
     11.2 10.4 10.8 13.4]';
grp= [1:4,1:4,1:4]';
# Test Data from http://maths.sci.shu.ac.uk/distance/stats/13.shtml
data=[7.56  9.68 11.65  ...
      9.98  9.69 10.69  ...
      7.23 10.49 11.77  ...
      8.22  8.55 10.72  ...
      7.59  8.30 12.36]'; 
grp = [1,1;1,2;1,3;
       2,1;2,2;2,3;
       3,1;3,2;3,3;
       4,1;4,2;4,3;
       5,1;5,2;5,3];
# Test Data from www.mathworks.com/
#                access/helpdesk/help/toolbox/stats/linear10.shtml
data=[23  27  43  41  15  17   3   9  20  63  55  90];
grp= [ 1    1   1   1   2   2   2   2   3   3   3   3;
       1    1   2   2   1   1   2   2   1   1   2   2]';
# Test Data from Table 24.4 in Kutner et al., Applied Linear Statistical Models. 5th ed.
# Three-way ANOVA example (2x2x2) with 3 replicates
data = [24.1 29.2 24.6 20 21.9 17.6 14.6 15.3 12.3 16.1 9.3 10.8 ...
       17.6 18.8 23.2 14.8 10.3 11.3 14.9 20.4 12.8 10.1 14.4 6.1]';
grp = [1,1,1;2,1,1;1,1,1;2,1,1;1,1,1;2,1,1;1,1,2;2,1,2;
       1,1,2;2,1,2;1,1,2;2,1,2;1,2,1;2,2,1;1,2,1;2,2,1;
       1,2,1;2,2,1;1,2,2;2,2,2;1,2,2;2,2,2;1,2,2;2,2,2];
# Test Data for unbalanced two-way ANOVA example (2x2)   
salary = [24 26 25 24 27 24 27 23 15 17 20, ...
          16 25 29 27 19 18 21 20 21 22 19]';
gender = [1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2]';
degree = [1 1 1 1 1 1 1 1 0 0 0 0 1 1 1 0 0 0 0 0 0 0]',
#}