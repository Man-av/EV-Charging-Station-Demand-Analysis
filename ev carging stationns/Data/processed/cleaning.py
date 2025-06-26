import pandas as pd

# Load using safe encoding
file_path = "C:/Users/manav/OneDrive/Desktop/ev carging stationns/Data/processed/merged_data.csv"
df = pd.read_csv(file_path, encoding='latin1')

# Remove commas from number columns
cols_to_clean = [
    'population', 'male', 'female',
    'difference between male and female'
]

for col in cols_to_clean:
    df[col] = (
        df[col]
        .astype(str)
        .str.replace(',', '', regex=False)
        .str.extract(r'(\d+)', expand=False)  # keep only numeric part
        .astype(float)
    )

# Save cleaned file with correct encoding
df.to_csv(
    "C:/Users/manav/OneDrive/Desktop/ev carging stationns/Data/processed/merged_data_cleaned.csv",
    index=False,
    encoding='utf-8'
)
