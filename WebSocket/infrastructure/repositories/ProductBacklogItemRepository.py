from infrastructure.database.connection import get_connection
from domain.entities.ProductBacklogItemsModels import ProductBacklogItemCreate, ProductBacklogItemUpdate

class ProductBacklogItemRepository:
    def insert_pbi(self, pbi: ProductBacklogItemCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_ProductBacklogItems]
                @i_PBISummary = ?,
                @i_PBIDescription = ?,
                @i_PBIsAcceptanceCriteria = ?,
                @i_PBIOwner = ?,
                @i_PBIParentLink = ?,
                @i_PBIStoryPoint = ?,
                @i_PBIStartDate = ?,
                @i_PBIDueDate = ?,
                @i_PBIPriority = ?,
                @i_PBICreatorId = ?,
                @i_PBIStatus = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            pbi.PBISummary,
            pbi.PBIDescription,
            pbi.PBIsAcceptanceCriteria,
            pbi.PBIOwner,
            pbi.PBIParentLink,
            pbi.PBIStoryPoint,
            pbi.PBIStartDate,
            pbi.PBIDueDate,
            pbi.PBIPriority,
            pbi.PBICreatorId,
            pbi.PBIStatus,
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

    def update_pbi(self, pbi: ProductBacklogItemUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_ProductBacklogItems]
                @i_PBIId = ?,
                @i_PBISummary = ?,
                @i_PBIDescription = ?,
                @i_PBIsAcceptanceCriteria = ?,
                @i_PBIOwner = ?,
                @i_PBIParentLink = ?,
                @i_PBIStoryPoint = ?,
                @i_PBIStartDate = ?,
                @i_PBIDueDate = ?,
                @i_PBIPriority = ?,
                @i_PBIModificatorId = ?,
                @i_PBIStatus = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            pbi.PBIId,
            pbi.PBISummary,
            pbi.PBIDescription,
            pbi.PBIsAcceptanceCriteria,
            pbi.PBIOwner,
            pbi.PBIParentLink,
            pbi.PBIStoryPoint,
            pbi.PBIStartDate,
            pbi.PBIDueDate,
            pbi.PBIPriority,
            pbi.PBIModificatorId,
            pbi.PBIStatus,
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

    def list_pbis(self, page_number: int = 1, rows_per_page: int = 10):
        """
        Lista todos los PBIs paginados (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_ProductBacklogItems]
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
        