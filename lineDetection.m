% --- Pre-processing --- %
tri_1 = dicomread('BO2WL_F_10089_T1_CALF.dcm');
d_gray = rgb2gray(tri_1);
BW = imbinarize(d_gray);
BW = ~BW;
edges = edge(BW,'canny',[0.03 0.15]);
[H,theta,rho] = hough(edges);

% --- Hough Space Horizontal Lines --- %
idx90 = abs(theta - 90) < 5;
idx_90 = abs(theta - (-90)) < 5;
idx_horizontal = idx90 | idx_90;

H_only_horizontal = H;
H_only_horizontal(:, ~idx_horizontal) = 0;

NumPeaks = 10;
P_all_horz = houghpeaks(H_only_horizontal, NumPeaks, ...
                       'Threshold', 0.2*max(H_only_horizontal(:)), ...
                       'NHoodSize', [11 11]);

lines_all_horz = houghlines(edges, theta, rho, P_all_horz, ...
                            'FillGap', 70, 'MinLength', 100);

% --- Remove lines near image edges --- %
imgSize = size(tri_1);
imgHeight = imgSize(1);
imgWidth = imgSize(2);

edgeMargin = 40;   % ignore top/bottom border lines
minSpacing = 50;   % ignored space between lines
validLines = [];

for i = 1:length(lines_all_horz)
    y1 = lines_all_horz(i).point1(2);
    y2 = lines_all_horz(i).point2(2);
    y_mid = mean([y1, y2]);

    if y_mid > edgeMargin && y_mid < (imgHeight - edgeMargin)
        validLines = [validLines, lines_all_horz(i)];
    end
end

if isempty(validLines)
    error('No valid horizontal lines detected (all were near the borders).');
end


% Sort by length
line_lengths = arrayfun(@(L) norm(L.point1 - L.point2), validLines);
[~, sortedIdx] = sort(line_lengths, 'descend');
sortedLines = validLines(sortedIdx);

% Pick first (longest)
selected = sortedLines(1);
y_first = mean([selected.point1(2), selected.point2(2)]);

% Find second line with enough distance
secondFound = false;
for i = 2:length(sortedLines)
    y_candidate = mean([sortedLines(i).point1(2), sortedLines(i).point2(2)]);
    if abs(y_candidate - y_first) >= minSpacing
        second = sortedLines(i);
        secondFound = true;
        break;
    end
end

if ~secondFound
    warning('Only one line satisfied spacing requirements. Showing only one.');
    selectedLines = [selected];
else
    selectedLines = [selected, second];
end

% --- Visualization --- %
figure;
imshow(tri_1); hold on;
title('Horizontal Lines');

for i = 1:length(selectedLines)
    line_data = selectedLines(i);

    % Forced horizontal: use mean y-position
    y_level = mean([line_data.point1(2), line_data.point2(2)]);

    x_full = [1, imgWidth];
    y_full = [y_level, y_level];

    % Red line
    plot(x_full, y_full, 'Color', [1, 0, 0], 'LineWidth', 2);
end
