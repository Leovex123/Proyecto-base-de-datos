from abc import ABC, abstractmethod

from domain.entities.UserModels import UserCreate, UserLogin, UserUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IUserRepository(ABC):

    @abstractmethod
    def insert_user(
        self,
        user: UserCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra un nuevo usuario.
        """
        raise NotImplementedError

    @abstractmethod
    def update_user(
        self,
        user: UserUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza un usuario existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_users(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene usuarios paginados.
        """
        raise NotImplementedError

    @abstractmethod
    def authenticate_user(
        self,
        user: UserLogin
    ) -> QueryResult:
        """Autentica un usuario y devuelve sus datos no sensibles."""
        raise NotImplementedError


