%% ________________BacFormatics Code starts here:________________  
function matrix_out= I_split_Xaxis_delta(matrix_in, matrix_raw)     
 

 matrix= matrix_in  ;matrix_out=matrix_in;
% code was adopted from MATLAB demo for watershed segmentation:                  
try                  
matrix=matrix./max(max(matrix))  ;                  
end                  
matrix_bw2= double(bwlabel_max(matrix,1));   
 
matrix_bw_therest=matrix-matrix_bw2;







[B,L]=bwboundaries(matrix_bw2,'noholes');                  
stats=regionprops(L,'all');                  
boundary = B{1};                  
% compute a simple estimate of the object's perimeter                  
delta_sq = diff(boundary).^2;                  
obj_area=stats(1).Area;                  
obj_perimeter = sum(sqrt(sum(delta_sq,2)));                  
obj_circularity=4*pi*obj_area/obj_perimeter^2

 
if obj_circularity>0.7                  
return                  
end                  
if   stats(1).Orientation<0                  
stats(1).Orientation=stats(1).Orientation+180  ;                  
end                   
matrix_bw3=   flipdim( imrotate( matrix_bw2,-stats(1).Orientation),1);  
 
peak_1=sum(matrix_bw3);                  
peak_1=  smooth(smooth(smooth(smooth(smooth(peak_1)))))     ;                    
peak_1(isnan( peak_1))=0;                   
npeaks_1=findpeaks_BACWrapper(peak_1) ;                  
peak_2=sum(matrix_bw2');                  
peak_2=  smooth(smooth(smooth(smooth(smooth(peak_2)))))     ;                    
peak_2(isnan( peak_2))=0;                   
npeaks_2=findpeaks_BACWrapper(peak_2) ;

if length(npeaks_1)+length(npeaks_2)==2  
return                  
end                  
% se = strel('disk',2);                  
% erodedBW = imerode(matrix_bw2,se);     
% 
%  

% jj=1;                  
% while max(max(bwlabel(erodedBW)))==1 && jj<5                  
% erodedBW = imerode(erodedBW,se);                  
% jj=jj+1;                  
% end                  
% if jj==10 || (max(max(erodedBW )) == 0  )                  
% return                  
% end   


 
          
try                  
matrix_raw= matrix_raw.*double(matrix_bw2);                  
catch                  
matrix_raw= double(matrix_raw).*double(matrix_bw2);                  
end                  
matrix_temp =   matrix_raw;     
 



matrix =zeros(size(matrix_temp,1)+4,size(matrix_temp,2)+4);                  
matrix(2:end-3,2:end-3)=matrix_temp;                  
temp_Threshold2=matrix_bw2;                  
temp_Threshold3=bwlabel_max(temp_Threshold2,4);                  
data= regionprops(temp_Threshold3,'Centroid',  'Orientation','Majoraxislength','Minoraxislength');                  
D = bwdist(~temp_Threshold3);                  
XY=find(ismember(D,1)) ;                  
[Y,X] = ind2sub(size(temp_Threshold3),XY);                  
MaxlineLength = data.MajorAxisLength;                  
% teta =  rand(1)*360;                  
teta=  data.Orientation-90;                  
x(2)  =      data.Centroid(1);                  
y(2)  =      data.Centroid(2) ;                  
if teta>=0 && teta<=90                  
angle2=     -teta    ;                  
elseif teta<0 && teta>=-90                  
angle2=     -teta    ;                  
end                  
try                  
angle3=    angle2-180;                  
catch                  
angle2=     -teta ; angle3=    angle2-180;                  
end                  
% Line Length can be any length from 1 to data.MinorAxisLength                  
r=round(1:data.MajorAxisLength+1);                  
xx1 = x(2) + r * cosd(angle2);                  
yy1 = y(2) + r * sind(angle2);                  
xx3 = x(2) + r * cosd(angle3);                  
yy3 = y(2) + r * sind(angle3);                  
a1=zeros(1,length(r)); a3=a1;                  
for ii=1:length(r)                  
[a1(ii),JJ1(ii)]=  min((X-xx1(ii)).^2+ (Y-yy1(ii)).^2)  ;                  
[a3(ii),JJ3(ii)]=  min((X-xx3(ii)).^2+ (Y-yy3(ii)).^2)   ;                  
end                  
[ ~,lineLength1 ]=  min(a1);                  
[ ~,lineLength3 ]=  min(a3);                  
%      ---------------                  
x(1) = x(2) + lineLength1 * cosd(angle2);                  
y(1) = y(2) + lineLength1 * sind(angle2);                  
x(3) = x(2) + lineLength3 * cosd(angle3);                  
y(3) = y(2) + lineLength3 * sind(angle3);                  
x(2)=[]; y(2)=[]; % splitting doesnt need the centroid                  
x=round(x)                  
y=round(y)                  
se = strel('disk',1);                  
BW= imdilate(temp_Threshold3,se);                  
BW = bwperim(BW);                  
XY=find(ismember(BW,1)) ;                  
[Y,X] = ind2sub(size(temp_Threshold3),XY);                  
[~,Index1]=  min((X-x(1)).^2+ (Y-y(1)).^2)  ;                  
[~,Index2]=  min((X-x(2)).^2+ (Y-y(2)).^2)   ;                  
x(1)=X(Index1);y(1)=Y(Index1);x(2)=X(Index2);y(2)=Y(Index2);     



 

[matrix_bw2,kk]=intensity_split_function(x,y,temp_Threshold3,matrix);    

  




matrix_bw2 =bwareaopen(matrix_bw2,20);                  
matrix_bw2=bwlabel_max(matrix_bw2,2);    
matrix_bw3=bwlabel(matrix_bw2,4 );


 


  L1=length(find(ismember(matrix_bw3,1)));L2=length(find(ismember(matrix_bw3,2)));
 
  if (abs(L1-L2))/(L1+L2)>0.5
      return
  end


matrix_out=   logical(double(matrix_bw2)+double(matrix_bw_therest));

