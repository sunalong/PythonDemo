SELECT
	seller_type_id sellerTypeId,
	seller_id sellerId,
	seller_name sellerName,
	department_code regionId,
	department_name regionName,
	city_name cityName,
	city_code cityCode,
	city_id cityId,
dim_shop_id shopId,
shop_name shopName
FROM
	dim.dim_shop
WHERE
	city_code IS NOT NULL
AND open_date IS NOT NULL
and status='1' 
and department_code is not null
and seller_type_id is not null