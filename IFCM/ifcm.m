function [center, U, obj_fcn] = ifcm(data,cluster_n)


if nargin ~= 2 & nargin ~= 3,
	error('Too many or too few input arguments!');
end

data_n = size(data, 1);
in_n = size(data, 2);

% Change the following to set default options
default_options = [2;	% exponent for the partition matrix U
		100;	% max. number of iteration
		1e-5;	% min. amount of improvement
		1];	% info display during iteration 

if nargin == 2,
	options = default_options;
else
	% If "options" is not fully specified, pad it with default values.
	if length(options) < 4,
		tmp = default_options;
		tmp(1:length(options)) = options;
		options = tmp;
	end
	% If some entries of "options" are nan's, replace them with defaults.
	nan_index = find(isnan(options)==1);
	options(nan_index) = default_options(nan_index);
	if options(1) <= 1,
		error('The exponent should be greater than 1!');
	end
end

expo = options(1);		% Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);		% Display info or not
obj_fcn = zeros(max_iter, 1);	% Array for objective function

%U = initfcm(cluster_n, data_n);			% Initial fuzzy partition
center= initifcmv(cluster_n);            %初始化聚类中心
[Miuij,Vij,Paiij]=initifcmmvp(data);

for i = 1:max_iter,
    [U, center, obj_fcn(i)] = ifcm_step(data, center, cluster_n, expo, Miuij,Vij,Paiij);
	if display, 
		fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
	end
	% check termination condition
	if i>1
% 		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
 %        if norm(old_U-U,2) < min_impro, break; end,
%        if norm(old_U-U,'fro') < min_impro, break; end,
       if norm(old_center-center,2) < min_impro, break; end,
       % (old_center-center).^2
         
    end
    old_U = U;
    old_center = center;
end

% iter_n = i;	% Actual number of iterations 
% % obj_fcn(iter_n+1:max_iter) = [];
% mf = old_U.^expo;       % 隶属度矩阵进行指数运算结果
% dist = distfcm(old_center, data);       % 计算距离矩阵
% obj_fcn = sum(sum((dist.^2).*mf));  % 计算目标函数值 
