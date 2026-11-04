import os

import pyodbc

def get_connection():
    user = os.getenv("DB_USER", "WebSocket")
    password = os.getenv("DB_PASSWORD", "12345678")

    return pyodbc.connect(
        f"DRIVER={{{os.getenv('DB_DRIVER', 'ODBC Driver 17 for SQL Server')}}};"
        f"SERVER={os.getenv('DB_SERVER', 'localhost')};"
        f"DATABASE={os.getenv('DB_NAME', 'DB_SCRUM_PLANNING')};"
        f"UID={user};"
        f"PWD={password};"
        f"Encrypt={os.getenv('DB_ENCRYPT', 'yes')};"
        f"TrustServerCertificate={os.getenv('DB_TRUST_SERVER_CERTIFICATE', 'yes')};"
    )