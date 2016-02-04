function [ matrix_out ] = imfill_bwlabel( matrix_in)
%  save all
%  pause
% matrix is BW
matrix=bwlabel(matrix_in);
 matrix_out=zeros(size(matrix,1),size(matrix,2));
for ii=1:max(matrix(:))
    temp=matrix;
    temp(temp~=ii)=0;
    temp=temp./ii;
    matrix_out=matrix_out+imfill(temp,'holes');  
end
 
   matrix_out(matrix_out>0)=1;