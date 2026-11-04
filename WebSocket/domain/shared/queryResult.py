from dataclasses import dataclass

@dataclass
class QueryResult:
    status_code: int
    message_user: str
    message_tech: str | None
    data: list[dict]