/*
Cleaning data in SQL Queries
*/

Select *
From PortfolioProject..NashvilleHousing
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize data fortmat

UPDATE NashvilleHousing
SET SaleDate= CONVERT(Date,  SaleDate)

Select SaleDate, CONVERT(Date,  SaleDate)
From PortfolioProject..NashvilleHousing


--If it doesn't get updated

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,  SaleDate)

Select SaleDateConverted, CONVERT(Date,  SaleDate)
From PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID ,b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID=b.ParcelID 
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID=b.ParcelID 
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Breaking out address into individual columns(Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE NashvilleHousing
ADD OwneSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Change Y to Yes & N to No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE When SoldAsVacant='Y' Then 'Yes'
When SoldAsVacant='N' Then 'No'
Else SoldAsVacant
END
From PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant= CASE When SoldAsVacant='Y' Then 'Yes'
When SoldAsVacant='N' Then 'No'
Else SoldAsVacant
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(

Select *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference
Order By UniqueID) row_num

From PortfolioProject..NashvilleHousing)

Select *
From RowNumCTE
Where row_num>1
Order By PropertyAddress

/*
Delete 
From RowNumCTE
Where row_num>1
--Order By PropertyAddress
*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns


Select *
From PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate