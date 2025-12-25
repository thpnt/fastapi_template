from dotenv import load_dotenv
from pydantic_settings import BaseSettings

load_dotenv()

class Settings(BaseSettings):
    app_name: str = "fastapi-template"
    debug: bool = False
    db_url: str = "sqlite:///./test.db"

settings = Settings()
