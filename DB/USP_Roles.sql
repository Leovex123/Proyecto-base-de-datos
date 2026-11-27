CREATE OR ALTER PROC [SQM_SECURITY].[USP_Roles]
(
    @i_rolId INT = NULL,
    @i_rolName VARCHAR(80) = NULL,
    @i_rolCreationDate DATETIME = NULL,
    @i_rolCreatorId INT = NULL,
    @i_rolModificationDate DATETIME = NULL,
    @i_rolModificatorId INT = NULL,
    @i_rolEnable BIT = NULL,
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

    IF @i_rolCreationDate IS NULL
        SET @i_rolCreationDate = GETDATE();

    IF @i_rolModificationDate IS NULL
        SET @i_rolModificationDate = GETDATE();

    -- INSERTAR ROL --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_rolName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_rolCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE IF EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Roles] (NOLOCK) WHERE LOWER(rolName) = LOWER(@i_rolName))
        BEGIN
            SET @o_Numero = 409;
            SET @o_MensajeUsuario = 'YA EXISTE UN ROL REGISTRADO CON ESE NOMBRE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_ROL;
            BEGIN TRY
                INSERT INTO [SQM_SECURITY].[TBL_Roles]
                (rolName, rolCreationDate, rolCreatorId, rolEnable)
                VALUES(@i_rolName, @i_rolCreationDate, @i_rolCreatorId, 1);

                COMMIT TRANSACTION TRX_INS_ROL;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'ROL REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_ROL;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR ROL';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR ROL', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE ROL --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_rolId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL ROL ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_rolModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Roles] (NOLOCK) WHERE rolId = @i_rolId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL ROL NO EXISTE';
        END;
        ELSE IF @i_rolName IS NOT NULL AND EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Roles] (NOLOCK) WHERE LOWER(rolName) = LOWER(@i_rolName) AND rolId <> @i_rolId)
        BEGIN
            SET @o_Numero = 409;
            SET @o_MensajeUsuario = 'YA EXISTE OTRO ROL REGISTRADO CON ESE NOMBRE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_ROL;
            BEGIN TRY
                UPDATE [SQM_SECURITY].[TBL_Roles]
                SET rolName = COALESCE(@i_rolName, rolName),
                    rolModificationDate = @i_rolModificationDate,
                    rolModificatorId = @i_rolModificatorId,
                    rolEnable = COALESCE(@i_rolEnable, rolEnable)
                WHERE rolId = @i_rolId;

                COMMIT TRANSACTION TRX_UPD_ROL;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'ROL ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_ROL;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR ROL';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR ROL', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT ROL --
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
                    rolId,
                    rolName,
                    rolCreationDate,
                    rolCreatorId,
                    rolModificationDate,
                    rolModificatorId,
                    rolEnable
                FROM [SQM_SECURITY].[TBL_Roles] (NOLOCK)
                WHERE (@i_rolName IS NULL OR rolName LIKE '%' + @i_rolName + '%')
                  AND (@i_rolEnable IS NULL OR rolEnable = @i_rolEnable)
                ORDER BY rolId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'ROLES LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR ROLES';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR ROLES', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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