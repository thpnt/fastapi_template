from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.core.settings import settings

enigne = create_engine(
    settings.db_url
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=enigne)
