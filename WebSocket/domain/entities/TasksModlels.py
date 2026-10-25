from pydantic import BaseModel
from datetime import datetime, date
from decimal import Decimal
from typing import Optional, List

# Modelo base de Tareas (respetando el nombre exacto de columna taskRemaningWork)
class TaskBase(BaseModel):
    taskId: int
    taskSummary: str
    taskDescription: str
    taskOwner: int
    taskParentLink: int
    taskOriginalEstimate: Optional[Decimal] = None
    taskCompletedWork: Optional[Decimal] = None
    taskRemaningWork: Optional[Decimal] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskCreationDate: datetime
    taskCreatorId: Optional[int] = None
    taskModificationDate: Optional[datetime] = None
    taskModificatorId: Optional[int] = None
    taskStatus: int

# Modelo para creacion de Tareas
class TaskCreate(BaseModel):
    taskSummary: str
    taskDescription: str
    taskOwner: int
    taskParentLink: int
    taskOriginalEstimate: Optional[Decimal] = None
    taskCompletedWork: Optional[Decimal] = None
    taskRemaningWork: Optional[Decimal] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskCreatorId: Optional[int] = None
    taskStatus: int

# Modelo para actualizacion de Tareas
class TaskUpdate(BaseModel):
    taskId: int
    taskSummary: Optional[str] = None
    taskDescription: Optional[str] = None
    taskOwner: Optional[int] = None
    taskParentLink: Optional[int] = None
    taskOriginalEstimate: Optional[Decimal] = None
    taskCompletedWork: Optional[Decimal] = None
    taskRemaningWork: Optional[Decimal] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskModificationDate: Optional[datetime] = None
    taskModificatorId: int
    taskStatus: Optional[int] = None

class LtsTasks(BaseModel):
    tasks: List[TaskBase]