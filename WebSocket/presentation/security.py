import os
from datetime import datetime, timedelta, timezone
from typing import Annotated

import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jwt import InvalidTokenError


bearer_scheme = HTTPBearer(auto_error=False)
AUTH_CONFIG_ERROR = "La autenticación no está configurada correctamente."

# SOLO PRUEBAS: reemplazar estos valores antes de desplegar en producción.
TEST_JWT_SECRET = "DEV_ONLY_REPLACE_BEFORE_PRODUCTION_32_CHARS_MINIMUM"
TEST_ADMIN_ROLE_ID = 1


def _jwt_secret() -> str:
    secret = os.getenv("JWT_SECRET_KEY", TEST_JWT_SECRET)
    if not secret or len(secret) < 32:
        raise HTTPException(
            status_code=503,
            detail=AUTH_CONFIG_ERROR
        )
    return secret


def create_access_token(user_id: int, user_name: str, role_id: int) -> str:
    try:
        expires_minutes = int(os.getenv("JWT_EXPIRE_MINUTES", "30"))
    except ValueError as exc:
        raise HTTPException(
            status_code=503,
            detail=AUTH_CONFIG_ERROR
        ) from exc

    if expires_minutes < 1:
        raise HTTPException(
            status_code=503,
            detail=AUTH_CONFIG_ERROR
        )

    now = datetime.now(timezone.utc)
    claims = {
        "sub": str(user_id),
        "name": user_name,
        "role": "user",
        "role_id": role_id,
        "iat": now,
        "exp": now + timedelta(minutes=expires_minutes)
    }
    return jwt.encode(claims, _jwt_secret(), algorithm="HS256")


def get_current_user(
    credentials: Annotated[
        HTTPAuthorizationCredentials | None,
        Depends(bearer_scheme)
    ]
) -> dict[str, int | str]:
    if credentials is None:
        raise HTTPException(
            status_code=401,
            detail="Se requiere autenticación.",
            headers={"WWW-Authenticate": "Bearer"}
        )

    try:
        claims = jwt.decode(
            credentials.credentials,
            _jwt_secret(),
            algorithms=["HS256"]
        )
        claims["sub"] = int(claims["sub"])
        claims["role_id"] = int(claims["role_id"])
        return claims
    except (InvalidTokenError, KeyError, TypeError, ValueError):
        raise HTTPException(
            status_code=401,
            detail="El token es inválido o expiró.",
            headers={"WWW-Authenticate": "Bearer"}
        ) from None


def get_admin_user(
    current_user: Annotated[dict[str, int | str], Depends(get_current_user)]
) -> dict[str, int | str]:
    try:
        admin_role_id = int(os.getenv("JWT_ADMIN_ROLE_ID", str(TEST_ADMIN_ROLE_ID)))
    except ValueError as exc:
        raise HTTPException(
            status_code=503,
            detail="La autorización administrativa no está configurada."
        ) from exc

    if current_user["role_id"] != admin_role_id:
        raise HTTPException(
            status_code=403,
            detail="No tienes permisos para esta operación."
        )
    return current_user