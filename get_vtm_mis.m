load(vtm_features);
miss = [];
miss = min(1+fix(24*rand(1,3)));
[sk,sm,sna] = size(v_m_features);

data_table=[];
for ki=1:sk
    for mi=1:sm
        data_table(ki,mi) =1;
    end
end

for ki=1:sk
    miss(ki,:) =1+fix(24*rand(1,8));
    for ti=1:8
        data_table(ki,ti) =0;
    end
end

distances = [];

manifold_id = 1;
manifold_maps = [];
for ki=1:sk
    for mi=1:sm
        if data_table(ki,mi)~=0
            for fi= 1:sna
				manifold_maps[manifold_id,fi] = v_m_features(ki,mi,fi);
			end
			data_table(ki,mi) = manifold_id;
			manifold_id = manifold_id+1;
		end
	end
end


			