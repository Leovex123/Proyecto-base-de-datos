from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# Modelo base de Prioridades
class PriorityBase(BaseModel):
    priorityId: int
    priorityName: str
    priorityCreationDate: datetime
    priorityCreatorId: Optional[int] = None
    priorityModificationDate: Optional[datetime] = None
    priorityModificatorId: Optional[int] = None
    priorityEnable: bool

# Modelo para creacion de Prioridades
class PriorityCreate(BaseModel):
    priorityName: str
    priorityCreatorId: Optional[int] = None

# Modelo para actualizacion de Prioridades
class PriorityUpdate(BaseModel):
    priorityId: int
    priorityName: Optional[str] = None
    priorityModificationDate: Optional[datetime] = None
    priorityModificatorId: int
    priorityEnable: Optional[bool] = None

class LtsPriorities(BaseModel):
    priorities: List[PriorityBase]