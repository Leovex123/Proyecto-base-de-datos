CREATE OR ALTER PROC [SQM_CATALOGS].[USP_Priorities]
(
    @i_priorityId INT = NULL,
    @i_priorityName VARCHAR(80) = NULL,
    @i_priorityCreationDate DATETIME = NULL,
    @i_priorityCreatorId INT = NULL,
    @i_priorityModificationDate DATETIME = NULL,
    @i_priorityModificatorId INT = NULL,
    @i_priorityEnable BIT = NULL,
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

    IF @i_priorityCreationDate IS NULL
        SET @i_priorityCreationDate = GETDATE();

    IF @i_priorityModificationDate IS NULL
        SET @i_priorityModificationDate = GETDATE();

    -- INSERTAR PRIORIDAD --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_priorityName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DE LA PRIORIDAD ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_priorityCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_PRIORITIES;
            BEGIN TRY
                INSERT INTO [SQM_CATALOGS].[TBL_Priorities]
                (priorityName, priorityCreationDate, priorityCreatorId, priorityEnable)
                VALUES(@i_priorityName, @i_priorityCreationDate, @i_priorityCreatorId, 1);

                COMMIT TRANSACTION TRX_INS_PRIORITIES;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'PRIORIDAD REGISTRADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_PRIORITIES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR PRIORIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR PRIORIDAD', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE PRIORIDAD --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_priorityId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA PRIORIDAD ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_priorityModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] (NOLOCK) WHERE priorityId = @i_priorityId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA PRIORIDAD NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_PRIORITIES;
            BEGIN TRY
                UPDATE [SQM_CATALOGS].[TBL_Priorities]
                SET priorityName = COALESCE(@i_priorityName, priorityName),
                    priorityModificationDate = @i_priorityModificationDate,
                    priorityModificatorId = @i_priorityModificatorId,
                    priorityEnable = COALESCE(@i_priorityEnable, priorityEnable)
                WHERE priorityId = @i_priorityId;

                COMMIT TRANSACTION TRX_UPD_PRIORITIES;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'PRIORIDAD ACTUALIZADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_PRIORITIES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR PRIORIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR PRIORIDAD', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT PRIORIDAD --
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
                    priorityId,
                    priorityName,
                    priorityCreationDate,
                    priorityCreatorId,
                    priorityModificationDate,
                    priorityModificatorId,
                    priorityEnable
                FROM [SQM_CATALOGS].[TBL_Priorities] (NOLOCK)
                ORDER BY priorityId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'PRIORIDADES LISTADAS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR PRIORIDADES';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR PRIORIDADES', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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