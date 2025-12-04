% --- Pre-processing --- %
d_gray = rgb2gray(d);
BW = imbinarize(d_gray);
BW = ~BW; % Invert to make foreground (tissue/edges) white
edges = edge(BW,'canny',[0.03 0.15]); % Use slightly lower thresholds for better edge capture
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

% --- Extract Line Segments --- %
lines_all_horz = houghlines(edges, theta, rho, P_all_horz, 'FillGap', 30, 'MinLength', 100);

% --- Visualization --- %
figure;

subplot(1,2,1); imshow(d); title('Original');
subplot(1,2,2); imshow(d); hold on;
title(['Detected Horizontal Lines (', num2str(length(lines_all_horz)), ' segments)']);

colors = hsv(length(lines_all_horz));
for k = 1:length(lines_all_horz)
    xy = [lines_all_horz(k).point1; lines_all_horz(k).point2];
    plot(xy(:,1), xy(:,2), 'Color', colors(k,:), 'LineWidth', 3);
end
