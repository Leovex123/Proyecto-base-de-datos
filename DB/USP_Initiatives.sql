CREATE OR ALTER PROC [SQM_GENERAL].[USP_Initiatives]
(
    @i_initiativeId INT = NULL,
    @i_initiativeSummary VARCHAR(200) = NULL,
    @i_initiativeDescription VARCHAR(2000) = NULL,
    @i_initiativeOwner INT = NULL,
    @i_initiativeGoals VARCHAR(255) = NULL,
    @i_initiativeBusinessValue INT = NULL,
    @i_initiativeTargetStart DATE = NULL,
    @i_initiativeTargetEnd DATE = NULL,
    @i_initiativeCreationDate DATETIME = NULL,
    @i_initiativeCreatorId INT = NULL,
    @i_initiativeModificationDate DATETIME = NULL,
    @i_initiativeModificatorId INT = NULL,
    @i_initiativeStatus INT = NULL,
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

    IF @i_initiativeCreationDate IS NULL
        SET @i_initiativeCreationDate = GETDATE();

    IF @i_initiativeModificationDate IS NULL
        SET @i_initiativeModificationDate = GETDATE();

    -- INSERTAR INICIATIVA --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_initiativeSummary, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA INICIATIVA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_initiativeDescription, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA INICIATIVA ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_initiativeOwner, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PROPIETARIO DE LA INICIATIVA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_initiativeBusinessValue, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL VALOR DE NEGOCIO ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_initiativeCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_initiativeStatus, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL STATUS DE LA INICIATIVA ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_INITIATIVES;
            BEGIN TRY
                INSERT INTO [SQM_GENERAL].[TBL_Initiatives]
                (initiativeSummary, initiativeDescription, initiativeOwner, initiativeGoals, initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd, initiativeCreationDate, initiativeCreatorId, initiativeStatus)
                VALUES(@i_initiativeSummary, @i_initiativeDescription, @i_initiativeOwner, @i_initiativeGoals, @i_initiativeBusinessValue, @i_initiativeTargetStart, @i_initiativeTargetEnd, @i_initiativeCreationDate, @i_initiativeCreatorId, @i_initiativeStatus);

                COMMIT TRANSACTION TRX_INS_INITIATIVES;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'INICIATIVA REGISTRADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_INITIATIVES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR INICIATIVA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR INICIATIVA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE INICIATIVA --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_initiativeId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA INICIATIVA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_initiativeModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Initiatives] (NOLOCK) WHERE initiativeId = @i_initiativeId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA INICIATIVA NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_INITIATIVES;
            BEGIN TRY
                UPDATE [SQM_GENERAL].[TBL_Initiatives]
                SET initiativeSummary = COALESCE(@i_initiativeSummary, initiativeSummary),
                    initiativeDescription = COALESCE(@i_initiativeDescription, initiativeDescription),
                    initiativeOwner = COALESCE(@i_initiativeOwner, initiativeOwner),
                    initiativeGoals = COALESCE(@i_initiativeGoals, initiativeGoals),
                    initiativeBusinessValue = COALESCE(@i_initiativeBusinessValue, initiativeBusinessValue),
                    initiativeTargetStart = COALESCE(@i_initiativeTargetStart, initiativeTargetStart),
                    initiativeTargetEnd = COALESCE(@i_initiativeTargetEnd, initiativeTargetEnd),
                    initiativeModificationDate = @i_initiativeModificationDate,
                    initiativeModificatorId = @i_initiativeModificatorId,
                    initiativeStatus = COALESCE(@i_initiativeStatus, initiativeStatus)
                WHERE initiativeId = @i_initiativeId;

                COMMIT TRANSACTION TRX_UPD_INITIATIVES;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'INICIATIVA ACTUALIZADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_INITIATIVES;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR INICIATIVA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR INICIATIVA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT INICIATIVA --
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
                    initiativeId,
                    initiativeSummary,
                    initiativeDescription,
                    initiativeOwner,
                    initiativeGoals,
                    initiativeBusinessValue,
                    initiativeTargetStart,
                    initiativeTargetEnd,
                    initiativeCreationDate,
                    initiativeCreatorId,
                    initiativeModificationDate,
                    initiativeModificatorId,
                    initiativeStatus
                FROM [SQM_GENERAL].[TBL_Initiatives] (NOLOCK)
                ORDER BY initiativeId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'INICIATIVAS LISTADAS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR INICIATIVAS';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR INICIATIVAS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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