from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# Modelo base de Tipos de Actividad
class ActivityTypeBase(BaseModel):
    activityTypeId: int
    activityTypeName: str
    activityTypeCreationDate: datetime
    activityTypeCreatorId: Optional[int] = None
    activityTypeModificationDate: Optional[datetime] = None
    activityTypeModificatorId: Optional[int] = None
    activityTypeEnable: bool

# Modelo para creacion de Tipos de Actividad
class ActivityTypeCreate(BaseModel):
    activityTypeName: str
    activityTypeCreatorId: Optional[int] = None

# Modelo para actualizacion de Tipos de Actividad
class ActivityTypeUpdate(BaseModel):
    activityTypeId: int
    activityTypeName: Optional[str] = None
    activityTypeModificationDate: Optional[datetime] = None
    activityTypeModificatorId: int
    activityTypeEnable: Optional[bool] = None

class LtsActivityTypes(BaseModel):
    activityTypes: List[ActivityTypeBase]