--cleaning data 
--modifying the date column 

select * from housing

select saledate,convert(date,saledate)
from housing 

alter table housing 
add saledateconverted date;

update housing 
set saledateconverted = convert(date,saledate)

select *
from housing

--property address data 

select * from housing
order by ParcelID

--using self join 

select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,isnull(a.propertyaddress,b.propertyaddress) from housing a
join housing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from housing a
join housing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- breaking down the city and state from address 
select PropertyAddress from housing 


select SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress, charindex(',',propertyaddress) +1,len(propertyaddress))

from housing

alter table housing 
add city nvarchar(255)

update housing 
set city = SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress)-1)

alter table housing 
add state nvarchar(255)

update housing 
set state = SUBSTRING(propertyaddress, charindex(',',propertyaddress) +1,len(propertyaddress))

select * from housing 


-- owner address 
--using parse name 

select parsename(replace(owneraddress, ',','.'), 3)
,parsename(replace(owneraddress, ',','.'), 2)
,parsename(replace(owneraddress, ',','.'), 1)
from housing

alter table housing 
add owner_address nvarchar(255)

update housing 
set owner_address = parsename(replace(owneraddress, ',','.'), 3)


alter table housing 
add owner_city nvarchar(255)


update housing 
set owner_city = parsename(replace(owneraddress, ',','.'), 2)


alter table housing 
add owner_state nvarchar(255)


update housing 
set owner_state = parsename(replace(owneraddress, ',','.'), 1)

select * from housing;


-- changing N and Y to yes and no in soldasvacant

select distinct soldasvacant,count(soldasvacant) from housing
group by SoldAsVacant
order by 2


select soldasvacant, case when soldasvacant ='Y'then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant 
end 
from housing 


update housing 
set SoldAsVacant = case when soldasvacant ='Y'then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant 
end



--remove duplicates 

-- using CTE and windows function 


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

From housing
--order by ParcelID
)
delete 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


-- deleting unused columns 


ALTER TABLE housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


select * from housing