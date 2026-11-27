CREATE OR ALTER PROC [SQM_CATALOGS].[USP_ActivityTypes]
(
    @i_activityTypeId INT = NULL,
    @i_activityTypeName VARCHAR(80) = NULL,
    @i_activityTypeCreationDate DATETIME = NULL,
    @i_activityTypeCreatorId INT = NULL,
    @i_activityTypeModificationDate DATETIME = NULL,
    @i_activityTypeModificatorId INT = NULL,
    @i_activityTypeEnable BIT = NULL,
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

    IF @i_activityTypeCreationDate IS NULL
        SET @i_activityTypeCreationDate = GETDATE();

    IF @i_activityTypeModificationDate IS NULL
        SET @i_activityTypeModificationDate = GETDATE();

    -- INSERTAR ACTIVITY TYPE --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_activityTypeName,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL TIPO DE ACTIVIDAD ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_activityTypeCreatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_ACTIVITYTYPES;
            BEGIN TRY
                INSERT INTO [SQM_CATALOGS].[TBL_ActivityTypes]
                (activityTypeName, activityTypeCreationDate, activityTypeCreatorId, activityTypeEnable)
                VALUES(@i_activityTypeName, @i_activityTypeCreationDate, @i_activityTypeCreatorId, 1);

                COMMIT TRANSACTION TRX_INS_ACTIVITYTYPES;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'TIPO DE ACTIVIDAD REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_ACTIVITYTYPES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR TIPO DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE ACTIVITY TYPE --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_activityTypeId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL TIPO DE ACTIVIDAD ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_activityTypeModificatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_ActivityTypes] (NOLOCK) WHERE activityTypeId = @i_activityTypeId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL TIPO DE ACTIVIDAD NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_ACTIVITYTYPES;
            BEGIN TRY
                UPDATE [SQM_CATALOGS].[TBL_ActivityTypes]
                SET activityTypeName = COALESCE(@i_activityTypeName, activityTypeName),
                    activityTypeModificationDate = @i_activityTypeModificationDate,
                    activityTypeModificatorId = @i_activityTypeModificatorId,
                    activityTypeEnable = COALESCE(@i_activityTypeEnable, activityTypeEnable)
                WHERE activityTypeId = @i_activityTypeId;

                COMMIT TRANSACTION TRX_UPD_ACTIVITYTYPES;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'TIPO DE ACTIVIDAD ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_ACTIVITYTYPES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR TIPO DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT ACTIVITY TYPE --
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF ISNULL(@i_PageNumber,0) <= 0 OR ISNULL(@i_RowsPerPage,0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS PARAMETROS DE PAGINACION SON OBLIGATORIOS Y DEBEN SER MAYORES A CERO';
        END
        ELSE
        BEGIN
            BEGIN TRY
                SELECT 
                    activityTypeId,
                    activityTypeName,
                    activityTypeCreationDate,
                    activityTypeCreatorId,
                    activityTypeModificationDate,
                    activityTypeModificatorId,
                    activityTypeEnable
                FROM [SQM_CATALOGS].[TBL_ActivityTypes] (NOLOCK)
                ORDER BY activityTypeId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'TIPOS DE ACTIVIDAD LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR TIPOS DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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