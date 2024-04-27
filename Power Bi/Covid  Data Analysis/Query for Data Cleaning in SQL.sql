/*

Cleaning Data in SQL Queries

*/

select * from PortfolioProject..NashVilleHousing

-- Standardize Date Format

select SaleDate2 , CONVERT(date,SaleDate) 
from PortfolioProject..NashVilleHousing

update NashVilleHousing
set SaleDate = CONVERT(date,SaleDate)

Alter Table NashVilleHousing
ADD SaleDate2 date;

update NashVilleHousing
SET SaleDate2 = CONVERT(date , SaleDate);


--Populate Propery Address Data

select *
from PortfolioProject..NashVilleHousing
--where PropertyAddress is NULL
order by ParcelID


select a.ParcelID,a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashVilleHousing a
join PortfolioProject..NashVilleHousing b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashVilleHousing a
join PortfolioProject..NashVilleHousing b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


-- Breaking out Address in Individual Columns (Address , City , State)

select PropertyAddress
from PortfolioProject..NashVilleHousing

select 
SUBSTRING(PropertyAddress , 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as  City
from PortfolioProject..NashVilleHousing

Alter Table NashVilleHousing
ADD PropertSplitAddress nvarchar(255);

update NashVilleHousing
SET PropertSplitAddress = SUBSTRING(PropertyAddress , 1, CHARINDEX(',',PropertyAddress) -1);

Alter Table NashVilleHousing
ADD PropertSplitCity nvarchar(255);

update NashVilleHousing
SET PropertSplitCity = SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress));

select * from PortfolioProject..NashVilleHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
from PortfolioProject..NashVilleHousing


Alter Table NashVilleHousing
ADD OwnerSplitAddress nvarchar(255);

update NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

Alter Table NashVilleHousing
ADD OwnerSplitCity nvarchar(255);

update NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

Alter Table NashVilleHousing
ADD OwnerSplitState nvarchar(255);

update NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

--Change Y and N to Yes and No in "SoldAsVacant" field

select DISTINCT(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject..NashVilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
from PortfolioProject..NashVilleHousing

update NashVilleHousing
set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End


--Remove Duplicates

with RowNum As (
select *,
ROW_NUMBER() over(
Partition by ParcelID,
				LandUse,
				PropertyAddress,
				SaleDate,
				SalePrice,
				LegalReference
				order by
				UniqueID
				) row_num
from PortfolioProject..NashVilleHousing
--order by ParcelID
)
Delete
from RowNum
where row_num > 1
--order by PropertyAddress


--Delete unuseed Columns

select * 
from PortfolioProject..NashVilleHousing

Alter table PortfolioProject..NashVilleHousing
drop column SaleDate , PropertyAddress,TaxDistrict,OwnerAddress


