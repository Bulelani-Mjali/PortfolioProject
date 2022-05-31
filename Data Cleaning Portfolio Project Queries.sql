
/* Cleaning Data in SQL Queries */

Select *
From PotfolioProject.dbo.nashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format
-- 1 Add SaleDateConverted Colum
-- 2 Convert SaleDate format
-- 2 Drop Sale Date Colum unused 

ALTER TABLE PotfolioProject.dbo.nashvilleHousing
Add SaleDateConverted Date;

Update PotfolioProject.dbo.nashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate);

ALTER TABLE PotfolioProject.dbo.nashvilleHousing
DROP COLUMN SaleDate;

 --------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PotfolioProject.dbo.nashvilleHousing;

ALTER TABLE PotfolioProject.dbo.nashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PotfolioProject.dbo.nashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

ALTER TABLE PotfolioProject.dbo.nashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PotfolioProject.dbo.nashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

Select *
From PotfolioProject.dbo.nashvilleHousing;

ALTER TABLE PotfolioProject.dbo.nashvilleHousing
DROP COLUMN PropertyAddress;

Select *
From PotfolioProject.dbo.nashvilleHousing;


--------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PotfolioProject.dbo.nashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Select *
From PotfolioProject.dbo.nashvilleHousing;

---------------------------------------------------------------------------------------------------------
