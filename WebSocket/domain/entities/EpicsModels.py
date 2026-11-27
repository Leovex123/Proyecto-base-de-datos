from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List

# Modelo base de Epicas
class EpicBase(BaseModel):
    epicId: int
    epicName: str
    epicSummary: str
    epicDescription: str
    epicParentLink: int
    epicOwner: int
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicPriority: Optional[int] = None
    epicCreationDate: datetime
    epicCreatorId: Optional[int] = None
    epicModificationDate: Optional[datetime] = None
    epicModificatorId: Optional[int] = None
    epicStatus: int

# Modelo para creacion de Epicas
class EpicCreate(BaseModel):
    epicName: str
    epicSummary: str
    epicDescription: str
    epicParentLink: int
    epicOwner: int
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicPriority: Optional[int] = None
    epicCreatorId: Optional[int] = None
    epicStatus: int

# Modelo para actualizacion de Epicas
class EpicUpdate(BaseModel):
    epicId: int
    epicName: Optional[str] = None
    epicSummary: Optional[str] = None
    epicDescription: Optional[str] = None
    epicParentLink: Optional[int] = None
    epicOwner: Optional[int] = None
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicPriority: Optional[int] = None
    epicModificationDate: Optional[datetime] = None
    epicModificatorId: int
    epicStatus: Optional[int] = None

class LtsEpics(BaseModel):
    epics: List[EpicBase]