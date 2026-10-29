from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List

from domain.entities.ActivityTypesModels import ActivityTypeCreate, ActivityTypeUpdate
from domain.entities.BusinessValuesModels import BusinessValueCreate, BusinessValueUpdate
from domain.entities.EpicsModels import EpicCreate, EpicUpdate
from domain.entities.FeaturesModels import FeatureCreate, FeatureUpdate
from domain.entities.InitiativesModels import InitiativeCreate, InitiativeUpdate
from domain.entities.PrioritiesModels import PriorityCreate, PriorityUpdate
from domain.entities.ProductBacklogItemsModels import ProductBacklogItemCreate, ProductBacklogItemUpdate
from domain.entities.RolesModels import RolCreate, RolUpdate
from domain.entities.StatusModels import StatusCreate, StatusUpdate
from domain.entities.TaskCommentsModels import TaskCommentCreate, TaskCommentUpdate
from domain.entities.TasksModels import TaskCreate, TaskUpdate
from domain.entities.UserModels import UserCreate, UserUpdate

from infrastructure.repositories.ActivityTypeRepository import ActivityTypeRepository
from infrastructure.repositories.BusinessValuesRepository import BusinessValueRepository
from infrastructure.repositories.EpicRepository import EpicRepository
from infrastructure.repositories.FeatureRepository import FeatureRepository
from infrastructure.repositories.InitiativesRepository import InitiativeRepository
from infrastructure.repositories.PrioritiesRepository import PriorityRepository
from infrastructure.repositories.ProductBacklogItemRepository import ProductBacklogItemRepository
from infrastructure.repositories.RolRepository import RolRepository
from infrastructure.repositories.StatusRepository import StatusRepository
from infrastructure.repositories.TaskCommentRepository import TaskCommentRepository
from infrastructure.repositories.TaskRepository import TaskRepository
from infrastructure.repositories.UsersRepository import UserRepository

app = FastAPI(title="SCRUM Planning WebSocket")

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)

    async def broadcast(self, message: dict):
        for connection in self.active_connections:
            await connection.send_json(message)

manager = ConnectionManager()

HANDLERS = {
    "users": (UserRepository(), "insert_user", UserCreate, "update_user", UserUpdate, "list_users"),
    "roles": (RolRepository(), "insert_rol", RolCreate, "update_rol", RolUpdate, "list_roles"),
    "status": (StatusRepository(), "insert_status", StatusCreate, "update_status", StatusUpdate, "list_status"),
    "business_values": (BusinessValueRepository(), "insert_business_value", BusinessValueCreate, "update_business_value", BusinessValueUpdate, "list_business_values"),
    "initiatives": (InitiativeRepository(), "insert_initiative", InitiativeCreate, "update_initiative", InitiativeUpdate, "list_initiatives"),
    "priorities": (PriorityRepository(), "insert_priority", PriorityCreate, "update_priority", PriorityUpdate, "list_priorities"),
    "epics": (EpicRepository(), "insert_epic", EpicCreate, "update_epic", EpicUpdate, "list_epics"),
    "features": (FeatureRepository(), "insert_feature", FeatureCreate, "update_feature", FeatureUpdate, "list_features"),
    "pbis": (ProductBacklogItemRepository(), "insert_pbi", ProductBacklogItemCreate, "update_pbi", ProductBacklogItemUpdate, "list_pbis"),
    "activity_types": (ActivityTypeRepository(), "insert_activity_type", ActivityTypeCreate, "update_activity_type", ActivityTypeUpdate, "list_activity_types"),
    "tasks": (TaskRepository(), "insert_task", TaskCreate, "update_task", TaskUpdate, "list_tasks"),
    "task_comments": (TaskCommentRepository(), "insert_task_comment", TaskCommentCreate, "update_task_comment", TaskCommentUpdate, "list_task_comments"),
}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            payload = await websocket.receive_json()
            entity = payload.get("entity")
            action = payload.get("action")
            data = payload.get("data", {})

            if entity not in HANDLERS:
                await websocket.send_json({"status_code": 400, "message": f"Entidad '{entity}' no válida"})
                continue

            repo, ins_method, ins_model, upd_method, upd_model, list_method = HANDLERS[entity]

            try:
                if action == "I":
                    model_instance = ins_model(**data)
                    result = getattr(repo, ins_method)(model_instance)
                    await manager.broadcast({"entity": entity, "action": "I", "response": result})
                elif action == "U":
                    model_instance = upd_model(**data)
                    result = getattr(repo, upd_method)(model_instance)
                    await manager.broadcast({"entity": entity, "action": "U", "response": result})
                elif action == "S":
                    result = getattr(repo, list_method)()
                    await websocket.send_json({"entity": entity, "action": "S", "response": result})
                else:
                    await websocket.send_json({"status_code": 405, "message": "Acción no habilitada (use I, U o S)"})
            except Exception as e:
                await websocket.send_json({"status_code": 500, "message": str(e)})

    except WebSocketDisconnect:
        manager.disconnect(websocket)