CREATE OR ALTER PROC [SQM_GENERAL].[USP_Features]
(
    @i_featureId INT = NULL,
    @i_featureSummary VARCHAR(500) = NULL,
    @i_featureDescription VARCHAR(2000) = NULL,
    @i_featuresAcceptanceCriteria VARCHAR(4000) = NULL,
    @i_featureParentLink INT = NULL,
    @i_featureOwner INT = NULL,
    @i_featureStartDate DATE = NULL,
    @i_featureDueDate DATE = NULL,
    @i_featurePriority INT = NULL,
    @i_featureCreationDate DATETIME = NULL,
    @i_featureCreatorId INT = NULL,
    @i_featureModificationDate DATETIME = NULL,
    @i_featureModificatorId INT = NULL,
    @i_featureStatus INT = NULL,
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

    IF @i_featureCreationDate IS NULL
        SET @i_featureCreationDate = GETDATE();

    IF @i_featureModificationDate IS NULL
        SET @i_featureModificationDate = GETDATE();

    -- INSERTAR FEATURE --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_featureSummary, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DEL FEATURE ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_featureDescription, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DEL FEATURE ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_featuresAcceptanceCriteria, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS CRITERIOS DE ACEPTACION SON OBLIGATORIOS';
        END;
        ELSE IF ISNULL(@i_featureParentLink, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA EPICA PADRE ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_featureOwner, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PROPIETARIO DEL FEATURE ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_featureCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_featureStatus, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL STATUS DEL FEATURE ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_FEATURES;
            BEGIN TRY
                INSERT INTO [SQM_GENERAL].[TBL_Features]
                (featureSummary, featureDescription, featuresAcceptanceCriteria, featureParentLink, featureOwner, featureStartDate, featureDueDate, featurePriority, featureCreationDate, featureCreatorId, featureStatus)
                VALUES(@i_featureSummary, @i_featureDescription, @i_featuresAcceptanceCriteria, @i_featureParentLink, @i_featureOwner, @i_featureStartDate, @i_featureDueDate, @i_featurePriority, @i_featureCreationDate, @i_featureCreatorId, @i_featureStatus);

                COMMIT TRANSACTION TRX_INS_FEATURES;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'FEATURE REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_FEATURES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR FEATURE';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR FEATURE', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE FEATURE --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_featureId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL FEATURE ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_featureModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Features] (NOLOCK) WHERE featureId = @i_featureId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL FEATURE NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_FEATURES;
            BEGIN TRY
                UPDATE [SQM_GENERAL].[TBL_Features]
                SET featureSummary = COALESCE(@i_featureSummary, featureSummary),
                    featureDescription = COALESCE(@i_featureDescription, featureDescription),
                    featuresAcceptanceCriteria = COALESCE(@i_featuresAcceptanceCriteria, featuresAcceptanceCriteria),
                    featureParentLink = COALESCE(@i_featureParentLink, featureParentLink),
                    featureOwner = COALESCE(@i_featureOwner, featureOwner),
                    featureStartDate = COALESCE(@i_featureStartDate, featureStartDate),
                    featureDueDate = COALESCE(@i_featureDueDate, featureDueDate),
                    featurePriority = COALESCE(@i_featurePriority, featurePriority),
                    featureModificationDate = @i_featureModificationDate,
                    featureModificatorId = @i_featureModificatorId,
                    featureStatus = COALESCE(@i_featureStatus, featureStatus)
                WHERE featureId = @i_featureId;

                COMMIT TRANSACTION TRX_UPD_FEATURES;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'FEATURE ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_FEATURES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR FEATURE';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR FEATURE', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT FEATURE --
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
                    featureId,
                    featureSummary,
                    featureDescription,
                    featuresAcceptanceCriteria,
                    featureParentLink,
                    featureOwner,
                    featureStartDate,
                    featureDueDate,
                    featurePriority,
                    featureCreationDate,
                    featureCreatorId,
                    featureModificationDate,
                    featureModificatorId,
                    featureStatus
                FROM [SQM_GENERAL].[TBL_Features] (NOLOCK)
                ORDER BY featureId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'FEATURES LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR FEATURES';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR FEATURES', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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