function mat2flo(matPath)
% mat is a string which its filename likes 'xx.mat'
% 'xx.flo' would have the same prefix name
 
%generate file '.flo'
flow_txt=[matPath(1:length(matPath)-4),'.txt'];
fp=fopen(flow_txt,'w');
fclose(fp);
system('rename *.txt *.flo');
flow_flo=[matPath(1:length(matPath)-4),'.flo'];

%combine vx with vy into an array
load(matPath);
flow_mat(:,:,1)=vx;flow_mat(:,:,2)=vy;

%transform the array 
writeFlowFile(flow_mat,flow_flo);
%delete
txt_del=[matPath(1:end-4),'.txt'];
mat_del=[matPath(1:end-4),'.mat'];
delete(txt_del)
delete(mat_del)
end