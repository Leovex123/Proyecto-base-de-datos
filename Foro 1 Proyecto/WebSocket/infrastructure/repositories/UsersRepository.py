from infrastructure.database.connection import get_connection
from domain.entities.UserModels import UserCreate,UserUpdate

class UserRepository:
    def insert_user(self, user: UserCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_Mensaje = ""

        cursor.execute("""
            EXEC [SQM_SECURITY].[USP_Users]
                @i_userFullName = ?,
                @i_userName = ?,
                @i_userPassword = ?,
                @i_userRolId = ?,
                @i_userCreatorId = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_Mensaje = ? OUTPUT
        """, (
            user.userFullName,
            user.userName,
            user.userPassword,
            user.userRolId,
            user.userCreatorId,
            o_Numero,
            o_Mensaje
        ))

        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {"status_code": result[0] if result else o_Numero,
                "message": result[1] if result else o_Mensaje}

    def update_user(self, user: UserUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_Mensaje = ""

        cursor.execute("""
            EXEC [SQM_SECURITY].[USP_Users]
                @i_userId = ?,
                @i_userFullName = ?,
                @i_userName = ?,
                @i_userPassword = ?,
                @i_userRolId = ?,
                @i_userModificatorId = NULL,
                @i_userEnable = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_Mensaje = ? OUTPUT
        """, (
            user.userId,
            user.userFullName,
            user.userName,
            user.userPassword,
            user.userRolId,
            user.userEnable,
            user.userModificatorId,
            o_Numero,
            o_Mensaje
        ))

        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {"status_code": result[0] if result else o_Numero,
                "message": result[1] if result else o_Mensaje}

    def list_users(self):
        """
        Lista todos los usuarios (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_Mensaje = ""

        cursor.execute("""
            EXEC [SQM_SECURITY].[USP_Users]
                @w_Accion = 'S',
                @o_Numero = ? OUTPUT,
                @o_Mensaje = ? OUTPUT
        """, (o_Numero, o_Mensaje))

        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]

        conn.commit()
        cursor.close()
        conn.close()

        return {"status_code": o_Numero, "message": o_Mensaje, "data": data}
