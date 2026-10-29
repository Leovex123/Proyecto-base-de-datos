from infrastructure.database.connection import get_connection
from domain.entities.BusinessValueModels import BusinessValueCreate, BusinessValueUpdate

class BusinessValueRepository:
    def insert_business_value(self, business_value: BusinessValueCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_CATALOGS].[USP_BusinessValues]
                @i_businessValueName = ?,
                @i_businessValueCreatorId = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            business_value.businessValueName,
            business_value.businessValueCreatorId,
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

    def update_business_value(self, business_value: BusinessValueUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_CATALOGS].[USP_BusinessValues]
                @i_businessValueId = ?,
                @i_businessValueName = ?,
                @i_businessValueModificatorId = ?,
                @i_businessValueEnable = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            business_value.businessValueId,
            business_value.businessValueName,
            business_value.businessValueModificatorId,
            business_value.businessValueEnable,
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

    def list_business_values(self, page_number: int = 1, rows_per_page: int = 10):
        """
        Lista todos los valores de negocio paginados (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_CATALOGS].[USP_BusinessValues]
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