%Akash Mitra
%am132

%Inclass 14

%Work with the image stemcells_dapi.tif in this folder

% (1) Make a binary mask by thresholding as best you can

img_reader = bfGetReader('stemcells_dapi.tif');
iplane = []

for i=1:img_reader.getSizeT
    iplane = img_reader.getIndex(img_reader.getSizeZ-1,img_reader.getSizeC-1, i-1)+1;
    img = bfGetPlane(img_reader, iplane);
    img_d = im2double(img);
    img_bright = uint16((2^16-1)*(img_d/max(max(img_d))));
    level = graythresh(img_bright);
    img_bw = imbinarize(img_bright,level);
end

subplot(1,2,1), imshow(img, []), title('Original Image');
subplot(1,2,2), imshow(img_bw, [])
title('Image with binary mask thresholding')

% (2) Try to separate touching objects using watershed. Use two different
% ways to define the basins. (A) With erosion of the mask (B) with a
% distance transform. Which works better in this case?

%Erosion of mask
img_erode = imerode(img_bw, strel('disk',5));
K = watershed(img_erode);
img_erode(K == 0) = 0;
imshow(img_erode,[]);

%Distance transform on image complement
D = bwdist(~img_bw);
%Negate distance transform
D = -bwdist(~img_bw);
%Watershed application
L = watershed(D);
img_bw(L == 0) = 0;
imshow(img_bw)



subplot(1,2,1), imshow(img_erode, []), title('Eroded Watershed Image');
subplot(1,2,2), imshow(img_bw, [])
title('Distance Transform Watershed')

%In this instance distance transform worked better since it attempted to
%sepearate touching objects and did not drop too many cells in the process
%(unlike erosion).
