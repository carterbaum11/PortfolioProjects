select *
from PortfolioProject..NashvilleHousing

-- Standardize SaleDate Format

Select SaleDate, CONVERT(date,saledate)
From PortfolioProject..NashvilleHousing

Alter Table nashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date,saledate)

select saledate, saledateconverted
from PortfolioProject..NashvilleHousing

--Populate Null Property Address Data

select *, PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
Set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-- Breaking Out Property Address into Individual Columns (address, city, state)

select PropertyAddress
from PortfolioProject..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+2, Len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

Alter Table nashvillehousing
add propertysplitaddress nvarchar(255);

update NashvilleHousing
set propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)-1)

Alter Table nashvillehousing
add propertysplitcity nvarchar(255);

update NashvilleHousing
set PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+2, Len(PropertyAddress))


-- Breaking Out Owner Address into Individual Columns (address, city, state)

Select Owneraddress
from portfolioproject..NashvilleHousing

select 
PARSENAME(replace(owneraddress, ',', '.'), 1)
,PARSENAME(replace(owneraddress, ',', '.'), 2)
,PARSENAME(replace(owneraddress, ',', '.'), 3)
from PortfolioProject..NashvilleHousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255);

alter table nashvillehousing
add ownersplitcity nvarchar(255);

alter table nashvillehousing
add ownersplitstate nvarchar(255);

update NashvilleHousing
set ownersplitaddress = PARSENAME(replace(owneraddress, ',', '.'), 3)

update NashvilleHousing
set ownersplitcity = PARSENAME(replace(owneraddress, ',', '.'), 2)

update NashvilleHousing
set ownersplitstate = PARSENAME(replace(owneraddress, ',', '.'), 1)


-- Change Y and N in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case	when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = Case	when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from PortfolioProject..NashvilleHousing

--Remove Duplicates

With RowNumCTE AS(
Select *,
	Row_number() over(
	partition by	ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by
						UniqueID
						) row_num

from portfolioproject..nashvillehousing
)

Delete
from rownumCTE
where row_num >1


--Delete Unused Column

Alter Table portfolioproject..nashvillehousing
drop column owneraddress,taxdistrict, propertyaddress

Alter Table portfolioproject..nashvillehousing
drop column saledate
