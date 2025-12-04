function [largestLineMask, overlayImage] = detectLargestLine(origImage)

    % If color, convert to grayscale
    if ndims(origImage) == 3
        gray = rgb2gray(origImage);
    else
        gray = origImage;
    end

    % Binarize
    T = graythresh(gray);
    bw = imbinarize(gray, T);

    % Clean noise
    bw = bwareaopen(bw, 50);        % remove tiny components
    bw = imclose(bw, strel('line', 15, 0));  % enhance linear structures

    % Label connected components
    CC = bwconncomp(bw);

    % Measure properties of each component
    stats = regionprops(CC, 'Area', 'MajorAxisLength', 'PixelIdxList');

    if isempty(stats)
        largestLineMask = false(size(bw));
        overlayImage = origImage;
        return;
    end

    % Select the largest line based on MajorAxisLength
    [~, idx] = max([stats.MajorAxisLength]);

    % Create mask of the largest line
    largestLineMask = false(size(bw));
    largestLineMask(stats(idx).PixelIdxList) = true;

    % Create overlay on original image
    overlayImage = imoverlay(mat2gray(origImage), largestLineMask, [1 0 0]); % red mask

end

calf = dicomread("images\BO2WL_F_10089_T1_CALF.dcm");
bic1 = dicomread("images/BO2WL_F_20048_T1_BIC.dcm");
bic2 = dicomread("images/BO2WL_F_20050_T1_BIC.dcm");
tri = dicomread("images/BO2WL_F_20052_T1_TRI.dcm");

h = imagesc(calf, [0 1024]); colormap(gray), colorbar, axis image, axis off;
Y = imcrop(h);

calfGray = rgb2gray(Y);
TCalf = graythresh(calfGray);
bwImageCalf = imbinarize(calfGray, TCalf);

bic1Gray = rgb2gray(bic1);
TBic1 = graythresh(bic1Gray);
bwImageBic1 = imbinarize(bic1Gray, TBic1);

bic2gray = rgb2gray(bic2);
TBic2 = graythresh(bic2gray);
bwImageBic2 = imbinarize(bic2gray, TBic2);

triGray = rgb2gray(tri);
TTri = graythresh(triGray);
bwImageTri = imbinarize(triGray, TTri);

[maskCalf, overlayCalf] = detectLargestLine(Y);

figure;
subplot(1, 4, 1), imshow(overlayCalf, []), title('Calf Image');
subplot(1, 4, 2), imshow(bwImageBic1, []), title('Bic1 Image');
subplot(1, 4, 3), imshow(bwImageBic2, []), title('Bic2 Image');
subplot(1, 4, 4), imshow(bwImageTri, []), title('Tri Image');