
Select * from Nashville_housing_tab

--Standardize Data format
Select SaleDateconverted, CONVERT(date,saledate) from Nashville_housing_tab

Update Nashville_housing_tab
set saledate = CONVERT(date,saledate)

Alter table nashville_housing_tab
Add SaleDateConverted Date

Update Nashville_housing_tab
set saledateconverted = CONVERT(date, saledate)

--Populate property address
Select * from Nashville_housing_tab
--where propertyaddress is NULL
order by parcelId

Select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville_housing_tab a
join Nashville_housing_tab b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville_housing_tab a
join Nashville_housing_tab b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

--Breaking out Property address into indiviidual columns
Select propertyaddress from Nashville_housing_tab

Select SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as address
from Nashville_housing_tab

Alter table nashville_housing_tab
add propersplitaddress varchar(225)

Alter table nashville_housing_tab
add propersplitcity varchar(225)

Update Nashville_housing_tab
set propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1)

Update Nashville_housing_tab
set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

Select * from Nashville_housing_tab

--Breaking out Owner address into indiviidual columns

Select OwnerAddress from Nashville_housing_tab

Select PARSENAME(replace(Owneraddress,',','.'),3),
PARSENAME(replace(Owneraddress,',','.'),2),
PARSENAME(replace(Owneraddress,',','.'),1)
from Nashville_housing_tab

Alter table nashville_housing_tab
add ownersplitaddress varchar(225)

Update Nashville_housing_tab
set ownersplitaddress = PARSENAME(replace(Owneraddress,',','.'),3)

Alter table nashville_housing_tab
add ownersplitcity varchar(225)

Update Nashville_housing_tab
set ownersplitcity = PARSENAME(replace(Owneraddress,',','.'),2)

Alter table nashville_housing_tab
add ownersplitstate varchar(225)

Update Nashville_housing_tab
set ownersplitstate = PARSENAME(replace(Owneraddress,',','.'),1)

Select * from Nashville_housing_tab

--Change Y as Yes and N as No in Sold as vacant
Select distinct(soldasvacant), COUNT(soldasvacant) from Nashville_housing_tab
group by SoldAsVacant


Select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
from nashville_housing_tab

Update Nashville_housing_tab
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end



--Remove duplicates

with rownumCTE as(
Select *,
ROW_NUMBER() over(
partition by parcelID, propertyaddress, saleprice,saledate,legalreference
order by uniqueid) rownum
from Nashville_housing_tab
--order by  ParcelID
)
Select * from rownumCTE
where rownum>1
order by PropertyAddress

--Delete from rownumCTE
--where rownum>1


--Delete unused columns

Select * from Nashville_housing_tab
Alter table nashville_housing_tab
Drop column owneraddress, taxdistrict, propertyaddress

Alter table nashville_housing_tab
Drop column saledate