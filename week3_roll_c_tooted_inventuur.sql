--anna mulle tooted, mida ei ole müüdud

select p.*
from products p
left join sales s on p.product_id = s.product_id
where s.product_id is null

--müümata tooted kokku
SELECT COUNT(*) AS müümata_tooteid    
FROM products p    
LEFT JOIN sales s ON p.product_id = s.product_id    
WHERE s.sale_id IS NULL; 

--enim müüdud
SELECT        
p.product_id,
p.product_name,        
p.category,        
p.subcategory,        
COUNT(s.sale_id) AS müüdud_kordi,        
SUM(s.total_price) AS kogumüük    
FROM products p    
INNER JOIN sales s ON p.product_id = s.product_id    
GROUP BY p.product_id, p.product_name, p.category, p.subcategory    
ORDER BY kogumüük DESC    
LIMIT 10;

--kategooria kaupa
SELECT        
p.category,        
COUNT(DISTINCT p.product_id) AS tooteid,        
COUNT(s.sale_id) AS müüke,        
SUM(s.total_price) AS kogumüük    
FROM products p    
LEFT JOIN sales s ON p.product_id = s.product_id    
GROUP BY p.category    
ORDER BY kogumüük DESC;

--inventory tabeliga ühendamine, mis tooted on laos?
SELECT        
p.product_name,        
p.category,        
i.location,        
i.quantity_available,        
i.reorder_point,        
CASE            
WHEN i.quantity_available <= i.reorder_point 
THEN 'TELLI JUURDE' ELSE 'OK' END AS staatus    
FROM products p    
LEFT JOIN inventory i ON p.product_id = i.product_id    
ORDER BY i.quantity_available ASC;    