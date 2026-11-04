from application.use_cases.usersUseCase import UserUseCase
from infrastructure.repositories.usersRepository import UserRepository


def get_user_use_case() -> UserUseCase:

    repository = UserRepository()

    return UserUseCase(repository)