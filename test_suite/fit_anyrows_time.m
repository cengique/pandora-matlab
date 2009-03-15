
% measured time with:
tic; for i=1:100; anyRows(a_model_dball2(:, 'ItemIndex'), [(1:50)']); end;
toc
% for tables of 10 and 100 rows, with 1, 10, 25 and 50 columns

anyrows_nm_time = [100 1 71e-4; 100 10 72e-4; 100 25 75e-4; 100 50 78e-4; ...
                   10 1 70e-4; 10 10 71e-4; 10 25 71.8e-4; 10 50 75e-4]

anyrows_time = @(params, nm)(params * [ones(1, size(nm, 1)); nm(:, 1)'; ...
                    nm(:, 2)'; prod(nm, 2)'])

anyrows_error = ...
    @(params)(sum((anyrows_time(params, anyrows_nm_time(:, 1:2)) - ...
                   anyrows_nm_time(:, 3)').^2 * 1e6))

[params_final,FVAL,EXITFLAG,OUTPUT] = fminsearch(anyrows_error, [1 1 1 1])


% result: 
%params_final =
%    0.0070    1.16e-6	9.40e-6   0.052e-6


% ==================================================
% calculate logical combination of queries

rows = anyRows(a_model_dball(:, 'ItemIndex'), [(1:10)']) % 100 rows
rows2 = anyRows(a_model_dball2(:, 'ItemIndex'), [(1:10)']) % 10 rows

tic; for i=1:1000; rows & rows & rows & rows; end; toc
tic; for i=1:1000; rows2 & rows2 ; end; toc

logic_nm_time = [100 2 21e-4; 100 4 62e-4; 100 6 103e-4; 10 2 21e-4; 10 4 ...
                57e-4; 10 6 93e-4];

logic_error = ...
    @(params)(sum((anyrows_time(params, logic_nm_time(:, 1:2)) - ...
                   logic_nm_time(:, 3)').^2 * 1e6))

[params_final,FVAL,EXITFLAG,OUTPUT] = fminsearch(logic_error, [1 1 1 1])

%params_final =
%   -0.0014   -0.0000    0.0018    0.0000

