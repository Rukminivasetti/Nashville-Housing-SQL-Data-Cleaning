select * from dbo.NashvilleHousingDataCleaning;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousingDataCleaning'
ORDER BY ORDINAL_POSITION;

SELECT TOP 20
    SaleDate
FROM dbo.NashvilleHousingDataCleaning
ORDER BY SaleDate;

SELECT COUNT(*) AS MissingPropertyAddress
FROM dbo.NashvilleHousingDataCleaning
WHERE PropertyAddress IS NULL;

SELECT
    a.UniqueID,
    a.ParcelID,
    a.PropertyAddress,
    b.PropertyAddress AS MatchingAddress
FROM dbo.NashvilleHousingDataCleaning a
JOIN dbo.NashvilleHousingDataCleaning b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
  AND b.PropertyAddress IS NOT NULL;

  UPDATE a
SET PropertyAddress = b.PropertyAddress
FROM dbo.NashvilleHousingDataCleaning a
JOIN dbo.NashvilleHousingDataCleaning b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
  AND b.PropertyAddress IS NOT NULL;

  SELECT COUNT(*) AS RemainingMissingAddresses
FROM dbo.NashvilleHousingDataCleaning
WHERE PropertyAddress IS NULL;

ALTER TABLE dbo.NashvilleHousingDataCleaning
ADD PropertySplitAddress NVARCHAR(255);

ALTER TABLE dbo.NashvilleHousingDataCleaning
ADD PropertySplitCity NVARCHAR(255);

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousingDataCleaning'
ORDER BY ORDINAL_POSITION;

UPDATE dbo.NashvilleHousingDataCleaning
SET PropertySplitAddress =
    LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1);

    UPDATE dbo.NashvilleHousingDataCleaning
SET PropertySplitCity =
    LTRIM(RTRIM(
        SUBSTRING(
            PropertyAddress,
            CHARINDEX(',', PropertyAddress) + 1,
            LEN(PropertyAddress)
        )
    ));

    SELECT TOP 20
    PropertyAddress,
    PropertySplitAddress,
    PropertySplitCity
FROM dbo.NashvilleHousingDataCleaning;

ALTER TABLE dbo.NashvilleHousingDataCleaning
ADD OwnerSplitAddress NVARCHAR(255);

ALTER TABLE dbo.NashvilleHousingDataCleaning
ADD OwnerSplitCity NVARCHAR(255);

ALTER TABLE dbo.NashvilleHousingDataCleaning
ADD OwnerSplitState NVARCHAR(50);

UPDATE dbo.NashvilleHousingDataCleaning
SET OwnerSplitAddress =
    LTRIM(RTRIM(
        LEFT(
            OwnerAddress,
            CHARINDEX(',', OwnerAddress) - 1
        )
    ))
WHERE OwnerAddress IS NOT NULL
  AND CHARINDEX(',', OwnerAddress) > 0;

  UPDATE dbo.NashvilleHousingDataCleaning
SET OwnerSplitCity =
    LTRIM(RTRIM(
        SUBSTRING(
            OwnerAddress,
            CHARINDEX(',', OwnerAddress) + 1,
            CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1)
            - CHARINDEX(',', OwnerAddress) - 1
        )
    ))
WHERE OwnerAddress IS NOT NULL
  AND CHARINDEX(',', OwnerAddress) > 0;

  UPDATE dbo.NashvilleHousingDataCleaning
SET OwnerSplitState =
    LTRIM(RTRIM(
        RIGHT(
            OwnerAddress,
            LEN(OwnerAddress) -
            CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1)
        )
    ))
WHERE OwnerAddress IS NOT NULL
  AND CHARINDEX(',', OwnerAddress) > 0;

  SELECT TOP 20
    OwnerAddress,
    OwnerSplitAddress,
    OwnerSplitCity,
    OwnerSplitState
FROM dbo.NashvilleHousingDataCleaning
WHERE OwnerAddress IS NOT NULL;

SELECT
    SoldAsVacant,
    COUNT(*) AS NumberOfRows
FROM dbo.NashvilleHousingDataCleaning
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant;

WITH DuplicateRows AS
(
    SELECT
        UniqueID,
        ParcelID,
        PropertyAddress,
        SalePrice,
        SaleDate,
        LegalReference,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS RowNum
    FROM dbo.NashvilleHousingDataCleaning
)
SELECT *
FROM DuplicateRows
WHERE RowNum > 1
ORDER BY ParcelID;

WITH DuplicateRows AS
(
    SELECT
        UniqueID,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS RowNum
    FROM dbo.NashvilleHousingDataCleaning
)
DELETE FROM DuplicateRows
WHERE RowNum > 1;

SELECT COUNT(*) AS TotalRows
FROM dbo.NashvilleHousingDataCleaning;

WITH DuplicateRows AS
(
    SELECT
        UniqueID,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS RowNum
    FROM dbo.NashvilleHousingDataCleaning
)
SELECT COUNT(*) AS RemainingDuplicates
FROM DuplicateRows
WHERE RowNum > 1;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(UniqueID) AS UniqueID_NotNull,
    COUNT(ParcelID) AS ParcelID_NotNull,
    COUNT(LandUse) AS LandUse_NotNull,
    COUNT(PropertyAddress) AS PropertyAddress_NotNull,
    COUNT(SaleDate) AS SaleDate_NotNull,
    COUNT(SalePrice) AS SalePrice_NotNull,
    COUNT(LegalReference) AS LegalReference_NotNull,
    COUNT(SoldAsVacant) AS SoldAsVacant_NotNull,
    COUNT(OwnerName) AS OwnerName_NotNull,
    COUNT(OwnerAddress) AS OwnerAddress_NotNull,
    COUNT(Acreage) AS Acreage_NotNull,
    COUNT(TaxDistrict) AS TaxDistrict_NotNull,
    COUNT(LandValue) AS LandValue_NotNull,
    COUNT(BuildingValue) AS BuildingValue_NotNull,
    COUNT(TotalValue) AS TotalValue_NotNull,
    COUNT(YearBuilt) AS YearBuilt_NotNull,
    COUNT(Bedrooms) AS Bedrooms_NotNull,
    COUNT(FullBath) AS FullBath_NotNull,
    COUNT(HalfBath) AS HalfBath_NotNull
FROM dbo.NashvilleHousingDataCleaning;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(PropertySplitAddress) AS PropertySplitAddress_NotNull,
    COUNT(PropertySplitCity) AS PropertySplitCity_NotNull,
    COUNT(OwnerSplitAddress) AS OwnerSplitAddress_NotNull,
    COUNT(OwnerSplitCity) AS OwnerSplitCity_NotNull,
    COUNT(OwnerSplitState) AS OwnerSplitState_NotNull
FROM dbo.NashvilleHousingDataCleaning;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousingDataCleaning'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(PropertyAddress) AS PropertyAddress,
    COUNT(PropertySplitAddress) AS PropertySplitAddress,
    COUNT(PropertySplitCity) AS PropertySplitCity,
    COUNT(OwnerAddress) AS OwnerAddress,
    COUNT(OwnerSplitAddress) AS OwnerSplitAddress,
    COUNT(OwnerSplitCity) AS OwnerSplitCity,
    COUNT(OwnerSplitState) AS OwnerSplitState
FROM dbo.NashvilleHousingDataCleaning;

ALTER TABLE dbo.NashvilleHousingDataCleaning
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousingDataCleaning'
ORDER BY ORDINAL_POSITION;

SELECT
    SoldAsVacant,
    COUNT(*) AS NumberOfRows
FROM dbo.NashvilleHousingDataCleaning
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant;

