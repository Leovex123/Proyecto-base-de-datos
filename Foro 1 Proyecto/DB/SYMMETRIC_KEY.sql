USE [DB_SCRUM_PLANNING]
GO
--------------------------------------
/* ENCRIPTADO CON LLAVE SIMETRICA   */
--------------------------------------

--------------------------------------
/* CLAVE MAESTRA DE BASE DE DATOS   */
--------------------------------------
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SCRUM_PLANNING2026!';
END

--------------------------------------
/* CERTIFICADO DE ENCRIPTION        */
--------------------------------------
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'CERT_SCRUMPLANNING')
BEGIN
    CREATE CERTIFICATE CERT_SCRUMPLANNING
    WITH SUBJECT = 'Certificado de protección para la clave simétrica';
END

--------------------------------------
/* CLAVE SIMETRICA                  */
--------------------------------------
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'KEY_HASH')
BEGIN
    CREATE SYMMETRIC KEY KEY_HASH
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE CERT_SCRUMPLANNING;
END