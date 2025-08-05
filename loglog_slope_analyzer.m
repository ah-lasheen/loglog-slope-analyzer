% =====================================================
% Script: find_best_loglog_subset.m
% Purpose: Identify and plot the best consecutive subset of (X,Y) data 
%          on a log-log scale where the slope of the linear fit is 
%          maximized up to 2, then length is maximized (24–50 points).
% Usage: Run script and enter filename (e.g. 't3.txt') when prompted.
% Output: 
%   - best_data_table: MATLAB table of the selected subset
%   - Double-logarithmic plot showing all data, subset, and fit line
% =====================================================

%% Prompt for data file and load into MATLAB
user_file_name = input('Enter the data file name (e.g. t3.txt): ', 's');
input_filename = fullfile('TestData', user_file_name);
data_table     = readtable(input_filename);     % Read file into table
raw_data_array = table2array(data_table);       % Convert table to numeric array

%% Remove rows with any NaN values
cleaned_data_array = raw_data_array(~any(isnan(raw_data_array), 2), :);

%% Extract X and Y vectors
%   - X: first column of data
%   - Y: negative of second column, so that Y > 0 for log-log plotting
x_values = cleaned_data_array(:, 1);
y_values = -cleaned_data_array(:, 2);
num_points = numel(x_values);

%% Defined search parameters
max_allowed_slope = 2;     % Maximum slope of the line of best fit allowed
min_window_length = 24;    % Minimum number of consecutive points to consider
max_window_length = 50;    % Maximum number of consecutive points to consider

%% Initialized variables for lexicographic optimization
best_window_slope   = -Inf;                       % Highest slope found so far (<= 2)
best_window_length  = 0;                          % Length of that window
best_window_indices = [1, 1];                     % [startIdx, endIdx] of best window

%% Lexicographic search over all valid windows
%    First maximize slope (but <= 2), then among ties maximize length.
for startIdx = 1:(num_points - min_window_length + 1)
    for endIdx = startIdx + min_window_length - 1 : ...
                   min(num_points, startIdx + max_window_length - 1)
        % Extract the current window of points
        window_x = x_values(startIdx:endIdx);
        window_y = y_values(startIdx:endIdx);
        
        % Skip if any values <= 0 (invalid for log10)
        if any(window_x <= 0) || any(window_y <= 0)
            continue;
        end
        
        % Compute log-log linear fit: slope = fit_coeffs(1)
        fit_coeffs    = polyfit(log10(window_x), log10(window_y), 1);
        window_slope  = fit_coeffs(1);
        
        % Only consider windows whose slope does not exceed 2
        if window_slope <= max_allowed_slope
            window_length = endIdx - startIdx + 1;
            % Lexicographic comparison:
            %   1) prefer higher slope
            %   2) if slopes equal (to within tolerance), prefer longer window
            if (window_slope > best_window_slope) || ...
               (abs(window_slope - best_window_slope) < 1e-8 && window_length > best_window_length)
                best_window_slope   = window_slope;
                best_window_length  = window_length;
                best_window_indices = [startIdx, endIdx];
            end
        end
    end
end

%% Handle case where no valid subset was found
if best_window_length == 0
    warning('No valid subset found with slope ≤ %d and length ≥ %d.', max_allowed_slope, min_window_length);
    best_data_table = table(); 
    return;
end

%% Extract the best subset from the cleaned data
best_data_array = cleaned_data_array(...
    best_window_indices(1) : best_window_indices(2), :);
% Restore original Y sign for display
best_data_array(:,2) = -best_data_array(:,2);

% Convert to table and preserve original column names
best_data_table = array2table(...
    best_data_array,'VariableNames',data_table.Properties.VariableNames);

%% Compute the best-fit line on the selected subset
x_best            = best_data_array(:, 1);
y_best            = best_data_array(:, 2);
best_fit_coeffs   = polyfit(log10(x_best), log10(y_best), 1);
best_fit_slope    = best_fit_coeffs(1);
best_fit_y_values = 10.^( polyval(best_fit_coeffs, log10(x_best)) );

%% Plot all data and highlight the best subset on log-log axes
figure;
% Plot all points as black circles
loglog(x_values,y_values,'ko','MarkerSize',4,'DisplayName','All Data');
hold on;
% Overlay best subset as a solid blue line
loglog(x_best,y_best,'b-','LineWidth',2, ...
       'DisplayName',sprintf('Best Subset (%d pts)',best_window_length));
% Overlay the subset’s fit line as a red dashed line
loglog(x_best,best_fit_y_values,'r--','LineWidth',2, ...
    'DisplayName',sprintf('Fit (slope=%.4f)',best_fit_slope));

% Label axes and add title/legend
xlabel('log(Col 1)');
ylabel('log(-Col 2)');
title('Optimal Consecutive Subset: Maximize Slope ≤ 2, Then Length');
legend('Location','best');
grid on;

%% Displays the resulting best-data table
disp(best_data_table);