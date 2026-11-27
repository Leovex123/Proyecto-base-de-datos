from infrastructure.database.connection import get_connection
from domain.entities.EpicModels import EpicCreate, EpicUpdate

class EpicRepository:
    def insert_epic(self, epic: EpicCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Epics]
                @i_epicName = ?,
                @i_epicSummary = ?,
                @i_epicDescription = ?,
                @i_epicParentLink = ?,
                @i_epicOwner = ?,
                @i_epicStartDate = ?,
                @i_epicDueDate = ?,
                @i_epicPriority = ?,
                @i_epicCreatorId = ?,
                @i_epicStatus = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            epic.epicName,
            epic.epicSummary,
            epic.epicDescription,
            epic.epicParentLink,
            epic.epicOwner,
            epic.epicStartDate,
            epic.epicDueDate,
            epic.epicPriority,
            epic.epicCreatorId,
            epic.epicStatus,
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {"status_code": result[0] if result else o_Numero,
                "message": result[2] if result else o_MensajeUsuario}

    def update_epic(self, epic: EpicUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Epics]
                @i_epicId = ?,
                @i_epicName = ?,
                @i_epicSummary = ?,
                @i_epicDescription = ?,
                @i_epicParentLink = ?,
                @i_epicOwner = ?,
                @i_epicStartDate = ?,
                @i_epicDueDate = ?,
                @i_epicPriority = ?,
                @i_epicModificatorId = ?,
                @i_epicStatus = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            epic.epicId,
            epic.epicName,
            epic.epicSummary,
            epic.epicDescription,
            epic.epicParentLink,
            epic.epicOwner,
            epic.epicStartDate,
            epic.epicDueDate,
            epic.epicPriority,
            epic.epicModificatorId,
            epic.epicStatus,
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {"status_code": result[0] if result else o_Numero,
                "message": result[2] if result else o_MensajeUsuario}

    def list_epics(self, page_number: int = 1, rows_per_page: int = 10):
        """
        Lista todas las épicas paginadas (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Epics]
                @i_PageNumber = ?,
                @i_RowsPerPage = ?,
                @w_Accion = 'S',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (page_number, rows_per_page, o_Numero, o_MensajeTecnico, o_MensajeUsuario))

        columns = [col[0] for col in cursor.description] if cursor.description else []
        data = [dict(zip(columns, row)) for row in cursor.fetchall()] if columns else []

        conn.commit()
        cursor.close()
        conn.close()

        return {"status_code": o_Numero, "message": o_MensajeUsuario, "data": data}