# Log-Log Slope Subset Analyzer
This MATLAB script identifies the **best consecutive subset** of experimental (X, Y) data where the **slope of the line of best fit** (on a log-log scale) is:
- **Maximized up to a limit of 2**
- **Spanning at least 24 and at most 50 points**
- **Selected for linearity and steepness, ideal for power-law regions**
**NOTE: These parameters can be modified in the file.

## Sample Output:
<img width="876" height="561" alt="image" src="https://github.com/user-attachments/assets/78e64573-a2d5-466c-8af0-c128fd301c4c" />

## How to Use
1. Place your data file in the `TestData/` folder (format: `.txt`)
2. Run the 'loglog_slope_analyzer' script:
 
When prompted:
- Enter the file name (e.g. t3.txt)
- The script will analyze the data, find the optimal segment, and display:
   - A log-log plot with all data, best subset, and line of best fit
   - A table in the MATLAB console containing the best subset

## Output
Figure: Double-logarithmic plot with:
- All data (black circles)
- Selected best subset (blue line)
- Fitted line (red dashed)
- Table: MATLAB table (best_data_table) showing the selected rows

## Criteria for Selection
- Only considers consecutive rows
- Slope must be ≤ 2 (constraint can be changed in program)
- Among valid subsets:
   - Maximize slope
   - Break ties by maximizing length

## Requirements
- MATLAB R2020+ (should work on earlier versions too)
- Data formatted as a 4-column .txt file (tab or space-delimited. For sample files, review t#.txt in the TestData folder of this repository)

## License
This project is licensed under the **Apache License 2.0** — see LICENSE for details.

## Contributions
Pull requests, issues, and improvements are welcome — feel free to fork or suggest new features such as:
- CSV support
- Graphical UI
- Better slope/line of best fit estimation
