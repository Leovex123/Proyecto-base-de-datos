from fastapi import FastAPI

from presentation.controllers.users_controller import router as users_router


app = FastAPI(
    title="Scrum Planning API",
    version="1.0.0"
)


app.include_router(users_router)