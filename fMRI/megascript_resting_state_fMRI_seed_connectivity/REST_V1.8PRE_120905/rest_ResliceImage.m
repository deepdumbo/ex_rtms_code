function [OutVolume] = rest_ResliceImage(InputFile,OutputFile,NewVoxSize,hld, TargetSpace)
% FORMAT [OutVolume] = y_ResliceImage(InputFile,OutputFile,NewVoxSize,hld, TargetSpace)
% Input:
%   InputFile - input filename
%   OutputFile - output filename
%   NewVoxSize - 1x3 matrix of new vox size.
%   hld - interpolation method. 0: Nearest Neighbour. 1: Trilinear.
%   TargetSpace - Define the target space. 'ImageItself': defined by the image itself (corresponds  to the new voxel size); 'XXX.img': defined by a target image 'XXX.img' (the NewVoxSize parameter will be discarded in such a case).
% Output:
%   OutVolume   The resliced output volume
%   And the resliced image file stored in OutputFile
%   Example: y_Reslice('D:\Temp\mean.img','D:\Temp\mean3x3x3.img',[3 3 3],1,'ImageItself')
%       This was used to reslice the source image 'D:\Temp\mean.img' to a
%       resolution as 3mm*3mm*3mm by trilinear interpolation and save as 'D:\Temp\mean3x3x3.img'.
%__________________________________________________________________________
% Written by YAN Chao-Gan 090302 for DPARSF. Referenced from spm_reslice.m in SPM5.
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, China, 100875
% ycg.yan@gmail.com
%__________________________________________________________________________
% Revised by YAN Chao-Gan 100401. Fixed a bug while calculating the new dimension.
% Last Revised by YAN Chao-Gan 120229. Simplified the processing.

if nargin<=4
    TargetSpace='ImageItself';
end


if ~strcmpi(TargetSpace,'ImageItself')
    [RefData, RefHead]   = rest_ReadNiftiImage(TargetSpace);
    mat=RefHead.mat;
    dim=RefHead.dim;
else
    [RefData, RefHead]   = rest_ReadNiftiImage(InputFile);
    origin=RefHead.mat(1:3,4);
    origin=origin+[RefHead.mat(1,1);RefHead.mat(2,2);RefHead.mat(3,3)]-[NewVoxSize(1)*sign(RefHead.mat(1,1));NewVoxSize(2)*sign(RefHead.mat(2,2));NewVoxSize(3)*sign(RefHead.mat(3,3))];
    origin=round(origin./NewVoxSize').*NewVoxSize';
    mat = [NewVoxSize(1)*sign(RefHead.mat(1,1))                 0                                   0                       origin(1)
        0                         NewVoxSize(2)*sign(RefHead.mat(2,2))              0                       origin(2)
        0                                      0                      NewVoxSize(3)*sign(RefHead.mat(3,3))  origin(3)
        0                                      0                                   0                          1      ];

    dim=(RefHead.dim-1).*diag(RefHead.mat(1:3,1:3))';
    dim=floor(abs(dim./NewVoxSize))+1;
end


[SourceData SourceHead]=rest_ReadNiftiImage(InputFile);

[x1,x2,x3] = ndgrid(1:dim(1),1:dim(2),1:dim(3));
d     = [hld*[1 1 1]' [1 1 0]'];
C = spm_bsplinc(SourceHead, d);
v = zeros(dim);

M = inv(SourceHead.mat)*mat; % M = inv(mat\SourceHead.mat) in spm_reslice.m
y1   = M(1,1)*x1+M(1,2)*x2+(M(1,3)*x3+M(1,4));
y2   = M(2,1)*x1+M(2,2)*x2+(M(2,3)*x3+M(2,4));
y3   = M(3,1)*x1+M(3,2)*x2+(M(3,3)*x3+M(3,4));

OutVolume    = spm_bsplins(C, y1,y2,y3, d);


OutHead=SourceHead;
OutHead.mat      = mat;
OutHead.dim(1:3) = dim;

rest_WriteNiftiImage(OutVolume,OutHead,OutputFile);

