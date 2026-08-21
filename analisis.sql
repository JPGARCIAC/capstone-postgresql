-- =============================================================================
-- PROYECTO CAPSTONE: Consultas de Análisis Exploratorio (EDA)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ETAPA 1: LIMPIEZA Y TRANSFORMACIÓN PREVIA DE DATOS
-- -----------------------------------------------------------------------------

-- Usamos COALESCE para asegurar que ningún cálculo de negocio omita pedidos 
-- donde el monto_total vino nulo de origen, calculándolo dinámicamente con el precio.
CREATE OR REPLACE VIEW vista_pedidos_limpios AS
SELECT 
    p.pedido_id,
    p.cliente_id,
    p.producto_id,
    p.cantidad,
    p.fecha_pedido,
    COALESCE(p.monto_total, p.cantidad * pr.precio) AS monto_calculado
FROM pedidos p
JOIN productos pr ON p.producto_id = pr.producto_id;


-- -----------------------------------------------------------------------------
-- ETAPA 2: PREGUNTAS DE NEGOCIO Y ANÁLISIS
-- -----------------------------------------------------------------------------

-- Consulta 1: Top 5 clientes por gasto total
-- Razón de negocio: Identificar el segmento VIP para aplicar estrategias de retención.
SELECT 
    c.cliente_id,
    c.nombre,
    c.ciudad,
    SUM(v.monto_calculado) AS gasto_total,
    COUNT(v.pedido_id) AS total_pedidos
FROM clientes c
JOIN vista_pedidos_limpios v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nombre, c.ciudad
ORDER BY gasto_total DESC
LIMIT 5;


-- Consulta 2: Ventas totales y volumen por mes
-- Razón de negocio: Evaluar la tendencia de ingresos mensuales para ajustar proyecciones.
SELECT 
    TO_CHAR(v.fecha_pedido, 'YYYY-MM') AS mes,
    COUNT(DISTINCT v.pedido_id) AS cantidad_pedidos,
    SUM(v.monto_calculado) AS ingresos_totales
FROM vista_pedidos_limpios v
GROUP BY TO_CHAR(v.fecha_pedido, 'YYYY-MM')
ORDER BY mes ASC;


-- Consulta 3: Productos menos vendidos (en unidades)
-- Razón de negocio: Identificar inventario de baja rotación para posibles liquidaciones.
SELECT 
    pr.producto_id,
    pr.nombre_producto,
    pr.categoria,
    COALESCE(SUM(v.cantidad), 0) AS unidades_vendidas
FROM productos pr
LEFT JOIN vista_pedidos_limpios v ON pr.producto_id = v.producto_id
GROUP BY pr.producto_id, pr.nombre_producto, pr.categoria
ORDER BY unidades_vendidas ASC
LIMIT 3;


-- Consulta 4: Ranking de pedidos por categoría utilizando Window Functions (RANK)
-- Razón de negocio: Determinar las transacciones de mayor valor dentro de cada categoría.
WITH pedidos_categorizados AS (
    SELECT 
        pr.categoria,
        pr.nombre_producto,
        v.pedido_id,
        v.monto_calculado,
        RANK() OVER (
            PARTITION BY pr.categoria 
            ORDER BY v.monto_calculado DESC
        ) AS rank_categoria
    FROM vista_pedidos_limpios v
    JOIN productos pr ON v.producto_id = pr.producto_id
)
SELECT 
    categoria,
    rank_categoria,
    nombre_producto,
    pedido_id,
    monto_calculado
FROM pedidos_categorizados
WHERE rank_categoria <= 3
ORDER BY categoria, rank_categoria;
