clear
clc
load('gallery.mat');
load('probe.mat');
load('vtp_ij.mat');
load('vtp_ij_mis_10.mat');
load('vtp_ij_mis_30.mat');
load('vtp_ij_mis_50.mat');

sk=11;
sna=600;
vtm_rates = zeros(11,11);
vtm_rates_mis_10 = zeros(11,11);


views = [0,18,36,54,72,90,108,126,144,162,180];

save_distances=zeros(100,100,11*11);
save_distances_mis_10=zeros(100,100,11*11);
save_distances_mis_30=zeros(100,100,11*11);
save_distances_mis_50=zeros(100,100,11*11);




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
			distances_mis_10 = zeros(100,100);
			distances_mis_30 = zeros(100,100);
			distances_mis_50 = zeros(100,100);
	
			for probe_people_id = 25:124
				for  gallery_people_id = 25:124
					probe_distances=[];
					probe_distances_mis_10=[];
					probe_distances_mis_30=[];
					probe_distances_mis_50=[];
					probe_distance_id=1;
					for probe_id = 1:pm
						if probe_all_label(probe_id) == probe_people_id
							gallery_distances=[];
							gallery_distances_mis_10=[];
							gallery_distances_mis_30=[];
							gallery_distances_mis_50=[];
							gallery_distances_id = 1;
							mapped_probe_subject = mapped_probe_all(probe_id,:);
							mapped_probe_subject_mis_10 = mapped_probe_all(probe_id,:);
							mapped_probe_subject_mis_30 = mapped_probe_all(probe_id,:);
							mapped_probe_subject_mis_50 = mapped_probe_all(probe_id,:);
							if pi~=gi
								ij=(gi-1)*sk+pi;
								mapped_probe_subject = v_t_p_ij(:,:,ij)*mapped_probe_subject';
								mapped_probe_subject = mapped_probe_subject';
								mapped_probe_subject_mis_10 = v_t_p_ij_mis_10(:,:,ij)*mapped_probe_subject_mis_10';
								mapped_probe_subject_mis_10 = mapped_probe_subject_mis_10';
								mapped_probe_subject_mis_30 = v_t_p_ij_mis_30(:,:,ij)*mapped_probe_subject_mis_30';
								mapped_probe_subject_mis_30 = mapped_probe_subject_mis_30';
								mapped_probe_subject_mis_50 = v_t_p_ij_mis_50(:,:,ij)*mapped_probe_subject_mis_50';
								mapped_probe_subject_mis_50 = mapped_probe_subject_mis_50';
                            end
							for gallery_id = 1:gm
								if gallery_all_label(gallery_id) == gallery_people_id
									mapped_gallery_subject = mapped_gallery_all(gallery_id,:);
									gallery_distances(gallery_distances_id) = norm(mapped_gallery_subject - mapped_probe_subject);
									if pi~=gi
										gallery_distances_mis_10(gallery_distances_id) = norm(mapped_gallery_subject - mapped_probe_subject_mis_10);
										gallery_distances_mis_30(gallery_distances_id) = norm(mapped_gallery_subject - mapped_probe_subject_mis_30);
										gallery_distances_mis_50(gallery_distances_id) = norm(mapped_gallery_subject - mapped_probe_subject_mis_50);
									else
										gallery_distances_mis_10(gallery_distances_id) = gallery_distances(gallery_distances_id);
										gallery_distances_mis_30(gallery_distances_id) = gallery_distances(gallery_distances_id);
										gallery_distances_mis_50(gallery_distances_id) = gallery_distances(gallery_distances_id);
									end
									gallery_distances_id = gallery_distances_id+1;
								end
							end
							[ssm,ssn]=size(gallery_distances);
							if ssm>0
								probe_distances(probe_distance_id)=min(gallery_distances);
								probe_distances_mis_10(probe_distance_id)=min(gallery_distances_mis_10);
								probe_distances_mis_30(probe_distance_id)=min(gallery_distances_mis_30);
								probe_distances_mis_50(probe_distance_id)=min(gallery_distances_mis_50);
								probe_distance_id  = probe_distance_id+1;
							end
						end
                    end
                    if max(size(probe_distances))<1
                        distances(probe_people_id-24,gallery_people_id-24) = realmax;
                    else
                        distances(probe_people_id-24,gallery_people_id-24) = min(probe_distances);
                    end
					if max(size(probe_distances_mis_10))<1
						 distances_mis_10(probe_people_id-24,gallery_people_id-24) = realmax;
					else
						distances_mis_10(probe_people_id-24,gallery_people_id-24) = min(probe_distances_mis_10);
					end
					if max(size(probe_distances_mis_30))<1
						 distances_mis_30(probe_people_id-24,gallery_people_id-24) = realmax;
					else
						distances_mis_30(probe_people_id-24,gallery_people_id-24) = min(probe_distances_mis_30);
					end
					if max(size(probe_distances_mis_50))<1
						 distances_mis_50(probe_people_id-24,gallery_people_id-24) = realmax;
					else
						distances_mis_50(probe_people_id-24,gallery_people_id-24) = min(probe_distances_mis_50);
					end
					pigi=(pi-1)*sk+gi;
					save_distances(:,:,pigi)=distances;
					save_distances_mis_10(:,:,pigi)=distances_mis_10;
					save_distances_mis_30(:,:,pigi)=distances_mis_30;
					save_distances_mis_50(:,:,pigi)=distances_mis_50;
				end
			end

			right = 0;
			right_mis_10 = 0;
			right_mis_30 = 0;
			right_mis_50 = 0;
			for test_people_id = 1: 100
				distances_with_id=zeros(100,2);
				distances_with_id_mis_10=zeros(100,2);
				distances_with_id_mis_30=zeros(100,2);
				distances_with_id_mis_50=zeros(100,2);
				for ii=1:100
					distances_with_id(ii,1)=distances(test_people_id,ii);
					distances_with_id(ii,2)=ii;
					distances_with_id_mis_10(ii,1)=distances_mis_10(test_people_id,ii);
					distances_with_id_mis_10(ii,2)=ii;
					distances_with_id_mis_30(ii,1)=distances_mis_30(test_people_id,ii);
					distances_with_id_mis_30(ii,2)=ii;
					distances_with_id_mis_50(ii,1)=distances_mis_50(test_people_id,ii);
					distances_with_id_mis_50(ii,2)=ii;
                end
                distances_with_id=sortrows(distances_with_id);
                distances_with_id_mis_10=sortrows(distances_with_id_mis_10);
                distances_with_id_mis_30=sortrows(distances_with_id_mis_30);
				distances_with_id_mis_50=sortrows(distances_with_id_mis_50);
                
				if(distances_with_id(1,2)==test_people_id)
					right = right+1;
				end
				if(distances_with_id_mis_10(1,2)==test_people_id)
					right_mis_10 = right_mis_10+1;
				end
				if(distances_with_id_mis_30(1,2)==test_people_id)
					right_mis_30 = right_mis_30+1;
				end
				if(distances_with_id_mis_50(1,2)==test_people_id)
					right_mis_50 = right_mis_50+1;
				end
			end

			vtm_rates(pi,gi) = right/100;
			vtm_rates_mis_10(pi,gi) = right_mis_10/100;
			vtm_rates_mis_30(pi,gi) = right_mis_30/100;
			vtm_rates_mis_50(pi,gi) = right_mis_50/100;
            fprintf('vtm module probe #%d,  gallery #%d:\n',(pi-1)*18,(gi-1)*18);
			fprintf('vtm rate: %0.2f, missing 10% data: %0.2f, missing 30% data: %0.2f, missing 50% data: %0.2f\n',vtm_rates(pi,gi),vtm_rates_mis_10(pi,gi),vtm_rates_mis_30(pi,gi),vtm_rates_mis_50(pi,gi) );
	end
end

save dis.mat save_distances;
save dis.mat save_distances_mis_10;
save dis.mat save_distances_mis_30;
save dis.mat save_distances_mis_50;
save dis.mat vtm_rates;
save dis.mat vtm_rates_mis_10;
save dis.mat vtm_rates_mis_30;
save dis.mat vtm_rates_mis_50;