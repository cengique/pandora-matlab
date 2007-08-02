% [data,errmsg]=nrn_vread(FileName,machineformat) 
% machineformat like in fopen (i.e. 'b' for big endian, 'l' for little endian) 
% 
% reads binary files, that was written with Vector.vwrite in NEURON 
%
% Author: Konstantin Miller <miller@cs.tu-berlin.de>, Aug 09, 2005.
 
function [data,errmsg]=nrn_vread(FileName,machineformat) 
 
 data = []; 
 
 [fid,errmsg] = fopen(FileName,'r',machineformat); 
 if fid==-1 
    return; 
 else 
    errmsg = sprintf('File opened successfully'); 
 end 
 
 [header,cnt]=fread(fid,2,'int32'); 
 if cnt~=2 
    errmsg = sprintf('Could not read the vwrite header'); 
    fclose(fid); 
    return; 
 end 
 
 precision = 'double'; % to avoid Matlab warning 
 if header(2)==4 
    precision = 'double'; 
 elseif header(2)==3 
    precision = 'float32'; 
 elseif header(2)==5 
    precision = 'int'; 
 else 
    errmsg = sprintf('Unsupported precision argument'); 
    fclose(fid); 
    return; 
 end 
 
 [data,cnt]=fread(fid,inf,precision); 
 if cnt~=header(1) 
    errmsg = sprintf('Only %d instead of %d Samples read',cnt,header(1)); 
    data = []; 
    fclose(fid); 
    return; 
 else 
    errmsg = sprintf('Successfully read %d Samples',cnt); 
 end 
 
 fclose(fid); 
 