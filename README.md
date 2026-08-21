# Análisis Exploratorio de Ventas y Comportamiento de Clientes — DataCorp

## 1. Contexto del Problema de Negocio
DataCorp requiere identificar cuáles son sus clientes clave, evaluar la rotación del inventario y medir la tendencia mensual de sus ingresos. Para ello, se analizó el histórico de transacciones integrando la información de clientes, catálogo de productos y registros de compras.

El objetivo general es transformar datos transaccionales dispersos en métricas accionables para las áreas de Marketing, Operaciones y Dirección Financiera.

---

## 2. Hallazgos Principales y Conclusiones

* **Concentración de Ingresos (Clientes VIP):**  
  El cliente **Ana Gómez** encabeza el volumen de compra con un gasto acumulado superior a $2,800.00. El 20% de la base de clientes genera más del 60% de los ingresos totales, lo que sugiere implementar un programa de fidelización exclusivo para este segmento.

* **Tendencia Mensual de Ventas:**  
  Se observa un crecimiento sostenido en la facturación entre los meses de enero y marzo. Sin embargo, el ticket medio por pedido bajó en el último periodo debido a un mayor volumen de compra en productos de menor valor (accesorios).

* **Gestión de Inventario (Baja Rotación):**  
  Productos como **Lámpara de Escritorio** y **Mouse Inalámbrico** representan la menor rotación dentro del catálogo. Se recomienda evaluar promociones cruzadas (*cross-selling*) junto con artículos de alta demanda como la **Laptop Pro 15**.

* **Rendimiento por Categoría:**  
  La categoría **Electrónica** genera el mayor margen financiero por transacción. Los pedidos de mayor valor en esta categoría están impulsados principalmente por compras corporativas de equipamiento.

---

## 3. Estructura del Repositorio

* `estructura.sql`: Scripts DDL para la creación de tablas (`clientes`, `productos`, `pedidos`), restricciones de integridad de datos y la carga inicial de registros.
* `analisis.sql`: Consultas DML que incluyen la vista de limpieza con `COALESCE`, agrupaciones (`GROUP BY`), funciones de fecha (`TO_CHAR`) y ranking por ventanas (`RANK()`).
* `README.md`: Documento ejecutivo con el contexto, hallazgos e instrucciones de ejecución.

---

## 4. Instrucciones para Ejecutar el Código

1. Abrir **pgAdmin** o la CLI de **PostgreSQL**.
2. Crear la base de datos de trabajo:
   ```sql
   CREATE DATABASE capstone_project;
