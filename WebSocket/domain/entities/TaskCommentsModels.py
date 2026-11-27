from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

# Modelo base de Comentarios de Tarea
class TaskCommentBase(BaseModel):
    taskCommentId: int
    taskCommentParentLink: int
    taskCommentOwner: int
    taskCommentText: str
    taskCommentCreationDate: datetime
    taskCommentCreatorId: Optional[int] = None
    taskCommentModificationDate: Optional[datetime] = None
    taskCommentModificatorId: Optional[int] = None
    taskCommentStatus: bool

# Modelo para creacion de Comentarios de Tarea
class TaskCommentCreate(BaseModel):
    taskCommentParentLink: int
    taskCommentOwner: int
    taskCommentText: str
    taskCommentCreatorId: Optional[int] = None

# Modelo para actualizacion de Comentarios de Tarea
class TaskCommentUpdate(BaseModel):
    taskCommentId: int
    taskCommentParentLink: Optional[int] = None
    taskCommentOwner: Optional[int] = None
    taskCommentText: Optional[str] = None
    taskCommentModificationDate: Optional[datetime] = None
    taskCommentModificatorId: int
    taskCommentStatus: Optional[bool] = None

class LtsTaskComments(BaseModel):
    taskComments: List[TaskCommentBase]