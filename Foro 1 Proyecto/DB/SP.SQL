-- Bilsan Gaddiel Flores Lopez 240068
-- Leonardo Mariano Rios Garcia 220839
-- Yarling Moises Alvarez Ruiz 240771

USE [DB_SCRUM_PLANNING]
GO


--ESQUEMA: SQM_CATALOGS


-- 1. TABLA: [SQM_CATALOGS].[TBL_Status]

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Status_Insertar]
    @statusName VARCHAR(80),
    @statusCreatorId INT,
    @statusEnable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_CATALOGS].[TBL_Status] (
        statusName, statusCreationDate, statusCreatorId, 
        statusModificationDate, statusModificatorId, statusEnable
    )
    VALUES (
        @statusName, GETDATE(), @statusCreatorId, 
        GETDATE(), NULL, @statusEnable
    );
    SELECT SCOPE_IDENTITY() AS statusId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Status_Actualizar]
    @statusId INT,
    @statusName VARCHAR(80),
    @statusModificatorId INT,
    @statusEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_CATALOGS].[TBL_Status]
    SET statusName = @statusName,
        statusModificationDate = GETDATE(),
        statusModificatorId = @statusModificatorId,
        statusEnable = @statusEnable
    WHERE statusId = @statusId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Status_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        statusId, statusName, statusCreationDate, statusCreatorId, 
        statusModificationDate, statusModificatorId, statusEnable
    FROM [SQM_CATALOGS].[TBL_Status]
    ORDER BY statusId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 2. TABLA: [SQM_CATALOGS].[TBL_BusinessValues]
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_BusinessValues_Insertar]
    @businessValueName VARCHAR(80),
    @businessValueCreatorId INT,
    @businessValueEnable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_CATALOGS].[TBL_BusinessValues] (
        businessValueName, businessValueCreationDate, businessValueCreatorId, 
        businessValueModificationDate, businessValueModificatorId, businessValueEnable
    )
    VALUES (
        @businessValueName, GETDATE(), @businessValueCreatorId, 
        NULL, NULL, @businessValueEnable
    );
    SELECT SCOPE_IDENTITY() AS businessValueId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_BusinessValues_Actualizar]
    @businessValueId INT,
    @businessValueName VARCHAR(80),
    @businessValueModificatorId INT,
    @businessValueEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_CATALOGS].[TBL_BusinessValues]
    SET businessValueName = @businessValueName,
        businessValueModificationDate = GETDATE(),
        businessValueModificatorId = @businessValueModificatorId,
        businessValueEnable = @businessValueEnable
    WHERE businessValueId = @businessValueId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_BusinessValues_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        businessValueId, businessValueName, businessValueCreationDate, businessValueCreatorId, 
        businessValueModificationDate, businessValueModificatorId, businessValueEnable
    FROM [SQM_CATALOGS].[TBL_BusinessValues]
    ORDER BY businessValueId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 3. TABLA: [SQM_CATALOGS].[TBL_Priorities]
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Priorities_Insertar]
    @priorityName VARCHAR(80),
    @priorityCreatorId INT,
    @priorityEnable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_CATALOGS].[TBL_Priorities] (
        priorityName, priorityCreationDate, priorityCreatorId, 
        priorityModificationDate, priorityModificatorId, priorityEnable
    )
    VALUES (
        @priorityName, GETDATE(), @priorityCreatorId, 
        NULL, NULL, @priorityEnable
    );
    SELECT SCOPE_IDENTITY() AS priorityId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Priorities_Actualizar]
    @priorityId INT,
    @priorityName VARCHAR(80),
    @priorityModificatorId INT,
    @priorityEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_CATALOGS].[TBL_Priorities]
    SET priorityName = @priorityName,
        priorityModificationDate = GETDATE(),
        priorityModificatorId = @priorityModificatorId,
        priorityEnable = @priorityEnable
    WHERE priorityId = @priorityId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Priorities_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        priorityId, priorityName, priorityCreationDate, priorityCreatorId, 
        priorityModificationDate, priorityModificatorId, priorityEnable
    FROM [SQM_CATALOGS].[TBL_Priorities]
    ORDER BY priorityId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 4. TABLA: [SQM_CATALOGS].[TBL_ActivityTypes]
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_ActivityTypes_Insertar]
    @activityTypeName VARCHAR(80),
    @activityTypeCreatorId INT,
    @activityTypeEnable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_CATALOGS].[TBL_ActivityTypes] (
        activityTypeName, activityTypeCreationDate, activityTypeCreatorId, 
        activityTypeModificationDate, activityTypeModificatorId, activityTypeEnable
    )
    VALUES (
        @activityTypeName, GETDATE(), @activityTypeCreatorId, 
        NULL, NULL, @activityTypeEnable
    );
    SELECT SCOPE_IDENTITY() AS activityTypeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_ActivityTypes_Actualizar]
    @activityTypeId INT,
    @activityTypeName VARCHAR(80),
    @activityTypeModificatorId INT,
    @activityTypeEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_CATALOGS].[TBL_ActivityTypes]
    SET activityTypeName = @activityTypeName,
        activityTypeModificationDate = GETDATE(),
        activityTypeModificatorId = @activityTypeModificatorId,
        activityTypeEnable = @activityTypeEnable
    WHERE activityTypeId = @activityTypeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_ActivityTypes_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        activityTypeId, activityTypeName, activityTypeCreationDate, activityTypeCreatorId, 
        activityTypeModificationDate, activityTypeModificatorId, activityTypeEnable
    FROM [SQM_CATALOGS].[TBL_ActivityTypes]
    ORDER BY activityTypeId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO


   --ESQUEMA: SQM_SECURITY

-- 5. TABLA: [SQM_SECURITY].[TBL_Roles]
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Roles_Insertar]
    @rolName VARCHAR(80),
    @rolCreatorId INT,
    @rolEnable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_SECURITY].[TBL_Roles] (
        rolName, rolCreationDate, rolCreatorId, 
        rolModificationDate, rolModificatorId, rolEnable
    )
    VALUES (
        @rolName, GETDATE(), @rolCreatorId, 
        GETDATE(), NULL, @rolEnable
    );
    SELECT SCOPE_IDENTITY() AS rolId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Roles_Actualizar]
    @rolId INT,
    @rolName VARCHAR(80),
    @rolModificatorId INT,
    @rolEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_SECURITY].[TBL_Roles]
    SET rolName = @rolName,
        rolModificationDate = GETDATE(),
        rolModificatorId = @rolModificatorId,
        rolEnable = @rolEnable
    WHERE rolId = @rolId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Roles_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        rolId, rolName, rolCreationDate, rolCreatorId, 
        rolModificationDate, rolModificatorId, rolEnable
    FROM [SQM_SECURITY].[TBL_Roles]
    ORDER BY rolId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 6. TABLA: [SQM_SECURITY].[TBL_Users]

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Users_Insertar]
    @userFullName VARCHAR(80),
    @userName VARCHAR(80),
    @userEmail VARCHAR(80),
    @userPassword VARBINARY(256),
    @userRolId INT,
    @userCreatorId INT,
    @userEnable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_SECURITY].[TBL_Users] (
        userFullName, userName, userEmail, userPassword, userRolId, 
        userCreationDate, userCreatorId, userModificationDate, userModificatorId, userEnable
    )
    VALUES (
        @userFullName, @userName, @userEmail, @userPassword, @userRolId, 
        GETDATE(), @userCreatorId, GETDATE(), NULL, @userEnable
    );
    SELECT SCOPE_IDENTITY() AS userId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Users_Actualizar]
    @userId INT,
    @userFullName VARCHAR(80),
    @userName VARCHAR(80),
    @userEmail VARCHAR(80),
    @userPassword VARBINARY(256),
    @userRolId INT,
    @userModificatorId INT,
    @userEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_SECURITY].[TBL_Users]
    SET userFullName = @userFullName,
        userName = @userName,
        userEmail = @userEmail,
        userPassword = @userPassword,
        userRolId = @userRolId,
        userModificationDate = GETDATE(),
        userModificatorId = @userModificatorId,
        userEnable = @userEnable
    WHERE userId = @userId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Users_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        userId, userFullName, userName, userEmail, userRolId, 
        userCreationDate, userCreatorId, userModificationDate, userModificatorId, userEnable
    FROM [SQM_SECURITY].[TBL_Users]
    ORDER BY userId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO


   --ESQUEMA: SQM_GENERAL

-- 7. TABLA: [SQM_GENERAL].[TBL_Initiatives]
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Initiatives_Insertar]
    @initiativeSummary VARCHAR(200),
    @initiativeDescription VARCHAR(2000),
    @initiativeOwner INT,
    @initiativeGoals VARCHAR(255) = NULL,
    @initiativeBusinessValue INT,
    @initiativeTargetStart DATE = NULL,
    @initiativeTargetEnd DATE = NULL,
    @initiativeCreatorId INT,
    @initiativeStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_GENERAL].[TBL_Initiatives] (
        initiativeSummary, initiativeDescription, initiativeOwner, initiativeGoals, 
        initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd, 
        initiativeCreationDate, initiativeCreatorId, initiativeModificationDate, 
        initiativeModificatorId, initiativeStatus
    )
    VALUES (
        @initiativeSummary, @initiativeDescription, @initiativeOwner, @initiativeGoals, 
        @initiativeBusinessValue, @initiativeTargetStart, @initiativeTargetEnd, 
        GETDATE(), @initiativeCreatorId, NULL, 
        NULL, @initiativeStatus
    );
    SELECT SCOPE_IDENTITY() AS initiativeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Initiatives_Actualizar]
    @initiativeId INT,
    @initiativeSummary VARCHAR(200),
    @initiativeDescription VARCHAR(2000),
    @initiativeOwner INT,
    @initiativeGoals VARCHAR(255) = NULL,
    @initiativeBusinessValue INT,
    @initiativeTargetStart DATE = NULL,
    @initiativeTargetEnd DATE = NULL,
    @initiativeModificatorId INT,
    @initiativeStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_GENERAL].[TBL_Initiatives]
    SET initiativeSummary = @initiativeSummary,
        initiativeDescription = @initiativeDescription,
        initiativeOwner = @initiativeOwner,
        initiativeGoals = @initiativeGoals,
        initiativeBusinessValue = @initiativeBusinessValue,
        initiativeTargetStart = @initiativeTargetStart,
        initiativeTargetEnd = @initiativeTargetEnd,
        initiativeModificationDate = GETDATE(),
        initiativeModificatorId = @initiativeModificatorId,
        initiativeStatus = @initiativeStatus
    WHERE initiativeId = @initiativeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Initiatives_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        initiativeId, initiativeSummary, initiativeDescription, initiativeOwner, 
        initiativeGoals, initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd, 
        initiativeCreationDate, initiativeCreatorId, initiativeModificationDate, 
        initiativeModificatorId, initiativeStatus
    FROM [SQM_GENERAL].[TBL_Initiatives]
    ORDER BY initiativeId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 8. TABLA: [SQM_GENERAL].[TBL_Epics]
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Epics_Insertar]
    @epicName VARCHAR(100),
    @epicSummary VARCHAR(500),
    @epicDescription VARCHAR(4000),
    @epicParentLink INT,
    @epicOwner INT,
    @epicStartDate DATE = NULL,
    @epicDueDate DATE = NULL,
    @epicPriority INT = NULL,
    @epicCreatorId INT,
    @epicStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_GENERAL].[TBL_Epics] (
        epicName, epicSummary, epicDescription, epicParentLink, epicOwner, 
        epicStartDate, epicDueDate, epicPriority, epicCreationDate, 
        epicCreatorId, epicModificationDate, epicModificatorId, epicStatus
    )
    VALUES (
        @epicName, @epicSummary, @epicDescription, @epicParentLink, @epicOwner, 
        @epicStartDate, @epicDueDate, @epicPriority, GETDATE(), 
        @epicCreatorId, NULL, NULL, @epicStatus
    );
    SELECT SCOPE_IDENTITY() AS epicId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Epics_Actualizar]
    @epicId INT,
    @epicName VARCHAR(100),
    @epicSummary VARCHAR(500),
    @epicDescription VARCHAR(4000),
    @epicParentLink INT,
    @epicOwner INT,
    @epicStartDate DATE = NULL,
    @epicDueDate DATE = NULL,
    @epicPriority INT = NULL,
    @epicModificatorId INT,
    @epicStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_GENERAL].[TBL_Epics]
    SET epicName = @epicName,
        epicSummary = @epicSummary,
        epicDescription = @epicDescription,
        epicParentLink = @epicParentLink,
        epicOwner = @epicOwner,
        epicStartDate = @epicStartDate,
        epicDueDate = @epicDueDate,
        epicPriority = @epicPriority,
        epicModificationDate = GETDATE(),
        epicModificatorId = @epicModificatorId,
        epicStatus = @epicStatus
    WHERE epicId = @epicId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Epics_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        epicId, epicName, epicSummary, epicDescription, epicParentLink, epicOwner, 
        epicStartDate, epicDueDate, epicPriority, epicCreationDate, 
        epicCreatorId, epicModificationDate, epicModificatorId, epicStatus
    FROM [SQM_GENERAL].[TBL_Epics]
    ORDER BY epicId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 9. TABLA: [SQM_GENERAL].[TBL_Features]
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Features_Insertar]
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE = NULL,
    @featureDueDate DATE = NULL,
    @featurePriority INT = NULL,
    @featureCreatorId INT,
    @featureStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_GENERAL].[TBL_Features] (
        featureSummary, featureDescription, featuresAcceptanceCriteria, 
        featureParentLink, featureOwner, featureStartDate, featureDueDate, 
        featurePriority, featureCreationDate, featureCreatorId, 
        featureModificationDate, featureModificatorId, featureStatus
    )
    VALUES (
        @featureSummary, @featureDescription, @featuresAcceptanceCriteria, 
        @featureParentLink, @featureOwner, @featureStartDate, @featureDueDate, 
        @featurePriority, GETDATE(), @featureCreatorId, 
        NULL, NULL, @featureStatus
    );
    SELECT SCOPE_IDENTITY() AS featureId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Features_Actualizar]
    @featureId INT,
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE = NULL,
    @featureDueDate DATE = NULL,
    @featurePriority INT = NULL,
    @featureModificatorId INT,
    @featureStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_GENERAL].[TBL_Features]
    SET featureSummary = @featureSummary,
        featureDescription = @featureDescription,
        featuresAcceptanceCriteria = @featuresAcceptanceCriteria,
        featureParentLink = @featureParentLink,
        featureOwner = @featureOwner,
        featureStartDate = @featureStartDate,
        featureDueDate = @featureDueDate,
        featurePriority = @featurePriority,
        featureModificationDate = GETDATE(),
        featureModificatorId = @featureModificatorId,
        featureStatus = @featureStatus
    WHERE featureId = @featureId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Features_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        featureId, featureSummary, featureDescription, featuresAcceptanceCriteria, 
        featureParentLink, featureOwner, featureStartDate, featureDueDate, 
        featurePriority, featureCreationDate, featureCreatorId, 
        featureModificationDate, featureModificatorId, featureStatus
    FROM [SQM_GENERAL].[TBL_Features]
    ORDER BY featureId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 10. TABLA: [SQM_GENERAL].[TBL_ProductBacklogItems]
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_ProductBacklogItems_Insertar]
    @PBISummary VARCHAR(500),
    @PBIDescription VARCHAR(2000),
    @PBIsAcceptanceCriteria VARCHAR(4000),
    @PBIOwner INT,
    @PBIParentLink INT,
    @PBIStoryPoint INT = NULL,
    @PBIStartDate DATE = NULL,
    @PBIDueDate DATE = NULL,
    @PBIPriority INT = NULL,
    @PBICreatorId INT,
    @PBIStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_GENERAL].[TBL_ProductBacklogItems] (
        PBISummary, PBIDescription, PBIsAcceptanceCriteria, PBIOwner, 
        PBIParentLink, PBIStoryPoint, PBIStartDate, PBIDueDate, PBIPriority, 
        PBICreationDate, PBICreatorId, PBIModificationDate, PBIModificatorId, PBIStatus
    )
    VALUES (
        @PBISummary, @PBIDescription, @PBIsAcceptanceCriteria, @PBIOwner, 
        @PBIParentLink, @PBIStoryPoint, @PBIStartDate, @PBIDueDate, @PBIPriority, 
        GETDATE(), @PBICreatorId, NULL, NULL, @PBIStatus
    );
    SELECT SCOPE_IDENTITY() AS PBIId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_ProductBacklogItems_Actualizar]
    @PBIId INT,
    @PBISummary VARCHAR(500),
    @PBIDescription VARCHAR(2000),
    @PBIsAcceptanceCriteria VARCHAR(4000),
    @PBIOwner INT,
    @PBIParentLink INT,
    @PBIStoryPoint INT = NULL,
    @PBIStartDate DATE = NULL,
    @PBIDueDate DATE = NULL,
    @PBIPriority INT = NULL,
    @PBIModificatorId INT,
    @PBIStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_GENERAL].[TBL_ProductBacklogItems]
    SET PBISummary = @PBISummary,
        PBIDescription = @PBIDescription,
        PBIsAcceptanceCriteria = @PBIsAcceptanceCriteria,
        PBIOwner = @PBIOwner,
        PBIParentLink = @PBIParentLink,
        PBIStoryPoint = @PBIStoryPoint,
        PBIStartDate = @PBIStartDate,
        PBIDueDate = @PBIDueDate,
        PBIPriority = @PBIPriority,
        PBIModificationDate = GETDATE(),
        PBIModificatorId = @PBIModificatorId,
        PBIStatus = @PBIStatus
    WHERE PBIId = @PBIId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_ProductBacklogItems_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        PBIId, PBISummary, PBIDescription, PBIsAcceptanceCriteria, PBIOwner, 
        PBIParentLink, PBIStoryPoint, PBIStartDate, PBIDueDate, PBIPriority, 
        PBICreationDate, PBICreatorId, PBIModificationDate, PBIModificatorId, PBIStatus
    FROM [SQM_GENERAL].[TBL_ProductBacklogItems]
    ORDER BY PBIId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 11. TABLA: [SQM_GENERAL].[TBL_Tasks]
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Tasks_Insertar]
    @taskSummary VARCHAR(500),
    @taskDescription VARCHAR(2000),
    @taskOwner INT,
    @taskParentLink INT,
    @taskOriginalEstimate DECIMAL(4,2) = NULL,
    @taskCompletedWork DECIMAL(4,2) = NULL,
    @taskRemaningWork DECIMAL(4,2) = NULL,
    @taskStartDate DATE = NULL,
    @taskCompletedDate DATE = NULL,
    @taskDueDate DATE = NULL,
    @taskActivityType INT = NULL,
    @taskCreatorId INT,
    @taskStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_GENERAL].[TBL_Tasks] (
        taskSummary, taskDescription, taskOwner, taskParentLink, 
        taskOriginalEstimate, taskCompletedWork, taskRemaningWork, 
        taskStartDate, taskCompletedDate, taskDueDate, taskActivityType, 
        taskCreationDate, taskCreatorId, taskModificationDate, taskModificatorId, taskStatus
    )
    VALUES (
        @taskSummary, @taskDescription, @taskOwner, @taskParentLink, 
        @taskOriginalEstimate, @taskCompletedWork, @taskRemaningWork, 
        @taskStartDate, @taskCompletedDate, @taskDueDate, @taskActivityType, 
        GETDATE(), @taskCreatorId, NULL, NULL, @taskStatus
    );
    SELECT SCOPE_IDENTITY() AS taskId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Tasks_Actualizar]
    @taskId INT,
    @taskSummary VARCHAR(500),
    @taskDescription VARCHAR(2000),
    @taskOwner INT,
    @taskParentLink INT,
    @taskOriginalEstimate DECIMAL(4,2) = NULL,
    @taskCompletedWork DECIMAL(4,2) = NULL,
    @taskRemaningWork DECIMAL(4,2) = NULL,
    @taskStartDate DATE = NULL,
    @taskCompletedDate DATE = NULL,
    @taskDueDate DATE = NULL,
    @taskActivityType INT = NULL,
    @taskModificatorId INT,
    @taskStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_GENERAL].[TBL_Tasks]
    SET taskSummary = @taskSummary,
        taskDescription = @taskDescription,
        taskOwner = @taskOwner,
        taskParentLink = @taskParentLink,
        taskOriginalEstimate = @taskOriginalEstimate,
        taskCompletedWork = @taskCompletedWork,
        taskRemaningWork = @taskRemaningWork,
        taskStartDate = @taskStartDate,
        taskCompletedDate = @taskCompletedDate,
        taskDueDate = @taskDueDate,
        taskActivityType = @taskActivityType,
        taskModificationDate = GETDATE(),
        taskModificatorId = @taskModificatorId,
        taskStatus = @taskStatus
    WHERE taskId = @taskId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Tasks_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        taskId, taskSummary, taskDescription, taskOwner, taskParentLink, 
        taskOriginalEstimate, taskCompletedWork, taskRemaningWork, 
        taskStartDate, taskCompletedDate, taskDueDate, taskActivityType, 
        taskCreationDate, taskCreatorId, taskModificationDate, taskModificatorId, taskStatus
    FROM [SQM_GENERAL].[TBL_Tasks]
    ORDER BY taskId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO

-- 12. TABLA: [SQM_GENERAL].[TBL_TaskComments]
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_TaskComments_Insertar]
    @taskCommentParentLink INT,
    @taskCommentOwner INT,
    @taskCommentText NVARCHAR(4000),
    @taskCommentCreatorId INT,
    @taskCommentStatus BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [SQM_GENERAL].[TBL_TaskComments] (
        taskCommentParentLink, taskCommentOwner, taskCommentText, 
        taskCommentCreationDate, taskCommentCreatorId, 
        taskCommentModificationDate, taskCommentModificatorId, taskCommentStatus
    )
    VALUES (
        @taskCommentParentLink, @taskCommentOwner, @taskCommentText, 
        GETDATE(), @taskCommentCreatorId, 
        NULL, NULL, @taskCommentStatus
    );
    SELECT SCOPE_IDENTITY() AS taskCommentId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_TaskComments_Actualizar]
    @taskCommentId INT,
    @taskCommentParentLink INT,
    @taskCommentOwner INT,
    @taskCommentText NVARCHAR(4000),
    @taskCommentModificatorId INT,
    @taskCommentStatus BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [SQM_GENERAL].[TBL_TaskComments]
    SET taskCommentParentLink = @taskCommentParentLink,
        taskCommentOwner = @taskCommentOwner,
        taskCommentText = @taskCommentText,
        taskCommentModificationDate = GETDATE(),
        taskCommentModificatorId = @taskCommentModificatorId,
        taskCommentStatus = @taskCommentStatus
    WHERE taskCommentId = @taskCommentId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_TaskComments_Listar]
    @NumeroPagina INT = 1,
    @FilasPorPagina INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        taskCommentId, taskCommentParentLink, taskCommentOwner, taskCommentText, 
        taskCommentCreationDate, taskCommentCreatorId, 
        taskCommentModificationDate, taskCommentModificatorId, taskCommentStatus
    FROM [SQM_GENERAL].[TBL_TaskComments]
    ORDER BY taskCommentId ASC
    OFFSET (@NumeroPagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END
GO