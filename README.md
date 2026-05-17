# 🛒 Amazon Electronics Market Analysis

An end-to-end data analysis project exploring 971 Amazon electronics 
products to answer three core business questions:
1. What's the optimal pricing strategy?
2. Who dominates the market?
3. What drives customer satisfaction?

## 🛠️ Tech Stack

- **Python** (Pandas) — Data cleaning and preparation
- **SQL Server** — Business question analysis
- **Power BI** — Interactive dashboard visualization

## 📊 Key Findings

- **Logitech dominates** with 339K units sold — 5× the next competitor
- **Affordability wins**: Most products sell under $25
- **Engagement paradox**: Cheaper products receive both more reviews 
  and higher ratings
- Top 5 brands hold the majority of market share

## 📁 Project Structure
├── Data/
│   ├── raw_data/                  # Original Amazon dataset (.pkl)
│   └── clean_data/                # Cleaned CSV output
├── amazon_data_cleaning.ipynb     # Python cleaning notebook
├── amazon_analysis.sql            # SQL business analysis
├── Amazon_Analysis.pbix           # Power BI dashboard
└── README.md
