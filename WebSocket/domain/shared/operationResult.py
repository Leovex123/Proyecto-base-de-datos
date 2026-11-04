from dataclasses import dataclass

@dataclass
class OperationResult:
    status_code: int
    message_user: str
    message_tech: str | None = None