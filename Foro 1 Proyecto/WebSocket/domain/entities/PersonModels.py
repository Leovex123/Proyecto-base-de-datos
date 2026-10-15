from pydantic import BaseModel
from datetime import datetime
from typing import Optional

# Modelo base de personas
class PersonBase(BaseModel):
    personId: int
    personFirstName: str
    personSecondName: Optional[str] = None
    personFirstSurname: str
    personSecondSurname: Optional[str] = None
    personBirthday: datetime
    personDNI: str
    personCreationDate: datetime
    personCreatorId: Optional[int] = None
    personModificationDate: Optional[datetime] = None
    personModificatorId: Optional[int] = None
    personEnable: bool

# Modelo para creacion de personas
class PersonCreate(BaseModel):
    personFirstName: str
    personSecondName: Optional[str] = None
    personFirstSurname: str
    personSecondSurname: Optional[str] = None
    personBirthday: datetime
    personDNI: str