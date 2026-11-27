CREATE OR ALTER PROC [SQM_GENERAL].[USP_ProductBacklogItems]
(
    @i_PBIId INT = NULL,
    @i_PBISummary VARCHAR(500) = NULL,
    @i_PBIDescription VARCHAR(2000) = NULL,
    @i_PBIsAcceptanceCriteria VARCHAR(4000) = NULL,
    @i_PBIOwner INT = NULL,
    @i_PBIParentLink INT = NULL,
    @i_PBIStoryPoint INT = NULL,
    @i_PBIStartDate DATE = NULL,
    @i_PBIDueDate DATE = NULL,
    @i_PBIPriority INT = NULL,
    @i_PBICreationDate DATETIME = NULL,
    @i_PBICreatorId INT = NULL,
    @i_PBIModificationDate DATETIME = NULL,
    @i_PBIModificatorId INT = NULL,
    @i_PBIStatus INT = NULL,
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

    IF @i_PBICreationDate IS NULL
        SET @i_PBICreationDate = GETDATE();

    IF @i_PBIModificationDate IS NULL
        SET @i_PBIModificationDate = GETDATE();

    -- INSERTAR PBI --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_PBISummary, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DEL PBI ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_PBIDescription, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DEL PBI ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_PBIsAcceptanceCriteria, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS CRITERIOS DE ACEPTACION SON OBLIGATORIOS';
        END;
        ELSE IF ISNULL(@i_PBIOwner, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PROPIETARIO DEL PBI ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_PBIParentLink, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL FEATURE PADRE ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_PBICreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_PBIStatus, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL STATUS DEL PBI ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_PBIS;
            BEGIN TRY
                INSERT INTO [SQM_GENERAL].[TBL_ProductBacklogItems]
                (PBISummary, PBIDescription, PBIsAcceptanceCriteria, PBIOwner, PBIParentLink, PBIStoryPoint, PBIStartDate, PBIDueDate, PBIPriority, PBICreationDate, PBICreatorId, PBIStatus)
                VALUES(@i_PBISummary, @i_PBIDescription, @i_PBIsAcceptanceCriteria, @i_PBIOwner, @i_PBIParentLink, @i_PBIStoryPoint, @i_PBIStartDate, @i_PBIDueDate, @i_PBIPriority, @i_PBICreationDate, @i_PBICreatorId, @i_PBIStatus);

                COMMIT TRANSACTION TRX_INS_PBIS;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'PBI REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_PBIS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR PBI';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR PBI', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE PBI --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_PBIId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL PBI ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_PBIModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_ProductBacklogItems] (NOLOCK) WHERE PBIId = @i_PBIId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL PBI NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_PBIS;
            BEGIN TRY
                UPDATE [SQM_GENERAL].[TBL_ProductBacklogItems]
                SET PBISummary = COALESCE(@i_PBISummary, PBISummary),
                    PBIDescription = COALESCE(@i_PBIDescription, PBIDescription),
                    PBIsAcceptanceCriteria = COALESCE(@i_PBIsAcceptanceCriteria, PBIsAcceptanceCriteria),
                    PBIOwner = COALESCE(@i_PBIOwner, PBIOwner),
                    PBIParentLink = COALESCE(@i_PBIParentLink, PBIParentLink),
                    PBIStoryPoint = COALESCE(@i_PBIStoryPoint, PBIStoryPoint),
                    PBIStartDate = COALESCE(@i_PBIStartDate, PBIStartDate),
                    PBIDueDate = COALESCE(@i_PBIDueDate, PBIDueDate),
                    PBIPriority = COALESCE(@i_PBIPriority, PBIPriority),
                    PBIModificationDate = @i_PBIModificationDate,
                    PBIModificatorId = @i_PBIModificatorId,
                    PBIStatus = COALESCE(@i_PBIStatus, PBIStatus)
                WHERE PBIId = @i_PBIId;

                COMMIT TRANSACTION TRX_UPD_PBIS;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'PBI ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_PBIS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR PBI';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR PBI', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT PBI --
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
                    PBIId,
                    PBISummary,
                    PBIDescription,
                    PBIsAcceptanceCriteria,
                    PBIOwner,
                    PBIParentLink,
                    PBIStoryPoint,
                    PBIStartDate,
                    PBIDueDate,
                    PBIPriority,
                    PBICreationDate,
                    PBICreatorId,
                    PBIModificationDate,
                    PBIModificatorId,
                    PBIStatus
                FROM [SQM_GENERAL].[TBL_ProductBacklogItems] (NOLOCK)
                ORDER BY PBIId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'PBIS LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR PBIS';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR PBIS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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