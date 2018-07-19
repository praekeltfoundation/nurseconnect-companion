import pytest
from seaworthy.definitions import ContainerDefinition
from seaworthy.containers.postgresql import PostgreSQLContainer

PHOENIX_IMAGE = pytest.config.getoption("--phoenix-image")


class PhoenixContainer(ContainerDefinition):
    WAIT_PATTERNS = (r"Running CompanionWeb.Endpoint",)

    def __init__(self, name, db_url, image=PHOENIX_IMAGE):
        super().__init__(name, image, self.WAIT_PATTERNS)
        self.db_url = db_url

    def base_kwargs(self):
        return {
            "ports": {
                "4000/tcp": None,
            },
            "environment": {
                "DATABASE_URL": self.db_url,
                "SECRET_KEY": "test",
            },
        }


postgresql_container = PostgreSQLContainer("postgresql")
postgresql_fixture, clean_postgresql_fixture = (
    postgresql_container.pytest_clean_fixtures("postgresql_container")
)

phoenix_container = PhoenixContainer(
    "phoenix", postgresql_container.database_url())
phoenix_fixture = phoenix_container.pytest_fixture(
    "phoenix_container", dependencies=["postgresql_container"])

__all__ = [
    "clean_postgresql_fixture",
    "phoenix_fixture",
    "postgresql_fixture",
]
