USE DB_SCRUM_PLANNING
GO

-- SELECT *
-- FROM SQM_SECURITY.TBL_Users

-- SELECT *
-- FROM SQM_CATALOGS.TBL_Roles

DECLARE @Numero INT, @MensajeUsuario VARCHAR(500), @MensajeTecnico VARCHAR(500)

-- EXEC [SQM_SECURITY].[USP_Users]
--     @i_userFullName = 'Juan Barrera',
--     @i_userName = 'jbarrera',
--     @i_userPassword = 'MiPassword123',
--     @i_userRolId = 2,
--     @i_userCreatorId = 3,
--     @w_Accion = 'I',
--     @o_Numero = @Numero OUTPUT,
--     @o_MensajeUsuario = @MensajeUsuario OUTPUT,
--     @o_MensajeTecnico = @MensajeTecnico OUTPUT;


-- EXEC [SQM_SECURITY].[USP_Users]
--     @i_userId = 7,
--     --@i_userFullName = 'Juan P. Actualizado',
--     @i_userName = 'kvelasquez',
--     @i_userPassword = 'NuevoPassword456',
--     --@i_userRolId = 2,
--     @i_userModificatorId = 6,
--     --@i_userEnable = 1,
--     @w_Accion = 'U',
--     @o_Numero = @Numero OUTPUT,
--     @o_MensajeUsuario = @MensajeUsuario OUTPUT,
--     @o_MensajeTecnico = @MensajeTecnico OUTPUT;


EXEC [SQM_SECURITY].[USP_Users]
    @i_PageNumber = 3,
    @i_RowsPerPage = 10,
    @w_Accion = 'S',
    @o_Numero = @Numero OUTPUT,
    @o_MensajeUsuario = @MensajeUsuario OUTPUT,
    @o_MensajeTecnico = @MensajeTecnico OUTPUT;


-- EXEC [SQM_SECURITY].[USP_Users]
--     @w_Accion = 'X',
--     @o_Numero = @Numero OUTPUT,
--     @o_MensajeUsuario = @MensajeUsuario OUTPUT,
--     @o_MensajeTecnico = @MensajeTecnico OUTPUT;

SELECT @Numero AS Codigo, @MensajeUsuario AS MensajeUsuario, @MensajeTecnico AS MensajeTecnico