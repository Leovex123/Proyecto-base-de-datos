CREATE OR ALTER PROC [SQM_CATALOGS].[USP_Status]
(
    @i_statusId INT = NULL,
    @i_statusName VARCHAR(80) = NULL,
    @i_statusCreationDate DATETIME = NULL,
    @i_statusCreatorId INT = NULL,
    @i_statusModificationDate DATETIME = NULL,
    @i_statusModificatorId INT = NULL,
    @i_statusEnable BIT = NULL,
    @i_PageNumber INT = NULL,
    @i_RowsPerPage INT = NULL,
    @w_Accion CHAR(1),
    @o_Numero INT = NULL OUT,
    @o_MensajeTecnico VARCHAR(500) = NULL OUT,
    @o_MensajeUsuario VARCHAR(500) = NULL OUT
)
AS
BEGIN
    DECLARE @w_totalRows INT;

    IF @i_statusCreationDate IS NULL
        SET @i_statusCreationDate = GETDATE();

    IF @i_statusModificationDate IS NULL
        SET @i_statusModificationDate = GETDATE();

    -- INSERTAR STATUS --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_statusName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL STATUS ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_statusCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_STATUS;
            BEGIN TRY
                INSERT INTO [SQM_CATALOGS].[TBL_Status]
                (
                    statusName, 
                    statusCreationDate, 
                    statusCreatorId, 
                    statusModificationDate, 
                    statusModificatorId, 
                    statusEnable
                )
                VALUES
                (
                    @i_statusName, 
                    @i_statusCreationDate, 
                    @i_statusCreatorId, 
                    @i_statusModificationDate, 
                    @i_statusModificatorId, 
                    1
                );

                COMMIT TRANSACTION TRX_INS_STATUS;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'STATUS REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_STATUS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR STATUS';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR STATUS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE STATUS --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_statusId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL STATUS ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_statusModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] (NOLOCK) WHERE statusId = @i_statusId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL STATUS NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_STATUS;
            BEGIN TRY
                UPDATE [SQM_CATALOGS].[TBL_Status]
                SET statusName = COALESCE(@i_statusName, statusName),
                    statusModificationDate = @i_statusModificationDate,
                    statusModificatorId = @i_statusModificatorId,
                    statusEnable = COALESCE(@i_statusEnable, statusEnable)
                WHERE statusId = @i_statusId;

                COMMIT TRANSACTION TRX_UPD_STATUS;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'STATUS ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_STATUS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR STATUS';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR STATUS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT STATUS --
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF ISNULL(@i_PageNumber, 0) <= 0 OR ISNULL(@i_RowsPerPage, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS PARAMETROS DE PAGINACION SON OBLIGATORIOS Y DEBEN SER MAYORES A CERO';
        END
        ELSE
        BEGIN
            BEGIN TRY
                SELECT 
                    statusId,
                    statusName,
                    statusCreationDate,
                    statusCreatorId,
                    statusModificationDate,
                    statusModificatorId,
                    statusEnable
                FROM [SQM_CATALOGS].[TBL_Status] (NOLOCK)
                ORDER BY statusId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'STATUS LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR STATUS';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR STATUS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- ACCION INVALIDA --
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico = 'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';
    END
END;
GO