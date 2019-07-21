clear
clc
load('gallery_all.mat');
load('probe_all.mat');
load('vtp_ij.mat');
load('vtp_ij22.mat');

%%[sk,sm,sna]=size(v_m_features);
sk=11;
%sm=24;
sna=600;
vtm_rates = zeros(11,11);
vtm_rates_top5 = zeros(11,11);

vtm_rates_mis = zeros(11,11);
vtm_rates_mis_top5 = zeros(11,11);

views = [0,18,36,54,72,90,108,126,144,162,180];

save_distances=[];
save_distances_mis=[];

for pi = 1:11
	for gi = 1:11
		%%if pi==5 && gi==7
			probe_name = ['probe_all_',num2str(views(pi))];
			probe_label_name = ['probe_all_',num2str(views(pi)),'_label'];
			gallery_name = ['gallery_all_',num2str(views(gi))];
			gallery_name_label = ['gallery_all_',num2str(views(gi)),'_label'];
			
			probe_all = eval(probe_name);
			probe_all_label = eval(probe_label_name);
			gallery_all = eval(gallery_name);
			gallery_all_label = eval(gallery_name_label);
        
			mapped_gallery_all = gallery_all;
			mapped_probe_all = probe_all;
	
			[pm,n] = size(probe_all_label);
			[gm,n] = size(gallery_all_label);
			distances = zeros(100,100);
			distances_mis = = zeros(100,100);
	
			for probe_people_id = 25:124
				for  gallery_people_id = 25:124
					probe_distances=[];
					probe_distances_mis=[];
					probe_distance_id=1;
					for probe_id = 1:pm
						if probe_all_label(probe_id) == probe_people_id
							gallery_distances=[];
							gallery_distances_mis=[];
							gallery_distances_id = 1;
							mapped_probe_subject = mapped_probe_all(probe_id,:);
							mapped_probe_subject_mis = mapped_probe_all(probe_id,:);
							if pi~=gi
								ij=(gi-1)*sk+pi;
								mapped_probe_subject = v_t_p_ij(:,:,ij)*mapped_probe_subject;
								mapped_probe_subject = mapped_probe_subject';
								mapped_probe_subject_mis = v_t_p_ij2(:,:,ij)*mapped_probe_subject_mis';
								mapped_probe_subject_mis = mapped_probe_subject_mis';
                            end
							for gallery_id = 1:gm
								if gallery_all_label(gallery_id) == gallery_people_id
									mapped_gallery_subject = mapped_gallery_all(gallery_id,:);
									gallery_distances(gallery_distances_id) = norm(mapped_gallery_subject - mapped_probe_subject);
									gallery_distances_mis(gallery_distances_id) =norm(mapped_gallery_subject - mapped_probe_subject_mis);
									gallery_distances_id = gallery_distances_id+1;
								end
							end
							[ssm,ssn]=size(gallery_distances);
							if ssm>0
								probe_distances(probe_distance_id)=min(gallery_distances);
								probe_distances_mis(probe_distance_id)=min(gallery_distances_mis);
								probe_distance_id  = probe_distance_id+1;
							end
						end
                    end
                    if max(size(probe_distances))<1
                        distances(probe_people_id-24,gallery_people_id-24) = realmax;
                    else
                        distances(probe_people_id-24,gallery_people_id-24) = min(probe_distances);
                    end
					if max(size(probe_distances_mis))<1
						 distances_mis(probe_people_id-24,gallery_people_id-24) = realmax;
					else
						distances_mis(probe_people_id-24,gallery_people_id-24) = min(probe_distances_mis);
					end
					pigi=(pi-1)*sk+gi;
					save_distances(:,:,pigi)=distances;
					save_distances_mis(:,:,pigi)=distances_mis;
				end
			end

			right = 0;
			right_top5 = 0;
			right_mis = 0;
			right_top5_mis = 0;
			
			for test_people_id = 1: 100
				distances_with_id=[];
				distances_with_id_mis=[];
				for ii=1:100
					distances_with_id(ii,1)=distances(test_people_id,ii);
					distances_with_id(ii,2)=ii;
					distances_with_id_mis(ii,1)=distances_mis(test_people_id,ii);
					distances_with_id_mis(ii,2)=ii;
				end
				if(distances_with_id(1,2)==test_people_id)
					right = right+1;
				end
				if(distances_with_id_mis(1,2)==test_people_id)
					right_mis = right_mis+1;
				end
				for iii=1:5
					if(distances_with_id(iii,2)==test_people_id)
						right_top5 = right_top5+1;
					end
					if(distances_with_id_mis(iii,2)==test_people_id)
						right_top5_mis = right_top5_mis=1;
					end
				end
			end

			vtm_rates(pi,gi) = right/100;
			vtm_rates_top5(pi,gi) = right_top5/100;
			vtm_rates_mis(pi,gi) = right_mis/100;
			vtm_rates_top5_mis(pi,gi) = right_top5_mis/100;
			
            fprintf('vtm module probe #%d,  gallery #%d:\n',(pi-1)*18,(gi-1)*18);
			fprintf('vtm rate: %0.3f, top5 rate: %0.3f, misdata rate: %0.3f, misdata top5 rate: %0.3f\n',vtm_rates(pi,gi),vtm_rates_top5(pi,gi),vtm_rates_mis(pi,gi),vtm_rates_top5_mis(pi,gi) );
       %% else
        %%    rates(pi,gi) = 0;
		%%end
		
	end
end

save dis.mat save_distances;
save dis.mat save_distances_mis;
