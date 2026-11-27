from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List

# Modelo base de Product Backlog Items (PBI)
class ProductBacklogItemBase(BaseModel):
    PBIId: int
    PBISummary: str
    PBIDescription: str
    PBIsAcceptanceCriteria: str
    PBIOwner: int
    PBIParentLink: int
    PBIStoryPoint: Optional[int] = None
    PBIStartDate: Optional[date] = None
    PBIDueDate: Optional[date] = None
    PBIPriority: Optional[int] = None
    PBICreationDate: datetime
    PBICreatorId: Optional[int] = None
    PBIModificationDate: Optional[datetime] = None
    PBIModificatorId: Optional[int] = None
    PBIStatus: int

# Modelo para creacion de PBI
class ProductBacklogItemCreate(BaseModel):
    PBISummary: str
    PBIDescription: str
    PBIsAcceptanceCriteria: str
    PBIOwner: int
    PBIParentLink: int
    PBIStoryPoint: Optional[int] = None
    PBIStartDate: Optional[date] = None
    PBIDueDate: Optional[date] = None
    PBIPriority: Optional[int] = None
    PBICreatorId: Optional[int] = None
    PBIStatus: int

# Modelo para actualizacion de PBI
class ProductBacklogItemUpdate(BaseModel):
    PBIId: int
    PBISummary: Optional[str] = None
    PBIDescription: Optional[str] = None
    PBIsAcceptanceCriteria: Optional[str] = None
    PBIOwner: Optional[int] = None
    PBIParentLink: Optional[int] = None
    PBIStoryPoint: Optional[int] = None
    PBIStartDate: Optional[date] = None
    PBIDueDate: Optional[date] = None
    PBIPriority: Optional[int] = None
    PBIModificationDate: Optional[datetime] = None
    PBIModificatorId: int
    PBIStatus: Optional[int] = None

class LtsProductBacklogItems(BaseModel):
    productBacklogItems: List[ProductBacklogItemBase]