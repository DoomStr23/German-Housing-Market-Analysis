# German Housing Market Analysis

Analysis of apartment rental listings in Germany using data from ImmobilienScout24. This project explores rental price patterns across German federal states, the relationship between property features and rent, and provides statistical insights into the housing market.

## Dataset

The data comes from [Kaggle - Apartment Rental Offers in Germany](https://www.kaggle.com/datasets/corrieaar/apartment-rental-offers-in-germany/data), containing rental listings from ImmobilienScout24 with information about:
- Rental prices (base rent, total rent, service charges)
- Property characteristics (living space, number of rooms, floor)
- Location (federal state, postal code)
- Amenities (balcony, lift, garden, cellar)
- Property condition and construction year

## Project Structure

- `immo_data.csv` - Raw dataset from Kaggle
- `import_data.py` - Script to import CSV data into PostgreSQL
- `explore_data.ipynb` - Jupyter notebook for data exploration and visualization
- `SQL_Queries.sql` - SQL queries for data cleaning and analysis
- `cleaned_rent_data.csv` - Processed dataset exported from database


## Technologies Used

- **Python 3.x**: Data manipulation and analysis
- **PostgreSQL**: Database for data storage and querying
- **pandas**: Data processing and analysis
- **SQLAlchemy**: Database connection and ORM
- **Seaborn & Matplotlib**: Data visualization
- **Jupyter Notebook**: Interactive analysis environment

## Setup and Installation

### Prerequisites

- Python 3.7 or higher
- PostgreSQL 12 or higher
- pip package manager

### Installing required Python packages

pip install pandas sqlalchemy psycopg2-binary seaborn matplotlib jupyter scipy

### Set up PostgreSQL database

CREATE DATABASE german_housing_db;

### Update database credentials in `import_data.py` and `explore_data.ipynb`

DB_USER = "your_username"
DB_PASS = "your_password"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "german_housing_db"


## Key Findings

- **Rent Distribution**: Analysis reveals significant rent variations across German federal states
- **Living Space Impact**: Strong positive correlation between living space and total rent
- **Balcony Premium**: Statistical analysis shows apartments with balconies command higher rents
- **Regional Patterns**: Median rent analysis by federal state identifies the most and least expensive regions

## Features

- Data cleaning and preprocessing pipeline
- SQL views for aggregated state-level statistics
- Correlation analysis of property features
- Statistical hypothesis testing (t-tests for amenity impact)
- Visualizations including histograms, boxplots, scatter plots, and heatmaps

## Database Schema

The main table `german_rent_data` includes calculated columns:
- `rent_per_m2`: Rental price per square meter
- `plz_text`: Cleaned postal code as text
- `regio1_clean`: Standardized federal state names

Views created:
- `vw_state_rent_summary`: Aggregated rent statistics by state
- `vw_kpis`: Overall market key performance indicators

## License

This project uses data from Kaggle under their terms of service. Please refer to the [original dataset](https://www.kaggle.com/datasets/corrieaar/apartment-rental-offers-in-germany/data) for data licensing information.

## Acknowledgments

- Data source: ImmobilienScout24 via Kaggle user corrieaar
- Analysis conducted as part of a personal project
