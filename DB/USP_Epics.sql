CREATE OR ALTER PROC [SQM_GENERAL].[USP_Epics]
(
    @i_epicId INT = NULL,
    @i_epicName VARCHAR(100) = NULL,
    @i_epicSummary VARCHAR(500) = NULL,
    @i_epicDescription VARCHAR(4000) = NULL,
    @i_epicParentLink INT = NULL,
    @i_epicOwner INT = NULL,
    @i_epicStartDate DATE = NULL,
    @i_epicDueDate DATE = NULL,
    @i_epicPriority INT = NULL,
    @i_epicCreationDate DATETIME = NULL,
    @i_epicCreatorId INT = NULL,
    @i_epicModificationDate DATETIME = NULL,
    @i_epicModificatorId INT = NULL,
    @i_epicStatus INT = NULL,
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

    IF @i_epicCreationDate IS NULL
        SET @i_epicCreationDate = GETDATE();

    IF @i_epicModificationDate IS NULL
        SET @i_epicModificationDate = GETDATE();

    -- INSERTAR EPICA --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_epicName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DE LA EPICA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_epicSummary, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA EPICA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_epicDescription, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA EPICA ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_epicParentLink, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA INICIATIVA PADRE ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_epicOwner, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PROPIETARIO DE LA EPICA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_epicCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_epicStatus, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL STATUS DE LA EPICA ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_EPICS;
            BEGIN TRY
                INSERT INTO [SQM_GENERAL].[TBL_Epics]
                (epicName, epicSummary, epicDescription, epicParentLink, epicOwner, epicStartDate, epicDueDate, epicPriority, epicCreationDate, epicCreatorId, epicStatus)
                VALUES(@i_epicName, @i_epicSummary, @i_epicDescription, @i_epicParentLink, @i_epicOwner, @i_epicStartDate, @i_epicDueDate, @i_epicPriority, @i_epicCreationDate, @i_epicCreatorId, @i_epicStatus);

                COMMIT TRANSACTION TRX_INS_EPICS;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'EPICA REGISTRADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_EPICS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR EPICA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR EPICA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE EPICA --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_epicId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA EPICA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_epicModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Epics] (NOLOCK) WHERE epicId = @i_epicId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA EPICA NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_EPICS;
            BEGIN TRY
                UPDATE [SQM_GENERAL].[TBL_Epics]
                SET epicName = COALESCE(@i_epicName, epicName),
                    epicSummary = COALESCE(@i_epicSummary, epicSummary),
                    epicDescription = COALESCE(@i_epicDescription, epicDescription),
                    epicParentLink = COALESCE(@i_epicParentLink, epicParentLink),
                    epicOwner = COALESCE(@i_epicOwner, epicOwner),
                    epicStartDate = COALESCE(@i_epicStartDate, epicStartDate),
                    epicDueDate = COALESCE(@i_epicDueDate, epicDueDate),
                    epicPriority = COALESCE(@i_epicPriority, epicPriority),
                    epicModificationDate = @i_epicModificationDate,
                    epicModificatorId = @i_epicModificatorId,
                    epicStatus = COALESCE(@i_epicStatus, epicStatus)
                WHERE epicId = @i_epicId;

                COMMIT TRANSACTION TRX_UPD_EPICS;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'EPICA ACTUALIZADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_EPICS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR EPICA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR EPICA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT EPICA --
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
                    epicId,
                    epicName,
                    epicSummary,
                    epicDescription,
                    epicParentLink,
                    epicOwner,
                    epicStartDate,
                    epicDueDate,
                    epicPriority,
                    epicCreationDate,
                    epicCreatorId,
                    epicModificationDate,
                    epicModificatorId,
                    epicStatus
                FROM [SQM_GENERAL].[TBL_Epics] (NOLOCK)
                ORDER BY epicId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'EPICAS LISTADAS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR EPICAS';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR EPICAS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
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