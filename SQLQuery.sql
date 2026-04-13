-- create database
CREATE DATABASE walmartSales;

-- change name from WalmartSalesData.csv to WalmartSales
EXEC sp_rename '[WalmartSalesData.csv]', 'WalmartSales';

--Edit The Data Type of Rating column
ALTER TABLE WalmartSales ALTER COLUMN Rating DECIMAL(10, 1);

-- add day name to table 
ALTER TABLE WalmartSales add Day_name VARCHAR(50);

UPDATE WalmartSales
SET Day_name= DATENAME(weekday, Date);

-- add Time_of_Day to column
ALTER TABLE WalmartSales add  Time_of_Day VARCHAR(50);

UPDATE WalmartSales
SET Time_of_Day= (CASE
                    WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
					WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
					ELSE 'evening'
					END );



-- add Month column to table
ALTER TABLE WalmartSales add Month VARCHAR(50);

UPDATE WalmartSales 
SET Month=DATENAME(Month,Date);


SELECT *
FROM WalmartSales;

----------------------------------Generic Question--------------------------------------
--Q1) How many unique cities does the data have?

SELECT DISTINCT City
FROM WalmartSales;

--Q2)In which city is each branch?

SELECT DISTINCT City ,Branch
FROM WalmartSales;

--------------------------------Product-----------------------------------------
--Q1)How many unique product lines does the data have?

SELECT DISTINCT Product_line
FROM WalmartSales;

--Q2)What is the most selling product line?

SELECT Product_line , SUM(Quantity) Quantity
FROM WalmartSales
GROUP BY Product_line
ORDER BY Quantity DESC;

--Q3)-- What is the total revenue by month?

SELECT Month , SUM(Total) Total_revenue
FROM WalmartSales
GROUP BY Month
ORDER BY Total_revenue DESC;

--Q4)What month had the largest COGS?

SELECT Month, SUM(cogs) AS COGS
FROM WalmartSales
GROUP BY  Month
ORDER BY COGS DESC;

--Q5) What product line had the largest revenue?

SELECT Product_line , SUM(total) AS [largest revenue]
FROM WalmartSales
GROUP BY Product_line
ORDER BY [largest revenue] DESC;


--Q6) What is the city with the largest revenue?

SELECT City , SUM(total) AS Largest_revenue
FROM WalmartSales
GROUP BY City
ORDER BY Largest_revenue DESC;

--Q7) What product line had the largest VAT?

SELECT Product_line , SUM(Tax_5) AS 'Largest VAT'
FROM WalmartSales
GROUP BY Product_line
ORDER BY 'Largest VAT' DESC;

--Q8) Which branch sold more products than average product sold?

SELECT Branch , SUM(Quantity) AS Quantity
FROM WalmartSales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM WalmartSales);
      
--Q9)What is the most common product line by gender?

SELECT Product_line , Gender , COUNT(Gender) AS Total_Gender
FROM WalmartSales
GROUP BY Product_line , Gender 
ORDER BY Total_Gender DESC;

--Q10)What is the average rating of each product line?

SELECT Product_line , AVG(Rating) AS Avg_rating
FROM WalmartSales
GROUP BY Product_line
ORDER BY Avg_rating DESC;

--------------------------------Customers ------------------------------------------
--Q1)How many unique customer types does the data have?

SELECT DISTINCT Customer_type
FROM WalmartSales;

--Q2)How many unique payment methods does the data have?

SELECT DISTINCT Payment
FROM WalmartSales;

--Q3)What is the most common customer type?

SELECT Customer_type , COUNT(Customer_type) AS 'Customer type'
FROM WalmartSales
GROUP BY Customer_type
ORDER BY 'Customer type' DESC;

--Q4)What is the gender of most of the customers?

SELECT Gender , COUNT(Gender) AS 'Count Gender'
FROM WalmartSales
GROUP BY Gender
ORDER BY 'Count Gender' DESC;

--Q5)What is the gender distribution per branch?

SELECT Branch , Gender , Count(Gender) AS distribution
FROM WalmartSales
GROUP BY Branch , Gender;

--Q6) Which time of the day do customers give most ratings?

SELECT Day_name , MAX(Rating) AS 'Max Rating'
FROM WalmartSales
GROUP BY Day_name
ORDER BY 'Max Rating' DESC;

--Q7)Which time of the day do customers give most ratings per branch?

SELECT Day_name , MAX(Rating) AS 'Max Rating'
FROM WalmartSales
WHERE Branch='A'
GROUP BY Branch ,Day_name 
ORDER BY 'Max Rating' DESC;

--Q9)Which day fo the week has the best avg ratings?

SELECT Day_name , AVG(Rating) AS 'Avg Rating'
FROM WalmartSales
GROUP BY Day_name
ORDER BY 'Avg Rating' DESC;

--Q10)Which day of the week has the best average ratings per branch?

SELECT Branch , Day_name , AVG(Rating) 'Avg Rating'
FROM WalmartSales
GROUP BY Branch , Day_name
ORDER BY 'Avg Rating' DESC;

----------------------------------Sales--------------------------------------

--Q1)Which of the customer types brings the most revenue?

SELECT Customer_type , SUM (Total) AS Total_Revenue
FROM WalmartSales
GROUP BY Customer_type
ORDER BY Total_Revenue DESC;

--Q2)Which city has the largest tax/VAT percent?

SELECT City, ROUND (SUM(Tax_5),2) Total_VAT
FROM WalmartSales
GROUP BY City
ORDER BY Total_VAT DESC;

--Q3)Which customer type pays the most in VAT?
SELECT Customer_type , ROUND (SUM(Tax_5),2) Total_VAT
FROM WalmartSales
GROUP BY Customer_type
ORDER BY Total_VAT DESC;



