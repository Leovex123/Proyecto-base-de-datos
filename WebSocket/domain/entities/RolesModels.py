from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# Modelo base de Roles
class RolBase(BaseModel):
    rolId: int
    rolName: str
    rolCreationDate: datetime
    rolCreatorId: Optional[int] = None
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: Optional[int] = None
    rolEnable: bool

# Modelo para creacion de Roles
class RolCreate(BaseModel):
    rolName: str
    rolCreatorId: Optional[int] = None

# Modelo para actualizacion de Roles
class RolUpdate(BaseModel):
    rolId: int
    rolName: Optional[str] = None
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: int
    rolEnable: Optional[bool] = None

class LtsRoles(BaseModel):
    roles: List[RolBase]