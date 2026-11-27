from domain.entities.UserModels import UserCreate, UserLogin, UserUpdate
from domain.interfaces.IusersRepository import IUserRepository
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class UserRepository(BaseRepository, IUserRepository):
    SP_NAME = "[SQM_SECURITY].[USP_Users]"

    def insert_user(
        self,
        user: UserCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_userFullName = ?,
                @i_userName = ?,
                @i_userEmail = ?,
                @i_userPassword = ?,
                @i_userRolId = ?,
                @i_userCreatorId = ?,
                @w_Accion = 'I'
            """,
            (
                user.userFullName,
                user.userName,
                user.userEmail,
                user.userPassword,
                user.userRolId,
                creator_id
            )
        )

    def update_user(
        self,
        user: UserUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_userId = ?,
                @i_userFullName = ?,
                @i_userName = ?,
                @i_userEmail = ?,
                @i_userPassword = ?,
                @i_userRolId = ?,
                @i_userModificatorId = ?,
                @i_userEnable = ?,
                @w_Accion = 'U'
            """,
            (
                user.userId,
                user.userFullName,
                user.userName,
                user.userEmail,
                user.userPassword,
                user.userRolId,
                modificator_id,
                user.userEnable
            )
        )

    def authenticate_user(self, user: UserLogin) -> QueryResult:
        return self.execute_query(
            f"""
            EXEC {self.SP_NAME}
                @i_userName = ?,
                @i_userPassword = ?,
                @w_Accion = 'L'
            """,
            (user.userName, user.userPassword)
        )

    def list_users(
        self,
        page_number: int = 1,
        rows_per_page: int = 10
    ) -> QueryResult:

        return self.execute_query(
            f"""
            EXEC {self.SP_NAME}
                @i_PageNumber = ?,
                @i_RowsPerPage = ?,
                @w_Accion = 'S'
            """,
            (
                page_number,
                rows_per_page
            )
        )



