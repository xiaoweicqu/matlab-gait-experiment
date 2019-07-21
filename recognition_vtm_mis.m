%% use drtoolbox to reduce the dimensitions
%load('gallery_all.mat');
%%load('probe_all.mat');
%mapped_gallery_all_0 = compute_mapping(gallery_all_0,'PCA',100);
%mapped_probe_all_0 = compute_mapping(probe_all_0,'PCA',100);

clear
clc
load('gallery_all.mat');
load('probe_all.mat');
load('vtm_features2.mat');


[sk,sm,sna]=size(v_m_features);

v_t_p=[];
v_t_v=[];

for feature_i =1: sna
    [U,S,V]=svd(v_m_features(:,:,feature_i));
    p=U*S;
    for k_i = 1:sk
        for m_i = 1: sm
            v_t_p(feature_i,m_i,k_i)= p(k_i,m_i);
        end
    end
end

v_t_p_ij=[];

for i=1:sk
	for j=1:sk
		ij=(i-1)*sk+j;
		v_t_p_ij(:,:,ij)= v_t_p(:,:,i)*v_t_p(:,:,j)';
	end
end
	
fprintf('build the v_t_p_ij matrix \n');


%%v_t_m_tmp = reshape(v_m_features,sk*sm,sna);
%%v_t_m = reshape(v_t_m_tmp', sk*sna,sm);

%[U,S,V]=svd(v_t_m);
%%P=U*S;
%v_t_p = reshape(P',sm,sna,sk);
%v_t_v=V;

rates = zeros(11,11);
%%probe_all_names=('probe_all_0','probe_all_18','probe_all_36','probe_all_54','probe_all_72','probe_all_90','probe_all_108','probe_all_126','probe_all_144','probe_all_162','probe_all_180');
%%probe_all_label_names=('probe_all_0_label','probe_all_18_label','probe_all_36_label','probe_all_54_label','probe_all_72_label','probe_all_90_label','probe_all_108_label','probe_all_126_label','probe_all_144_label','probe_all_162_label','probe_all_180_label');

%%gallery_all_names=('gallery_all_0','gallery_all_18','gallery_all_36','gallery_all_54','gallery_all_72','gallery_all_90','gallery_all_108','gallery_all_126','gallery_all_144','gallery_all_162','gallery_all_180');
%%gallery_all_label_names=('gallery_all_0_label','gallery_all_18_label','gallery_all_36_label','gallery_all_54_label','gallery_all_72_label','gallery_all_90_label','gallery_all_108_label','gallery_all_126_label','gallery_all_144_label','gallery_all_162_label','gallery_all_180_label');

views = [0,18,36,54,72,90,108,126,144,162,180];

for pi = 1:11
	for gi = 1: 11
        probe_name = ['probe_all_',num2str(views(pi))];
        probe_label_name = ['probe_all_',num2str(views(pi)),'_label'];
        gallery_name = ['gallery_all_',num2str(views(gi))];
        gallery_name_label = ['gallery_all_',num2str(views(gi)),'_label'];
        
        fprintf('recognition with missing data (18~172): probe #%d,  gallery #%d\n',pi,gi);
        
		probe_all = eval(probe_name);
		probe_all_label = eval(probe_label_name);
		gallery_all = eval(gallery_name);
		gallery_all_label = eval(gallery_name_label);
        
        mapped_gallery_all = gallery_all;
        mapped_probe_all = probe_all;
	
		[pm,n] = size(probe_all_label);
		[gm,n] = size(gallery_all_label);
		distances = zeros(124,124);
	
	
		for probe_people_id = 25:124
			for  gallery_people_id = 25:124
				probe_distances=[];
				probe_distance_id=1;
				for probe_id = 1:pm
					if probe_all_label(probe_id) == probe_people_id
						gallery_distances=[];
						gallery_distances_id = 1;
						for gallery_id = 1:gm
							if gallery_all_label(gallery_id) == gallery_people_id
                                mapped_gallery_subject = mapped_gallery_all(gallery_id,:);
                                mapped_probe_subject = mapped_probe_all(probe_id,:);
                                if pi~=gi && pi>1 && gi>1 && pi<11 && gi<11
									ij=(gi-1)*sk+pi;
                                    mapped_probe_subject = v_t_p_ij(:,:,ij)*mapped_probe_all(probe_id,:)';
                                    mapped_probe_subject = mapped_probe_subject';
                                end
								gallery_distances(gallery_distances_id) = norm(mapped_gallery_subject - mapped_probe_subject);
								gallery_distances_id = gallery_distances_id+1;
							end
						end
						[ssm,ssn]=size(gallery_distances);
						if ssm>0
							probe_distances(probe_distance_id)=min(gallery_distances);
							probe_distance_id  = probe_distance_id+1;
						end
					end
				end
				distances(probe_people_id,gallery_people_id) = median(probe_distances);
			end
		end

		right = 0;
		wrong = 0;

		for test_people_id = 25: 124
			[dis,rec_id] = min(distances(test_people_id,:));
			if rec_id == test_people_id
				right = right+1;
			else
				wrong = wrong+1;
			end
		end
		rates(pi,gi) = right/(right+wrong);
		
	end
end

rates













