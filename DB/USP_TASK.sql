CREATE OR ALTER PROC [SQM_GENERAL].[USP_Tasks]
(
    @i_taskId INT = NULL,
    @i_taskSummary VARCHAR(500) = NULL,
    @i_taskDescription VARCHAR(2000) = NULL,
    @i_taskOwner INT = NULL,
    @i_taskParentLink INT = NULL,
    @i_taskOriginalEstimate DECIMAL(4,2) = NULL,
    @i_taskCompletedWork DECIMAL(4,2) = NULL,
    @i_taskRemaningWork DECIMAL(4,2) = NULL,
    @i_taskStartDate DATE = NULL,
    @i_taskCompletedDate DATE = NULL,
    @i_taskDueDate DATE = NULL,
    @i_taskActivityType INT = NULL,
    @i_taskCreationDate DATETIME = NULL,
    @i_taskCreatorId INT = NULL,
    @i_taskModificationDate DATETIME = NULL,
    @i_taskModificatorId INT = NULL,
    @i_taskStatus INT = NULL,
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

    IF @i_taskCreationDate IS NULL
        SET @i_taskCreationDate = GETDATE();

    IF @i_taskModificationDate IS NULL
        SET @i_taskModificationDate = GETDATE();

    -- INSERTAR TASK --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_taskSummary,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA TAREA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskDescription,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA TAREA ES OBLIGATORIA';
        END;
        ELSE IF ISNULL(@i_taskOwner,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PROPIETARIO DE LA TAREA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskParentLink,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL PBI PADRE ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskCreatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskStatus,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL STATUS DE LA TAREA ES OBLIGATORIO';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_TASKS;
            BEGIN TRY
                INSERT INTO [SQM_GENERAL].[TBL_Tasks]
                (taskSummary, taskDescription, taskOwner, taskParentLink, taskOriginalEstimate, taskCompletedWork, taskRemaningWork, taskStartDate, taskCompletedDate, taskDueDate, taskActivityType, taskCreationDate, taskCreatorId, taskStatus)
                VALUES(@i_taskSummary, @i_taskDescription, @i_taskOwner, @i_taskParentLink, @i_taskOriginalEstimate, @i_taskCompletedWork, @i_taskRemaningWork, @i_taskStartDate, @i_taskCompletedDate, @i_taskDueDate, @i_taskActivityType, @i_taskCreationDate, @i_taskCreatorId, @i_taskStatus);

                COMMIT TRANSACTION TRX_INS_TASKS;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'TAREA REGISTRADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_INS_TASKS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR TAREA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- UPDATE TASK --
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_taskId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA TAREA ES OBLIGATORIO';
        END;
        ELSE IF ISNULL(@i_taskModificatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;
        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Tasks] (NOLOCK) WHERE taskId = @i_taskId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA TAREA NO EXISTE';
        END;
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_TASKS;
            BEGIN TRY
                UPDATE [SQM_GENERAL].[TBL_Tasks]
                SET taskSummary = COALESCE(@i_taskSummary, taskSummary),
                    taskDescription = COALESCE(@i_taskDescription, taskDescription),
                    taskOwner = COALESCE(@i_taskOwner, taskOwner),
                    taskParentLink = COALESCE(@i_taskParentLink, taskParentLink),
                    taskOriginalEstimate = COALESCE(@i_taskOriginalEstimate, taskOriginalEstimate),
                    taskCompletedWork = COALESCE(@i_taskCompletedWork, taskCompletedWork),
                    taskRemaningWork = COALESCE(@i_taskRemaningWork, taskRemaningWork),
                    taskStartDate = COALESCE(@i_taskStartDate, taskStartDate),
                    taskCompletedDate = COALESCE(@i_taskCompletedDate, taskCompletedDate),
                    taskDueDate = COALESCE(@i_taskDueDate, taskDueDate),
                    taskActivityType = COALESCE(@i_taskActivityType, taskActivityType),
                    taskModificationDate = @i_taskModificationDate,
                    taskModificatorId = @i_taskModificatorId,
                    taskStatus = COALESCE(@i_taskStatus, taskStatus)
                WHERE taskId = @i_taskId;

                COMMIT TRANSACTION TRX_UPD_TASKS;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'TAREA ACTUALIZADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TRX_UPD_TASKS;
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR TAREA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
            END CATCH
        END
    END

    -- SELECT TASK --
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
                    taskId,
                    taskSummary,
                    taskDescription,
                    taskOwner,
                    taskParentLink,
                    taskOriginalEstimate,
                    taskCompletedWork,
                    taskRemaningWork,
                    taskStartDate,
                    taskCompletedDate,
                    taskDueDate,
                    taskActivityType,
                    taskCreationDate,
                    taskCreatorId,
                    taskModificationDate,
                    taskModificatorId,
                    taskStatus
                FROM [SQM_GENERAL].[TBL_Tasks] (NOLOCK)
                ORDER BY taskId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF (@w_totalRows > 0)
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'TAREAS LISTADAS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR TAREAS';
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