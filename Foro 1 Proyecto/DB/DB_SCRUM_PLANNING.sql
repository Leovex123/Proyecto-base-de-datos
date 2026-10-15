CREATE DATABASE [DB_SCRUM_PLANNING]
GO

USE [DB_SCRUM_PLANNING]
GO

CREATE SCHEMA [SQM_SECURITY]
GO
CREATE SCHEMA [SQM_CATALOGS]
GO
CREATE SCHEMA [SQM_GENERAL]
GO

CREATE TABLE [SQM_CATALOGS].[TBL_Status]
(
	statusId INT PRIMARY KEY IDENTITY (1,1),
	statusName VARCHAR(80) NOT NULL,
	statusCreationDate DATETIME NOT NULL,
	statusCreatorId INT NOT NULL,
	statusModificationDate DATETIME NOT NULL,
	statusModificatorId INT NULL,
	statusEnable BIT NOT NULL
);

CREATE TABLE [SQM_SECURITY].[TBL_Roles]
(
	rolId INT PRIMARY KEY IDENTITY (1,1),
	rolName VARCHAR(80) NOT NULL,
	rolCreationDate DATETIME NOT NULL,
	rolCreatorId INT NOT NULL,
	rolModificationDate DATETIME NOT NULL,
	rolModificatorId INT NULL,
	rolEnable BIT NOT NULL
);

CREATE TABLE [SQM_SECURITY].[TBL_Users]
(
	userId INT PRIMARY KEY IDENTITY (1,1),
	userFullName VARCHAR(80) NOT NULL,
	userName VARCHAR(80) NOT NULL,
	userEmail VARCHAR(80) NOT NULL,
	userPassword VARBINARY(256) NOT NULL,
	userRolId INT REFERENCES [SQM_SECURITY].[TBL_Roles](rolId) NOT NULL,
	userCreationDate DATETIME NOT NULL,
	userCreatorId INT NOT NULL,
	userModificationDate DATETIME NOT NULL,
	userModificatorId INT NULL,
	userEnable BIT NOT NULL
);

CREATE TABLE [SQM_CATALOGS].[TBL_BusinessValues]
(
	businessValueId INT PRIMARY KEY IDENTITY (1,1),
	businessValueName VARCHAR(80) NOT NULL,
	businessValueCreationDate DATETIME NOT NULL,
	businessValueCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	businessValueModificationDate DATETIME NULL,
	businessValueModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	businessValueEnable BIT NOT NULL
);

CREATE TABLE [SQM_GENERAL].[TBL_Initiatives]
(
	initiativeId INT PRIMARY KEY IDENTITY (1,1),
	initiativeSummary VARCHAR(200) NOT NULL,
	initiativeDescription VARCHAR(2000) NOT NULL,
	initiativeOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	initiativeGoals VARCHAR(255) NULL,
	initiativeBusinessValue INT REFERENCES [SQM_CATALOGS].[TBL_BusinessValues](BusinessValueId) NOT NULL,
	initiativeTargetStart DATE NULL,
	initiativeTargetEnd DATE NULL,
	initiativeCreationDate DATETIME NOT NULL,
	initiativeCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	initiativeModificationDate DATETIME NULL,
	initiativeModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	initiativeStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);

CREATE TABLE [SQM_CATALOGS].[TBL_Priorities]
(
	priorityId INT PRIMARY KEY IDENTITY (1,1),
	priorityName VARCHAR(80) NOT NULL,
	priorityCreationDate DATETIME NOT NULL,
	priorityCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	priorityModificationDate DATETIME NULL,
	priorityModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	priorityEnable BIT NOT NULL
);

CREATE TABLE [SQM_GENERAL].[TBL_Epics]
(
	epicId INT PRIMARY KEY IDENTITY (1,1),
	epicName VARCHAR(100) NOT NULL,
	epicSummary VARCHAR(500) NOT NULL,
	epicDescription VARCHAR(4000) NOT NULL,
	epicParentLink INT REFERENCES [SQM_GENERAL].[TBL_Initiatives](initiativeId) NOT NULL,
	epicOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	epicStartDate DATE NULL,
	epicDueDate DATE NULL,
	epicPriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	epicCreationDate DATETIME NOT NULL,
	epicCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	epicModificationDate DATETIME NULL,
	epicModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	epicStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);

CREATE TABLE [SQM_GENERAL].[TBL_Features]
(
	featureId INT PRIMARY KEY IDENTITY (1,1),
	featureSummary VARCHAR(500) NOT NULL,
	featureDescription VARCHAR(2000) NOT NULL,
	featuresAcceptanceCriteria VARCHAR(4000) NOT NULL,
	featureParentLink INT REFERENCES [SQM_GENERAL].[TBL_Epics](epicId) NOT NULL,
	featureOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	featureStartDate DATE NULL,
	featureDueDate DATE NULL,
	featurePriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	featureCreationDate DATETIME NOT NULL,
	featureCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	featureModificationDate DATETIME NULL,
	featureModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	featureStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);

CREATE TABLE [SQM_GENERAL].[TBL_ProductBacklogItems]
(
	PBIId INT PRIMARY KEY IDENTITY (1,1),
	PBISummary VARCHAR(500) NOT NULL,
	PBIDescription VARCHAR(2000) NOT NULL,
	PBIsAcceptanceCriteria VARCHAR(4000) NOT NULL,
	PBIOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	PBIParentLink INT REFERENCES [SQM_GENERAL].[TBL_Features](featureId) NOT NULL,
	PBIStoryPoint INT,
	PBIStartDate DATE NULL,
	PBIDueDate DATE NULL,
	PBIPriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	PBICreationDate DATETIME NOT NULL,
	PBICreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	PBIModificationDate DATETIME NULL,
	PBIModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	PBIStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);

CREATE TABLE [SQM_CATALOGS].[TBL_ActivityTypes]
(
	activityTypeId INT PRIMARY KEY IDENTITY (1,1),
	activityTypeName VARCHAR(80) NOT NULL,
	activityTypeCreationDate DATETIME NOT NULL,
	activityTypeCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	activityTypeModificationDate DATETIME NULL,
	activityTypeModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	activityTypeEnable BIT NOT NULL
);

CREATE TABLE [SQM_GENERAL].[TBL_Tasks]
(
	taskId INT PRIMARY KEY IDENTITY (1,1),
	taskSummary VARCHAR(500) NOT NULL,
	taskDescription VARCHAR(2000) NOT NULL,
	taskOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskParentLink INT REFERENCES [SQM_GENERAL].[TBL_ProductBacklogItems](PBIId) NOT NULL,
	taskOriginalEstimate DECIMAL(4,2) NULL, --5
	taskCompletedWork DECIMAL(4,2) NULL, --6
	taskRemaningWork DECIMAL(4,2) NULL,
	taskStartDate DATE NULL,
	taskCompletedDate DATE NULL,
	taskDueDate DATE NULL,
	taskActivityType INT REFERENCES [SQM_CATALOGS].[TBL_ActivityTypes] (activityTypeId),
	taskCreationDate DATETIME NOT NULL,
	taskCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskModificationDate DATETIME NULL,
	taskModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	taskStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);

CREATE TABLE [SQM_GENERAL].[TBL_TaskComments]
(
	taskCommentId INT PRIMARY KEY IDENTITY (1,1),
	taskCommentParentLink INT REFERENCES [SQM_GENERAL].[TBL_Tasks](TaskId) NOT NULL,
	taskCommentOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskCommentText NVARCHAR(4000) NOT NULL,
	taskCommentCreationDate DATETIME NOT NULL,
	taskCommentCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskCommentModificationDate DATETIME NULL,
	taskCommentModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	taskCommentStatus BIT NOT NULL
);