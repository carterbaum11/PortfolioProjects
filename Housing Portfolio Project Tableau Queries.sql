--Table 1 - Sales by City

select propertysplitcity, count(propertysplitcity) as CitySaleCount
from portfolioproject..nashvillehousing
group by propertysplitcity
order by count(propertysplitcity)

-- Table 2 - Average Sale Price by City

Select round(avg(Saleprice),0,0) as AverageSalePrice, PropertySplitCity, count(propertysplitcity) as CitySaleCount
from PortfolioProject..nashvillehousing
where saleprice is not null
	AND PROPERTYSPLITCITY  <> 'FRANKLIN' 
	AND PROPERTYSPLITCITY  <> 'BELLEVUE'
	AND PROPERTYSPLITCITY  <> 'UNKNOWN'
group by Propertysplitcity
order by 2


-- Table 3.0 - Average Lot Size by City

Select round(avg(Acreage),2,0) as AverageAcreage, PropertySplitCity, count(propertysplitcity) as CitySaleCount
from PortfolioProject..nashvillehousing
where acreage is not null
	AND PROPERTYSPLITCITY  <> 'NOLENSVILLE' 
	AND PROPERTYSPLITCITY  <> 'BELLEVUE'
	AND PROPERTYSPLITCITY  <> 'UNKNOWN'
group by Propertysplitcity
order by 2

-- Table 3.1 - Lot Sizes by City

Select Acreage, PropertySplitCity
from PortfolioProject..nashvillehousing
where acreage is not null
	AND PROPERTYSPLITCITY  <> 'NOLENSVILLE' 
	AND PROPERTYSPLITCITY  <> 'BELLEVUE'
	AND PROPERTYSPLITCITY  <> 'UNKNOWN'
group by acreage, Propertysplitcity
order by 2

-- Table 4 - Average Sale Price over time

Select round(avg(Saleprice),0,0) as AverageSalePrice, PropertySplitCity, SALEDATECONVERTED
from PortfolioProject..nashvillehousing
where SALEDATECONVERTED not like '%2019%'
group by Propertysplitcity, saledateconverted
ORDER BY 2, 3
