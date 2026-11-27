from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List

# Modelo base de Iniciativas
class InitiativeBase(BaseModel):
    initiativeId: int
    initiativeSummary: str
    initiativeDescription: str
    initiativeOwner: int
    initiativeGoals: Optional[str] = None
    initiativeBusinessValue: int
    initiativeTargetStart: Optional[date] = None
    initiativeTargetEnd: Optional[date] = None
    initiativeCreationDate: datetime
    initiativeCreatorId: Optional[int] = None
    initiativeModificationDate: Optional[datetime] = None
    initiativeModificatorId: Optional[int] = None
    initiativeStatus: int

# Modelo para creacion de Iniciativas
class InitiativeCreate(BaseModel):
    initiativeSummary: str
    initiativeDescription: str
    initiativeOwner: int
    initiativeGoals: Optional[str] = None
    initiativeBusinessValue: int
    initiativeTargetStart: Optional[date] = None
    initiativeTargetEnd: Optional[date] = None
    initiativeCreatorId: Optional[int] = None
    initiativeStatus: int

# Modelo para actualizacion de Iniciativas
class InitiativeUpdate(BaseModel):
    initiativeId: int
    initiativeSummary: Optional[str] = None
    initiativeDescription: Optional[str] = None
    initiativeOwner: Optional[int] = None
    initiativeGoals: Optional[str] = None
    initiativeBusinessValue: Optional[int] = None
    initiativeTargetStart: Optional[date] = None
    initiativeTargetEnd: Optional[date] = None
    initiativeModificationDate: Optional[datetime] = None
    initiativeModificatorId: int
    initiativeStatus: Optional[int] = None

class LtsInitiatives(BaseModel):
    initiatives: List[InitiativeBase]