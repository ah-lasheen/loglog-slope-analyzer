# Log-Log Slope Subset Analyzer

This MATLAB script identifies the **best consecutive subset** of experimental (X, Y) data where the **slope of the line of best fit** (on a log-log scale) is:
- **Maximized up to a limit of 2**
- **Spanning at least 24 and at most 50 points**
- **Selected for linearity and steepness, ideal for power-law regions**

Used in chemical lab data analysis to isolate linear regimes from experimental datasets with varying curvature or nonlinearity.

---

## 📂 File Structure

.
├── find_best_loglog_subset.m # Main analysis script
├── TestData/ # Folder for input text files
│ ├── t3.txt # Sample input file (user provides others)
│ └── example.txt # Example format
├── README.md # This file
└── .gitignore # Optional, recommended

## 🚀 How to Use

1. Place your data file in the `TestData/` folder (format: `.txt` with 4 numeric columns per row).
2. Run the script:
   ```matlab
   find_best_loglog_subset
When prompted:

Enter the file name (e.g. t3.txt)

The script will analyze the data, find the optimal segment, and display:

A log-log plot with all data, best subset, and line of best fit

A table in the MATLAB console containing the best subset

## Output
Figure: Double-logarithmic plot with:

All data (black circles)

Selected best subset (blue line)

Fitted line (red dashed)

Table: MATLAB table (best_data_table) showing the selected rows

## Criteria for Selection
Only considers consecutive rows

Slope must be ≤ 2 (hard constraint)

Among valid subsets:

Maximize slope

Break ties by maximizing length

## Lab Use Case
This tool was developed for a chemical research lab to:

Detect power-law behavior in log-log data

Automatically extract the most linear region

Visualize and validate analysis in one step

## Requirements
MATLAB R2020+ (should work on earlier versions too)

Data formatted as a 4-column .txt file (tab or space-delimited)

## License
This project is licensed under the MIT License — see LICENSE for details.

## Contributions
Pull requests, issues, and improvements are welcome — feel free to fork or suggest new features such as:

CSV support
Graphical UI
Better slope/line of best fit estimation
