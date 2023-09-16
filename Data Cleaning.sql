select * from 
portfolioproject..Nashvillehousing

--converting the datetime format in date from datetime to date only
Alter table Nashvillehousing
Add saledateconverted date

Update Nashvillehousing
SET saledateconverted= convert(date,saledate)

Select saledateconverted from 
Nashvillehousing





-- Populate property address data
select * from
Nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress--, ISNULL(a.propertyaddress,b.PropertyAddress)
from portfolioproject..Nashvillehousing a
join portfolioproject..Nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

UPDATE a
SET a.propertyaddress=ISNULL(a.propertyaddress,b.propertyaddress)
from portfolioproject..Nashvillehousing a
join portfolioproject..Nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null





-- Breaking propertyaddress into address,city,state
Select propertyaddress 
from portfolioproject..Nashvillehousing
order by ParcelID

select 
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address
,substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as city
from portfolioproject..Nashvillehousing

ALTER table Nashvillehousing
add propertysplitaddress nvarchar(255)

UPDATE Nashvillehousing
SET propertysplitaddress= substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

ALTER table Nashvillehousing
add propertysplitcity nvarchar(255)

UPDATE Nashvillehousing
SET propertysplitcity= substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

Select propertyaddress,propertysplitaddress,propertysplitcity
from Nashvillehousing






--breaking the owner address
select owneraddress 
from portfolioproject..Nashvillehousing

Select 
PARSENAME(REPLACE(owneraddress,',','.'),3) as ownersplitaddress,
PARSENAME(REPLACE(Owneraddress,',','.'),2)as ownersplitcity,
PARSENAME(REPLACE(owneraddress,',','.'),1) as ownersplitstate
from portfolioproject..Nashvillehousing 

Alter table Nashvillehousing
add ownersplitaddress nvarchar(255)

update Nashvillehousing
SET ownersplitaddress = PARSENAME(REPLACE(owneraddress,',','.'),3)

Alter table Nashvillehousing
add ownersplitcity nvarchar(255)

update Nashvillehousing
SET ownersplitcity = PARSENAME(REPLACE(owneraddress,',','.'),2)

Alter table Nashvillehousing
add ownersplitstate nvarchar(255)

update Nashvillehousing
SET ownersplitstate = PARSENAME(REPLACE(owneraddress,',','.'),1)


Select owneraddress,ownersplitaddress,ownersplitcity,ownersplitstate
from portfolioproject..Nashvillehousing






--change y and n to yes and no in sold as vacant column
Select distinct(soldasvacant),count(soldasvacant)
from portfolioproject..Nashvillehousing
group by SoldAsVacant
order by 2

Select soldasvacant,
CASE when soldasvacant='Y' THEN 'Yes'
     When soldasvacant='N' THEN 'No'
	 ELSE soldasvacant
	 END
From portfolioproject..nashvillehousing

UPDATE Nashvillehousing
SET SoldAsVacant= CASE when soldasvacant='Y' THEN 'Yes'
     When soldasvacant='N' THEN 'No'
	 ELSE soldasvacant
	 END





--removing duplicates
WITH rownumberCTE AS(
select *,row_number() 
		OVER(
		PARTITION BY
		parcelid,
		propertyaddress,
		saledate,
		saleprice,
		legalreference
		ORDER BY 
		uniqueid
		)
			as row_number
From portfolioproject..Nashvillehousing)

select * FROM rownumberCTE
where row_number>1







-- deleting the unwanted columns
select * from
portfolioproject..Nashvillehousing


Alter table portfolioproject.dbo.nashvillehousing
drop column propertyaddress,saledate,owneraddress,taxdistrict


 




