%% ________________BacFormatics Code starts here:________________  
% function MATRIX = Find_Tracks(centy1,start_track, end_track,original_MATRIX,min_length,MODE)
% MATRIX= Find_Tracks_vectorized(centy1,start_track, end_track ,mindisp,MODE)
%
 function [Data,centy1] = Find_Tracks_vectorized(centy1,vec )
 
 
matrix=[];
for n=1:length(vec)
    ii=vec(n);
    if ~isempty(centy1(ii).cdata)
        VC=find(centy1(ii).cdata(:,4)==-1); VC(:,2)=ii;
        if isempty(VC)~=1
            if isempty(matrix)==1
                matrix=VC;
            else
                matrix(end+1:end+size(VC,1),:)=VC;
                
            end
        end
    end
end
 

 save  all
MATRIX=[];
h=waitbar(0,'please wait')
for ii= 1:size(matrix,1)
        waitbar(0.9*ii/size(matrix,1))
        Location_within_frame=matrix(ii,1);
        Frame=matrix(ii,2)  
        MATRIX(Frame,ii*2-1)=centy1(Frame).cdata( Location_within_frame,1);
        MATRIX(Frame,ii*2)=centy1(Frame).cdata( Location_within_frame,2); 
        centy1(Frame).cdata( Location_within_frame,6)=ii;
        
        
        
        
        
       vec_temp=vec;
       
       Counter=find(ismember(vec,Frame));
         
        while  Frame<vec(end)
        
            Counter=Counter+1;
           Frame=vec(Counter) 
        
            
            if ~isempty(centy1(Frame).cdata)
                Location_within_frame= find(centy1(Frame).cdata(:,4)==Location_within_frame);
                if isempty(Location_within_frame)~=1
                    MATRIX(Frame,ii*2-1) =centy1(Frame).cdata(Location_within_frame,1);
                    MATRIX(Frame,ii*2)=centy1(Frame).cdata(Location_within_frame,2);
                    centy1(Frame).cdata( Location_within_frame,6)=ii;
                else
                    break
                end 
            else
                break
            end
            
        end 
end

M=MATRIX./MATRIX;[a,start_XY]=nanmin(M);Index= isnan(a); MATRIX(:,Index)=[];
Data.vec_temp1=MATRIX(:);
Data.vec_temp2=  find(Data.vec_temp1~=0) ;
Data.vec_temp1(Data.vec_temp1==0)=[];
Data.N=size(MATRIX,1);
Data.M=size(MATRIX,2);

close(h)
  
 