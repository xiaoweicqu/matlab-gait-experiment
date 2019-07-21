clear
clc
load('feature_all.mat');

before_reduce = 600;
after_reduce = 100;

views = [0,18,36,54,72,90,108,126,144,162,180];

allsize=0;

for vi=1:11
	feature_label_name = ['feature_all_',num2str(views(vi)),'_label'];
	feature_label_tmp = eval(feature_label_name);
	[m,n] = size(feature_label_tmp);
	allsize = allsize+m;
end

feature_all = zeros(allsize,before_reduce+1);

for vi=1:11
	feature_name = ['feature_all_',num2str(views(vi)];
	feature_label_name = ['feature_all_',num2str(views(vi)),'_label'];
	feature_tmp = eval(feature_name);
	feature_label_tmp = eval(feature_label_name);
	[m,n] = size(feature_lable_tmp);
	feature_all(vi,1) = feature_label_tmp(vi,1);
	feature_all(vi,2:before_reduce+1) = feature_tmp(vi,:);
end

fprintf('build the feature matrix \n');

mapped_feature = compute_mapping(feature_all, 'LDA', after_reduce);



read=0;
for vi=1:11
	feature_name = ['feature_all_',num2str(views(vi)];
	feature_label_name = ['feature_all_',num2str(views(vi)),'_label'];
	feature_tmp = eval(feature_name);
	feature_lable_tmp = eval(feature_label_name);
	[m,n] = size(feature_label_tmp);
	
	gallery_tmp = [];
	probe_tmp = [];
	gallery_label_tmp = [];
	probe_label_tmp = [];
	gallery_id = 1;
	probe_id = 1;
	for ti=1:m
		if feature_label_tmp(ti,2)<5
			gallery_tmp(gallery_id,:) = mapped_feature(read+ti,:);
			gallery_label_tmp(gallery_id,1) = feature_label_tmp(ti,1);
			gallery_id = gallery_id+1;
		else
			probe_tmp(probe_id,:) = mapped_feature(read+ti,:);
			probe_label_tmp(probe_id,:) = feature_label_tmp(ti,1);
			probe_id = probe_id+1;
		end
	end
	
	gallery_name = ['gallery_all_',num2str(views(vi))];
	gallery_label_name = ['gallery_all_',num2str(views(vi)),'_label'];
	probe_name = ['probe_all_',num2str(views(vi))];
	probe_label_name = ['probe_all_',num2str(views(vi)),'_label'];
	eval([gallery_name,'=gallery_tmp']);
	eval([gallery_label_name,'=gallery_label_tmp']);
	eval([probe_name,'=probe_tmp']);
	eval([probe_label_name,'=probe_label_tmp']);
	
	read=read+m;
end