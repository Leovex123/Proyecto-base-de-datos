from pydantic import BaseModel
from typing import Any


class OperationResponse(BaseModel):
    status_code: int
    message_user: str


class QueryResponse(OperationResponse):
    data: list[dict[str, Any]]


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    message_user: str