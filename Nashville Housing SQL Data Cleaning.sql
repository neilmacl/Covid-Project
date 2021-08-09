--SQL Skills: Paritioning columns, Joins, Updating tables, 

-- Standardize Date
Select SaleDate, CONVERT(date, saledate)
From Housing..NashvilleHousing

update NashvilleHousing 
SET SaleDate = CONVERT(date, saledate)

select saledate
from Housing..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;
update NashvilleHousing 
SET SaleDateConverted = CONVERT(date, saledate)

Select saledateconverted
from Housing..NashvilleHousing

--Populate Property Address

Select a.ParcelID, a.PropertyAddress, a.UniqueID, b.ParcelID, b.PropertyAddress, b.UniqueID, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Housing..NashvilleHousing a
JOIN Housing..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] 

UPDATE a
SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
FROM Housing..NashvilleHousing a
JOIN Housing..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

Select *
FROM housing..NashvilleHousing
WHERE PropertyAddress is null

-- Breaking out address in individul columns (address, city, state)
--Property Address
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, 20) AS City, 
PropertyAddress
FROM Housing..NashvilleHousing

ALTER TABLE Housing..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE Housing..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Housing..NashvilleHousing
ADD PropertyCity Nvarchar(255);

UPDATE Housing..NashvilleHousing
SET PropertyCity = SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress)+2, 20)

Select PropertyAddress, PropertySplitaddress, Propertycity
FROM Housing..NashvilleHousing

--Spliting OwnerAddress into seperate columns for state, city, and street address
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Housing..NashvilleHousing

ALTER TABLE Housing..NashvilleHousing
ADD OwnerState Nvarchar(255);

UPDATE Housing..NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

ALTER TABLE Housing..NashvilleHousing
ADD OwnerCity Nvarchar(255);

UPDATE Housing..NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Housing..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE Housing..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Select ownersplitaddress, ownercity, ownerstate
FROM Housing..NashvilleHousing

--Change Y and N to Yes and No in SoldAsVacant

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
       WHEN SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
FROM Housing..NashvilleHousing

UPDATE Housing..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
						WHEN SoldAsVacant = 'N' Then 'No'
						ELSE SoldAsVacant
						END
Select DISTINCT(SoldAsVacant)
FROM Housing..NashvilleHousing

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num				
FROM housing..NashvilleHousing
)
DELETE
FROM RowNumCte
WHERE row_num > 1