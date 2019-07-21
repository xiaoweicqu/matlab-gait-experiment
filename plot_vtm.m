clear
clc
load('VTM.mat');
load('vtp_ij_mis_10.mat');
load('vtp_ij_mis_30.mat');
load('vtp_ij_mis_50.mat');

views = [0,18,36,54,72,90,108,126,144,162,180];

sk=11;
sna=600;
imgheight=30;
imgwidth=20;

vtmplot=zeros(sk*sk,sna);
vtmplot_mis_10=zeros(sk*sk,sna);
vtmplot_mis_30=zeros(sk*sk,sna);
vtmplot_mis_50=zeros(sk*sk,sna);

probe=zeros(sna);
gallery=zeros(sna);
gallery_mis_10=zeros(sna);
gallery_mis_30=zeros(sna);
gallery_mis_50=zeros(sna);

ij=0;
for pi=1:sk
	vtm_name = ['VTM_',num2str(views(pi))];
	vtm_tmp = eval(vtm_name);
	probe=vtm_tmp(1,:);
	for gi=1:sk
		ij=(gi-1)*sk+pi;
		gallery = probe;
		gallery_mis_10 = probe;
		gallery_mis_30 = probe;
		gallery_mis_50 = probe;
		if pi~=gi
			gallery = v_t_p_ij(:,:,ij)*gallery';
			gallery = gallery';
			gallery_mis_10 = v_t_p_ij_mis_10(:,:,ij)*gallery_mis_10';
			gallery_mis_10=gallery_mis_10';
			gallery_mis_30 = v_t_p_ij_mis_30(:,:,ij)*gallery_mis_30';
			gallery_mis_30=gallery_mis_30';
			gallery_mis_50 = v_t_p_ij_mis_50(:,:,ij)*gallery_mis_50';
			gallery_mis_50=gallery_mis_50';
		end
		vtmplot(ij,:) = gallery;
		vtmplot_mis_10(ij,:) = gallery_mis_10;
		vtmplot_mis_30(ij,:) = gallery_mis_30;
		vtmplot_mis_50(ij,:) = gallery_mis_50;
	end
end

fprintf('build the vtm ploting matrix\n');

figure(1)
toploti=1;
for pi=1:sk
	for gi=0:sk
		toplot=zeros(imgheight,imgwidth);
		if gi==0
			ij=(pi-1)*sk+pi;
		else
			ij=(pi-1)*sk+gi;
		end
		for r=1:imgheight
			for c=1:imgwidth
				toplot(r,c) = vtmplot(ij,(r-1)*20+c);
			end
		end
		toplot = uint8(toplot);
		subplot(sk,sk+1,toploti);
		imshow(toplot);
		hold on;
	end
end
fprintf('plot the vtm figures\n');


figure(2)
toploti=1;
for pi=1:sk
	for gi=0:sk
		toplot=zeros(imgheight,imgwidth);
		if gi==0
			ij=(pi-1)*sk+pi;
		else
			ij=(pi-1)*sk+gi;
		end
		for r=1:imgheight
			for c=1:imgwidth
				toplot(r,c) = vtmplot_mis_10(ij,(r-1)*20+c);
			end
		end
		toplot = uint8(toplot);
		subplot(sk,sk+1,toploti);
		imshow(toplot);
		hold on;
	end
end
fprintf('plot the vtm figures: missing 10% data\n');

figure(3)
toploti=1;
for pi=1:sk
	for gi=0:sk
		toplot=zeros(imgheight,imgwidth);
		if gi==0
			ij=(pi-1)*sk+pi;
		else
			ij=(pi-1)*sk+gi;
		end
		for r=1:imgheight
			for c=1:imgwidth
				toplot(r,c) = vtmplot_mis_30(ij,(r-1)*20+c);
			end
		end
		toplot = uint8(toplot);
		subplot(sk,sk+1,toploti);
		imshow(toplot);
		hold on;
	end
end
fprintf('plot the vtm figures: missing 30% data\n');


figure(4)
toploti=1;
for pi=1:sk
	for gi=0:sk
		toplot=zeros(imgheight,imgwidth);
		if gi==0
			ij=(pi-1)*sk+pi;
		else
			ij=(pi-1)*sk+gi;
		end
		for r=1:imgheight
			for c=1:imgwidth
				toplot(r,c) = vtmplot_mis_50(ij,(r-1)*20+c);
			end
		end
		toplot = uint8(toplot);
		subplot(sk,sk+1,toploti);
		imshow(toplot);
		hold on;
	end
end
fprintf('plot the vtm figures: missing 50% data\n');

%% show original v_m_features in image
% figure(1);
% toploti=1;
% for ki=1:sk
%     for mi=1:sm
%         toplot=[];
%         for r=1:30
%             for c=1:20
%                 toplot(r,c) = v_m_features(ki,mi,(r-1)*20+c);
%             end
%         end
%         toplot = uint8(toplot);
%         subplot(sk,sm,toploti);
%         toploti=toploti+1;
%         imshow(toplot);
%         hold on;
%     end
% end
%% finish show image