USE DB_SCRUM_PLANNING
GO

SELECT *
FROM SQM_SECURITY.TBL_Users

SELECT *
FROM SQM_SECURITY.TBL_Roles

INSERT INTO SQM_SECURITY.TBL_Roles (rolName, rolCreationDate, rolCreatorId, rolEnable)
VALUES ('Operativo', GETDATE(), 1, 1)

ALTER TABLE SQM_SECURITY.TBL_Users
ADD CONSTRAINT FK_TBL_Users_TBL_Roles FOREIGN KEY (userRolId)
REFERENCES SQM_SECURITY.TBL_Roles(rolId)

EXEC [SQM_SECURITY].[USP_Users]
    @i_userFullName = 'Jose Luis Espinoza',
    @i_userEmail = 'j',
    @i_userName = 'joseespinoza@udem.edu.ni',
    @i_userPassword = 'MiPassword123',
    @i_userRolId = 2,
    @i_userCreatorId = 3,
    @w_Accion = 'I'


EXEC [SQM_SECURITY].[USP_Users]
    @i_userId = 3,
    @i_userModificatorId = 6,
    @i_userRolId = 1,
    @w_Accion = 'U'


EXEC [SQM_SECURITY].[USP_Users]
    @i_PageNumber = 2,
    @i_RowsPerPage = 10,
    @w_Accion = 'S'


EXEC [SQM_SECURITY].[USP_Users]
    @w_Accion = 'X'

-- EXEC [SQM_CATALOGS].[USP_Status]
--     @w_Accion = 'S',
--     @o_Numero = @Numero OUTPUT,
--     @o_MensajeUsuario = @MensajeUsuario OUTPUT,
--     @o_MensajeTecnico = @MensajeTecnico OUTPUT;