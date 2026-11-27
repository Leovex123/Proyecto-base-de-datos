from domain.entities.UserModels import UserCreate, UserLogin, UserUpdate
from domain.interfaces.IusersRepository import IUserRepository


class UserUseCase:

    def __init__(
        self,
        repository: IUserRepository
    ):
        self.repository = repository

    def create_user(self, user: UserCreate, creator_id: int):
        return self.repository.insert_user(user, creator_id)

    def update_user(self, user: UserUpdate, modificator_id: int):
        return self.repository.update_user(user, modificator_id)

    def authenticate_user(self, user: UserLogin):
        return self.repository.authenticate_user(user)

    def list_users(
        self,
        page_number: int,
        rows_per_page: int
    ):
        return self.repository.list_users(
            page_number=page_number,
            rows_per_page=rows_per_page
        )




