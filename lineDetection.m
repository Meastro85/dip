% --- Pre-processing --- %
d_gray = rgb2gray(d);
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
lines_all_horz = houghlines(edges, theta, rho, P_all_horz, 'FillGap', 70, 'MinLength', 100);

% --- Visualization --- %
figure;

subplot(1,2,1); imshow(d); title('Original');
subplot(1,2,2); imshow(d); hold on;
title('Selected Horizontal Lines (Longer)');
lines_to_show_indices = [2, 6];

selected_colors = [
    1.0, 0.0, 1.0; % Pink
    0.5, 0.0, 0.5  % Purple
];

for i = 1:length(lines_to_show_indices)
    k = lines_to_show_indices(i);

    if k <= length(lines_all_horz)
        line_data = lines_all_horz(k);
        xy = [line_data.point1; line_data.point2];
        plot(xy(:,1), xy(:,2), 'Color', selected_colors(i,:), 'LineWidth', 3);
    else
        disp(['Warning: Index ', num2str(k), ' is out of bounds or line did not meet the new length criteria.']);
    end
end
