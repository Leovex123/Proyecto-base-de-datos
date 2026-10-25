from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# Modelo base de Status
class StatusBase(BaseModel):
    statusId: int
    statusName: str
    statusCreationDate: datetime
    statusCreatorId: Optional[int] = None
    statusModificationDate: Optional[datetime] = None
    statusModificatorId: Optional[int] = None
    statusEnable: bool

# Modelo para creacion de Status
class StatusCreate(BaseModel):
    statusName: str
    statusCreatorId: Optional[int] = None

# Modelo para actualizacion de Status
class StatusUpdate(BaseModel):
    statusId: int
    statusName: Optional[str] = None
    statusModificationDate: Optional[datetime] = None
    statusModificatorId: int
    statusEnable: Optional[bool] = None

class LtsStatus(BaseModel):
    status: List[StatusBase]