import weaviate
import os
from py.logger_config import LoggerConfig


class WeaviateOperations:
    """Operations on Weaviate."""

    def __init__(self, collection: str | None = None):
        self.collection = collection
        self.logger = LoggerConfig().setup_logging()
        try:
            self.client = weaviate.connect_to_wcs(
                cluster_url=os.environ.get("WEAVIATE_URL", ""),
                auth_credentials=weaviate.auth.AuthApiKey(
                    os.environ.get("WEAVIATE_APIKEY", "")
                ),
                headers={"X-OpenAI-Api-Key": os.environ.get("OPENAI_APIKEY", "")},
            )
        except weaviate.exceptions.AuthenticationFailedError as e:
            self.logger.error(f"Authentication failed: {e}")
            raise Exception(f"Authentication failed: {e}")
        except weaviate.exceptions.WeaviateConnectionError as e:
            self.logger.error(f"Connection error: {e}")
            raise Exception(f"Connection error: {e}")
        except Exception as e:
            self.logger.error(f"Generic error connecting to Weaviate: {e}")
            raise Exception(f"Generic error connecting to Weaviate: {e}")

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.client.close()

    def start(self):
        """Starts the Weaviate client so that it can be used."""
        return self.client

    def get_collections(self):
        return self.client.collections.list_all()

    def single_import(self, data: dict, tenant: str):
        self.logger.info("Single import")
        self.logger.info(f"Data: {data}")
        self.logger.info(f"Tenant: {tenant}")

        try:
            self._create_tenant(tenant)
        except Exception as e:
            self.logger.error(f"Error in create_tenant: {e}")
            raise Exception(f"Error in create_tenant: {e}")

        try:
            if self._does_template_exist(data["title"], tenant):
                self.logger.info("Template already exists")
                return
        except Exception as e:
            self.logger.error(f"Error in does_template_exist: {e}")
            raise Exception(f"Error in does_template_exist: {e}")

        try:
            if not self.collection:
                self.logger.error("Collection not set")
                raise Exception("Collection not set")
            template = self.client.collections.get(self.collection)
            template = template.with_tenant(tenant)
            uuid = template.data.insert(data)
            self.logger.info(f"UUID: {uuid}")
        except Exception as e:
            self.logger.error(f"Generic error in single_import: {e}")
            raise Exception(f"Generic error in single_import: {e}")

    # Per ora inutilizzato: solo single_import funziona. Manca _does_template_exist
    def batch_import(self, data: list[dict], tenant: str):
        self.logger.info("Batch import")
        self.logger.info(f"Data: {data}")
        self.logger.info(f"Tenant: {tenant}")
        if not self.collection:
            self.logger.error("Collection not set")
            raise Exception("Collection not set")
        try:
            template = self.client.collections.get(self.collection)
            self._create_tenant(tenant)
            template = template.with_tenant(tenant)
            with template.batch.dynamic() as batch:
                for item in data:
                    batch.add_object(
                        properties=item,
                    )
                errors = template.batch.failed_objects
                if errors:
                    self.logger.error(f"Errors: {errors}")
        except weaviate.exceptions.WeaviateBatchError as e:
            self.logger.error(f"WeaviateBatchError: {e}")
            raise Exception(f"WeaviateBatchError: {e}")
        except Exception as e:
            self.logger.error(f"Generic error in batch_import: {e}")
            raise Exception(f"Generic error in batch_import: {e}")

    def near_text(self, query: str, tenant: str | None = None, limit: int = 3) -> list:
        if not self.collection:
            self.logger.error("Collection not set")
            raise Exception("Collection not set")
        try:
            template = self.client.collections.get(self.collection)
            if tenant:
                template = template.with_tenant(tenant)
            response = template.query.near_text(query=query, limit=limit)
            objects = response.objects
            return objects
        except Exception as e:
            self.logger.error(f"Generic error in near_text: {e}")
            raise Exception(f"Generic error in near_text: {e}")

    def _create_tenant(self, tenant: str):
        """Create a tenant if it does not exist."""
        if not self.collection:
            self.logger.error("Collection not set")
            raise Exception("Collection not set")
        template = self.client.collections.get(self.collection)
        tenants = template.tenants.get()
        self.logger.info(f"Tenants: {list(tenants.keys())}")
        if tenant not in tenants:
            self.logger.info(f"Creating tenant: {tenant}")
            template.tenants.create(
                tenants=[weaviate.classes.tenants.Tenant(name=tenant)]
            )

    def _does_template_exist(self, title: str, tenant: str) -> bool:
        if not self.collection:
            self.logger.error("Collection not set")
            raise Exception("Collection not set")
        template = self.client.collections.get(self.collection)
        template = template.with_tenant(tenant)
        results = template.query.fetch_objects(return_properties=["title"])
        titles = [o.properties["title"] for o in results.objects]
        if title in titles:
            return True
        else:
            return False
