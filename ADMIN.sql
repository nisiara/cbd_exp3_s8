--Para la implementación, se debe considerar la eficiencia de crear sinónimos públicos y
--privados para los objetos: PAGOS Y PACIENTE.

--PRY2205_ROL_P
--Solamente poder crear procedimientos y funciones almacenadas
CREATE ROLE PRY2205_ROL_P;
GRANT CREATE PROCEDURE TO PRY2205_ROL_P;


-- PRY2205_ROL_D
-- Este rol deberá poder consultar información de las tablas del
-- usuario PRY2205_USER1: MEDICO Y CARGO, que son
-- necesarias para responder al requerimiento del CASO 2. Si
-- determinas que necesita accesos para algún otro objeto,
-- debes agregarlo.
-- PROFE: Para responder a los requerimientos del Caso 2, no es necesario tener acceso a las tablas Medico y Cargo.
-- sí a las tablas Bono_Consulta, Salud y Paciente. Para seguir el principio de menor privilegio, omití darle acceso a esas tablas
CREATE ROLE PRY2205_ROL_D;
GRANT SELECT ON PRY2205_USER1.PACIENTE TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_USER1.SALUD TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_USER1.BONO_CONSULTA TO PRY2205_ROL_D;


--CREAR USUARIO 1
CREATE USER PRY2205_USER1
IDENTIFIED BY "PRY2205.semana_8"
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER PRY2205_USER1 QUOTA UNLIMITED ON DATA;
GRANT CREATE SESSION TO PRY2205_USER1;

--PERMISOS
GRANT CREATE SYNONYM TO PRY2205_USER1;
GRANT CREATE PUBLIC SYNONYM TO PRY2205_USER1;

GRANT CREATE VIEW TO PRY2205_USER1;

--CREAR USUARIO 2
CREATE USER PRY2205_USER2
IDENTIFIED BY "PRY2205.semana_8"
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER PRY2205_USER2 QUOTA UNLIMITED ON DATA;
GRANT CREATE SESSION TO PRY2205_USER2;

-- OTORGAR ROL
GRANT PRY2205_ROL_D TO PRY2205_USER2;

--PERMISOS
GRANT CREATE VIEW TO PRY2205_USER2;


