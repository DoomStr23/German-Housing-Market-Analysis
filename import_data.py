import pandas as pd
from sqlalchemy import create_engine

# 1. Database connection details
DB_USER = "postgres"      
DB_PASS = "yhai3ia8Do!"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "german_housing_db"

# 2. Connect to PostgreSQL
engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# 3. Load the CSV
csv_file = "immo_data.csv"  
print("Loading CSV file...")
df = pd.read_csv(csv_file, encoding="utf-8")

print(f"Loaded {len(df)} rows and {len(df.columns)} columns.")

# 4. Clean up a bit
df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]  # clean column names
df = df.fillna(value=pd.NA)  # replace empty values with NA

# 5. Upload to PostgreSQL
table_name = "german_rent_data"
print(f"Uploading data to PostgreSQL table '{table_name}'...")
df.to_sql(table_name, engine, if_exists="replace", index=False)

print(" Done! Your data is now in PostgreSQL.")
