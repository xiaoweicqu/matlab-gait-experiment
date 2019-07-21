clear
clc
load('dis.mat');

vtm_rates_top10 = zeros(11,11);
vtm_rates_top10_mis = zeros(11,11);
distances = zeros(100,100);
distances_mis = zeros(100,100);


for pi = 1:11
	for gi = 1:11
			right_top10 = 0;
			right_top10_mis = 0;
			ij=(pi-1)*11+gi;
			distances = save_distances(:,:,ij);
			distances_mis = save_distancse_mis(:,:,ij);
			right_top10 = 0;
			right_top10_mis = 0;

			
			for test_people_id = 1: 100
				distances_with_id=zeros(100,2);
				distances_with_id_mis=zeros(100,2);
				for ii=1:100
					distances_with_id(ii,1)=distances(test_people_id,ii);
					distances_with_id(ii,2)=ii;
					distances_with_id_mis(ii,1)=distances_mis(test_people_id,ii);
					distances_with_id_mis(ii,2)=ii;
                end
                distances_with_id=sortrows(distances_with_id);
                distances_with_id_mis=sortrows(distances_with_id_mis);
                
                
				for iii=1:10
					if(distances_with_id(iii,2)==test_people_id)
						right_top10 = right_top10+1;
					end
					if(distances_with_id_mis(iii,2)==test_people_id)
						right_top10_mis = right_top10_mis+1;
					end
				end
			end
			
			vtm_rates_top10(pi,gi) = right_top10/100;
			vtm_rates_top10_mis(pi,gi) = right_top10_mis/100;
			
	end
end
