import logging
from typing import Annotated

from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import Query

from application.use_cases.usersUseCase import UserUseCase
from domain.entities.userModels import UserCreate, UserLogin, UserUpdate

from infrastructure.repositories.usersRepository import UserRepository
from presentation.security import create_access_token, get_admin_user

from presentation.states.generic_states import (
    OperationResponse,
    QueryResponse,
    TokenResponse
)


router = APIRouter(
    prefix="/websocket/users",
    tags=["Users"]
)
logger = logging.getLogger(__name__)


def get_user_use_case() -> UserUseCase:
    return UserUseCase(
        UserRepository()
    )


UserUseCaseDep = Annotated[
    UserUseCase,
    Depends(get_user_use_case)
]
AdminUserDep = Annotated[dict[str, int | str], Depends(get_admin_user)]


@router.post(
    "/authenticate",
    response_model=TokenResponse
)
def login(
    credentials: UserLogin,
    use_case: UserUseCaseDep
):
    result = use_case.authenticate_user(credentials)

    if result.status_code == 200 and not result.data:
        raise HTTPException(
            status_code=500,
            detail="Respuesta inconsistente del procedimiento de autenticación."
        )

    if result.status_code != 200:
        status_code = result.status_code if result.status_code >= 400 else 500
        raise HTTPException(
            status_code=status_code,
            detail=result.message_user,
            headers={"WWW-Authenticate": "Bearer"} if status_code == 401 else None
        )

    user = result.data[0]
    return TokenResponse(
        access_token=create_access_token(
            user_id=int(user["userId"]),
            user_name=str(user["userName"]),
            role_id=int(user["userRolId"])
        ),
        message_user=result.message_user
    )

@router.post(
    "/create",
    response_model=OperationResponse,
    status_code=201
)
def create_user(
    user: UserCreate,
    use_case: UserUseCaseDep,
    admin_user: AdminUserDep
):

    result = use_case.create_user(user, int(admin_user["sub"]))

    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return result

@router.put(
    "/update",
    response_model=OperationResponse
)
def update_user(
    user: UserUpdate,
    use_case: UserUseCaseDep,
    admin_user: AdminUserDep
):

    result = use_case.update_user(user, int(admin_user["sub"]))

    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return result

@router.get(
    "/list",
    response_model=QueryResponse
)
def list_users(
    use_case: UserUseCaseDep,
    admin_user: AdminUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):

    result = use_case.list_users(
        page_number=page_number,
        rows_per_page=rows_per_page
    )
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )
    return result