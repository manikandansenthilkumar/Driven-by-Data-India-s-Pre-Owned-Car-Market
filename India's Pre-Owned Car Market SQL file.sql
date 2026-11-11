Create database used_car_analysis;

Use used_car_analysis;

-- STEP 1: CHECK THE SELECTED DATABASE
select database();

-- STEP 2: CHECK THE TABLE STRUCTURE
Describe used_car_price_analysis_india_cleaned;

-- STEP 3: CHECK THE LISTED PRICE VALUES
Select listed_price_inr
From used_car_price_analysis_india_cleaned
Limit 10;

-- STEP 4: CALCULATE THE AVERAGE LISTED PRICE
Select Avg(listed_price_inr) AS average_listed_price
From used_car_price_analysis_india_cleaned;

-- STEP 5: DISPLAY THE AVERAGE PRICE IN INDIAN RUPEES
Select
    Round(Avg(listed_price_inr), 2) As average_listed_price_inr
From used_car_price_analysis_india_cleaned;

-- STEP 6: CALCULATE AVERAGE PRICE BY CAR BRAND
Select brand,
    Round(Avg(listed_price_inr), 0) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By brand
Order By average_listed_price Desc;

-- STEP 7: COUNT CAR LISTINGS AND CALCULATE AVERAGE PRICE BY BRAND
Select brand,
    Count(*) AS total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By brand
Order By average_listed_price Desc;

-- STEP 8: CALCULATE AVERAGE USED-CAR PRICE BY CITY
Select city,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By city
Order By average_listed_price Desc;

-- STEP 9: CALCULATE AVERAGE PRICE BY FUEL TYPE
Select fuel_type,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By fuel_type
Order By average_listed_price Desc;

-- STEP 10: CHECK THE VEHICLE AGE COLUMN
Show Columns
From used_car_price_analysis_india_cleaned
Like '%age%';

-- STEP 11: CALCULATE AVERAGE PRICE BY VEHICLE AGE
Select vehicle_age_years,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By vehicle_age_years
Order By vehicle_age_years Asc;

-- STEP 12: CALCULATE AVERAGE PRICE BY VEHICLE AGE
Select vehicle_age_years,
    Count(*) AS total_listings,
    Round(AVG(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By vehicle_age_years
Order By vehicle_age_years Asc;

-- STEP 13: CHECK THE KILOMETRES-DRIVEN COLUMN
Show Columns
From used_car_price_analysis_india_cleaned
Like '%km%';

-- STEP 14: CHECK MINIMUM AND MAXIMUM KILOMETRES DRIVEN
Select
    Min(km_driven) As minimum_km,
    Max(km_driven) As maximum_km
From used_car_price_analysis_india_cleaned;

-- STEP 15: ANALYSE AVERAGE PRICE BY KM-DRIVEN CATEGORY
Select
    Case
        When km_driven < 50000 Then 'Low'
        When km_driven <= 100000 Then 'Medium'
        When km_driven <= 150000 Then 'High'
        Else 'Very High'
    End As km_category,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By km_category
Order By
    Case km_category
        When 'Low' Then 1
        When 'Medium' Then 2
        When 'High' Then 3
        Else 4
    End;
    
-- STEP 16: CHECK THE TRANSMISSION COLUMN
Show Columns
From used_car_price_analysis_india_cleaned
Like '%transmission%';

-- STEP 17: CALCULATE AVERAGE PRICE BY TRANSMISSION
Select transmission,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By transmission
Order By average_listed_price Desc;

-- STEP 18: CHECK ACCIDENT AND SERVICE HISTORY COLUMNS
Show Columns
From used_car_price_analysis_india_cleaned
Where Field In ('accident_history', 'service_history');

-- STEP 19: CALCULATE AVERAGE PRICE BY ACCIDENT HISTORY
Select accident_history,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By accident_history
Order By average_listed_price Desc;

-- STEP 20: CALCULATE AVERAGE PRICE BY SERVICE HISTORY
Select service_history,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By service_history
Order By average_listed_price Desc;

-- STEP 21: CHECK OWNER COLUMN
Show Columns
From used_car_price_analysis_india_cleaned
Like '%owner%';

-- STEP 22: ANALYSE PRICE BY OWNER CATEGORY
Select owner_count_category,
    Count(*) As total_listings,
    Round(Avg(listed_price_inr), 2) As average_listed_price
From used_car_price_analysis_india_cleaned
Group By owner_count_category
Order By average_listed_price Desc;

-- STEP 23: CHECK PRICE QUARTILES
Select
    Min(listed_price_inr) As minimum_price,
    Max(listed_price_inr) As maximum_price,
    Count(*) As total_listings
From used_car_price_analysis_india_cleaned;

-- STEP 24: CALCULATE PRICE QUARTILES
With ranked_prices As (
    Select listed_price_inr,
        Row_Number() Over (
            Order By listed_price_inr
        ) As row_num,
        Count(*) Over () As total_rows
    From used_car_price_analysis_india_cleaned
    Where listed_price_inr Is Not Null
)

Select
    Max(Case
        When row_num = CEIL(total_rows * 0.25)
        Then listed_price_inr
    End) As Q1,

    Max(Case
        When row_num = CEIL(total_rows * 0.75)
        Then listed_price_inr
    End) As Q3
From ranked_prices;

-- STEP 25: CALCULATE IQR AND OUTLIER LIMITS
Select
    580000 - 197000 As IQR,

    197000 - (1.5 * (580000 - 197000))
        As lower_limit,

    580000 + (1.5 * (580000 - 197000))
        As upper_limit;

-- STEP 26: IDENTIFY HIGH-PRICE OUTLIERS
Select
    `ï»¿listing_id` AS listing_id,
	brand, model, city, listed_price_inr
From used_car_price_analysis_india_cleaned
Where listed_price_inr > 1154500
Order By listed_price_inr Desc;

-- STEP 27: COUNT HIGH-PRICE OUTLIERS
Select
    COUNT(*) AS total_high_price_outliers
From used_car_price_analysis_india_cleaned
Where listed_price_inr > 1154500;