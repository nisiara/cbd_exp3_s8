SHOW USER;


-- CASO 2.1
-- Dado que en la plataforma anterior se detectó una cantidad de pagos mal calculados, 
-- se requiere construir un informe de pagos debido a que no se consideró en un inicio que los
-- consultorios atienden en forma regular solo hasta las 17:15 hrs. Por lo tanto, se requiere
-- construir un informe que aplique un reajuste a las consultas médicas de los CESFAMs
-- realizadas después de las 17:15 hrs. considerando la siguiente especificación:
-- Si el costo de atención está entre los 15 mil y 25 mil pesos, se le aplicará un 15% al monto a cancelar.
-- Si supera los 25 mil se le aplicará un 20%.
-- Cualquier otro costo, se mantendrá el costo actual.

SELECT 
      p.pac_run PAC_RUN
    , p.dv_run DV_RUN
    , INITCAP(s.descripcion) SIST_SALUD
    , INITCAP(p.apaterno || ' ' || pnombre) NOMBRE_PCIENTE 
    , bc.costo COSTO
    , NVL(
        CASE
            WHEN bc.costo BETWEEN 15000 AND 25000 THEN ROUND((bc.costo * 0.15), 0) + bc.costo
            WHEN bc.costo > 25000 THEN ROUND((bc.costo * 0.2), 0) + bc.costo
        END
    , bc.costo) MONTO_A_CANCELAR
    , ROUND((SYSDATE - p.fecha_nacimiento) / 365.25) EDAD

FROM syn_paciente p
    LEFT JOIN syn_salud s ON p.sal_id = s.sal_id
    INNER JOIN syn_bono bc ON p.pac_run = bc.pac_run
WHERE 
    TO_CHAR(bc.hr_consulta) > '17:15'
    
    -- FILTROS PARA IGUALAR LA CANTIDAD DE REGISTROS MOSTRADOS EN EL EJEMPLO
    AND s.sal_id IN (SELECT sal_id FROM syn_salud WHERE sal_id BETWEEN 10 AND 100 )
    AND ROUND((SYSDATE - p.fecha_nacimiento) / 365.25) >= 65
ORDER BY 
    PAC_RUN ASC
    , MONTO_A_CANCELAR ASC;
    
    
--CASO 2.2
-- Para optimizar el acceso a la información, la consulta que genera el informe se debe
-- almacenar en la base de datos, en el esquema PRY2205_USER2 mediante la creación del
-- objeto vista de lectura: V_RECALCULO_PAGOS.
-- Solo el usuario mencionado está autorizado a generar y consultar este informe, tal como se muestra en la Figura 1
-- La sentencia SQL debe acceder a las tablas a través de los sinónimos creados en el CASO 1.

CREATE VIEW V_RECALCULO_PAGOS AS 
    SELECT 
          p.pac_run PAC_RUN
        , p.dv_run DV_RUN
        , INITCAP(s.descripcion) SIST_SALUD
        , INITCAP(p.apaterno || ' ' || pnombre) NOMBRE_PCIENTE 
        , bc.costo COSTO
        , NVL(
            CASE
                WHEN bc.costo BETWEEN 15000 AND 25000 THEN ROUND((bc.costo * 0.15), 0) + bc.costo
                WHEN bc.costo > 25000 THEN ROUND((bc.costo * 0.2), 0) + bc.costo
            END
        , bc.costo) MONTO_A_CANCELAR
        , ROUND((SYSDATE - p.fecha_nacimiento) / 365.25) EDAD
    
    FROM syn_paciente p
        LEFT JOIN syn_salud s ON p.sal_id = s.sal_id
        INNER JOIN syn_bono bc ON p.pac_run = bc.pac_run
    WHERE 
        TO_CHAR(bc.hr_consulta) > '17:15'
        AND s.sal_id IN (SELECT sal_id FROM syn_salud WHERE sal_id BETWEEN 10 AND 100 )
        AND ROUND((SYSDATE - p.fecha_nacimiento) / 365.25) >= 65
    ORDER BY 
        PAC_RUN ASC
        , MONTO_A_CANCELAR ASC
WITH READ ONLY;
  
SELECT * FROM V_RECALCULO_PAGOS;
    