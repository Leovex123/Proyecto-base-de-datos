from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# Modelo base de Valores de Negocio
class BusinessValueBase(BaseModel):
    businessValueId: int
    businessValueName: str
    businessValueCreationDate: datetime
    businessValueCreatorId: Optional[int] = None
    businessValueModificationDate: Optional[datetime] = None
    businessValueModificatorId: Optional[int] = None
    businessValueEnable: bool

# Modelo para creacion de Valores de Negocio
class BusinessValueCreate(BaseModel):
    businessValueName: str
    businessValueCreatorId: Optional[int] = None

# Modelo para actualizacion de Valores de Negocio
class BusinessValueUpdate(BaseModel):
    businessValueId: int
    businessValueName: Optional[str] = None
    businessValueModificationDate: Optional[datetime] = None
    businessValueModificatorId: int
    businessValueEnable: Optional[bool] = None

class LtsBusinessValues(BaseModel):
    businessValues: List[BusinessValueBase]