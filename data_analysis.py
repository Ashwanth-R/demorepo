import pandas as pd
import matplotlib.pyplot as plt

# 1. Load the dataset
# Replace 'your_data.csv' with the actual path to your CSV file
try:
    df = pd.read_csv('your_data.csv')
except FileNotFoundError:
    print("Error: 'your_data.csv' not found. Please provide a valid file path.")
    exit()

# 2. Explore the data
print("First 5 rows of the dataset:")
print(df.head())

print("\nSummary statistics of numerical columns:")
print(df.describe())

print("\nInformation about the DataFrame (data types, non-null values):")
print(df.info())

# 3. Data Cleaning (Example: Handling missing values)
# Fill missing values in a specific column with the mean
# Replace 'numerical_column' with the name of your column
if 'numerical_column' in df.columns:
    df['numerical_column'].fillna(df['numerical_column'].mean(), inplace=True)
    print("\nMissing values in 'numerical_column' filled with the mean.")

# Drop rows with any missing values
df.dropna(inplace=True)
print("\nRows with missing values removed.")

# 4. Data Visualization (Example: Histogram and Scatter Plot)
# Create a histogram for a numerical column
# Replace 'numerical_column' with the name of your column
if 'numerical_column' in df.columns:
    plt.figure(figsize=(8, 6))
    plt.hist(df['numerical_column'], bins=10, edgecolor='black')
    plt.title('Distribution of Numerical Column')
    plt.xlabel('Numerical Column Value')
    plt.ylabel('Frequency')
    plt.show()

# Create a scatter plot between two numerical columns
# Replace 'column_x' and 'column_y' with your column names
if 'column_x' in df.columns and 'column_y' in df.columns:
    plt.figure(figsize=(8, 6))
    plt.scatter(df['column_x'], df['column_y'])
    plt.title('Scatter Plot of Column X vs Column Y')
    plt.xlabel('Column X')
    plt.ylabel('Column Y')
    plt.show()

# 5. Basic Analysis (Example: Grouping and Aggregation)
# Group data by a categorical column and calculate the mean of another column
# Replace 'categorical_column' and 'numerical_column'
if 'categorical_column' in df.columns and 'numerical_column' in df.columns:
    grouped_data = df.groupby('categorical_column')['numerical_column'].mean()
    print("\nMean of numerical column grouped by categorical column:")
    print(grouped_data)
