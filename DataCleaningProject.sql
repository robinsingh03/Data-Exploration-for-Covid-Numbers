---Cleaning Data in SQL Queries

Select * from [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------

---Standardize Date Format

ALTER TABLE [Portfolio Project]..NashvilleHousing
Add SaleDateConverted Date;

Update [Portfolio Project]..NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

ALTER TABLE [Portfolio Project]..NashvilleHousing
Drop Column SaleDate;

-------------------------------------------------------------------------------------------

---Populate PropertyAddress Data

Select * from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is Null
order by ParcelID            --Every PropertyAddress is associated with unique ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a JOIN [Portfolio Project]..NashvilleHousing b 
on a.ParcelID = b.ParcelID
where a.[UniqueID ] != b.[UniqueID ]
and a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a JOIN [Portfolio Project]..NashvilleHousing b 
on a.ParcelID = b.ParcelID
where a.[UniqueID ] != b.[UniqueID ]
and a.PropertyAddress is Null

----------------------------------------------------------------------------------------------

---Breaking out Address into individual columns(Address, City, State)

Select PropertyAddress from [Portfolio Project]..NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Property_Address
from [Portfolio Project]..NashvilleHousing
 
Select SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Property_City
from [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD Property_Address Nvarchar(260);

Update [Portfolio Project]..NashvilleHousing
Set Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE [Portfolio Project]..NashvilleHousing
Add Property_City Nvarchar(260);

Update [Portfolio Project]..NashvilleHousing
Set Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

ALTER TABLE [Portfolio Project]..NashvilleHousing
Drop Column PropertyAddress

Select * from [Portfolio Project]..NashvilleHousing


Select OwnerAddress from [Portfolio Project]..NashvilleHousing
 
Select OwnerAddress, 
PARSENAME(Replace(OwnerAddress, ',', '.'), 3) as Owner_Address,
PARSENAME(Replace(OwnerAddress, ',', '.'), 2) as Owner_City,
PARSENAME(Replace(OwnerAddress, ',', '.'), 1) as Owner_State
from [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
Add Owner_Address Nvarchar(260);

ALTER TABLE [Portfolio Project]..NashvilleHousing
Add Owner_City Nvarchar(260);

ALTER TABLE [Portfolio Project]..NashvilleHousing
Add Owner_State Nvarchar(260);

Update [Portfolio Project]..NashvilleHousing
Set Owner_Address = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Update [Portfolio Project]..NashvilleHousing
Set Owner_City = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Update [Portfolio Project]..NashvilleHousing
Set Owner_State = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

Select * from [Portfolio Project]..NashvilleHousing

--------------------------------------------------------------------------------------------

---Change 'Y' and 'N' to 'Yes' and 'No' for 'SoldAsVacant' Field

Select Distinct SoldAsVacant, Count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from [Portfolio Project]..NashvilleHousing

Update [Portfolio Project]..NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
                        when SoldAsVacant = 'N' then 'No'
	                    else SoldAsVacant
	                    end

----------------------------------------------------------------------------------------------

---Removing Duplicates

With Row_Num_CTE as(
Select *, 
ROW_NUMBER() OVER(Partition by ParcelID, SalePrice, LegalReference, Property_Address, Property_City, SaleDateConverted
                  Order by UniqueID) as Row_Num
from [Portfolio Project]..NashvilleHousing
)
Select * from Row_Num_CTE
where Row_Num > 1


With Row_Num_CTE as(
Select *, 
ROW_NUMBER() OVER(Partition by ParcelID, SalePrice, LegalReference, Property_Address, Property_City, SaleDateConverted
                  Order by UniqueID) as Row_Num
from [Portfolio Project]..NashvilleHousing
)
Delete from Row_Num_CTE
where Row_Num > 1


                        