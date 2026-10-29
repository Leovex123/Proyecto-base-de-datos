from infrastructure.database.connection import get_connection
from domain.entities.TaskCommentsModels import TaskCommentCreate, TaskCommentUpdate

class TaskCommentRepository:
    def insert_task_comment(self, comment: TaskCommentCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_TaskComments]
                @i_taskCommentParentLink = ?,
                @i_taskCommentOwner = ?,
                @i_taskCommentText = ?,
                @i_taskCommentCreatorId = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            comment.taskCommentParentLink,
            comment.taskCommentOwner,
            comment.taskCommentText,
            comment.taskCommentCreatorId,
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

    def update_task_comment(self, comment: TaskCommentUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_TaskComments]
                @i_taskCommentId = ?,
                @i_taskCommentParentLink = ?,
                @i_taskCommentOwner = ?,
                @i_taskCommentText = ?,
                @i_taskCommentModificatorId = ?,
                @i_taskCommentStatus = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            comment.taskCommentId,
            comment.taskCommentParentLink,
            comment.taskCommentOwner,
            comment.taskCommentText,
            comment.taskCommentModificatorId,
            comment.taskCommentStatus,
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

    def list_task_comments(self, page_number: int = 1, rows_per_page: int = 10):
        """
        Lista todos los comentarios de tareas paginados (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_TaskComments]
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