from py.weaviate_operations import WeaviateOperations
from weaviate.classes.config import Property, DataType, Configure

""" with WeaviateOperations() as w_client:
    client = w_client.start()
    client.collections.create(
        name="Template",
        vectorizer_config=Configure.Vectorizer.text2vec_openai(
            model="text-embedding-3-large",
            dimensions=3072,
        ),
        multi_tenancy_config=Configure.multi_tenancy(enabled=True),
        properties=[
            Property(
                name="title", data_type=DataType.TEXT, vectorize_property_name=False
            ),
            Property(
                name="text", data_type=DataType.TEXT, vectorize_property_name=False
            ),
            Property(
                name="brief_description",
                data_type=DataType.TEXT,
                vectorize_property_name=False,
            ),
        ],
    ) """

# Fetch all objects from Template collection
""" with WeaviateOperations() as w_client:
    client = w_client.start()
    template = client.collections.get("Template")
    tenant = template.with_tenant("lawli")
    response = tenant.query.fetch_objects(
        return_properties=["title", "brief_description"]
    )
    print(response) """

# Delete Template collection
""" with WeaviateOperations() as w_client:
    client = w_client.start()
    client.collections.delete("Template") """

# Vector search Template collection
with WeaviateOperations() as w_client:
    client = w_client.start()
    template = client.collections.get("Template")
    tenant = template.with_tenant("lawli")
    response = tenant.query.near_text(query="decreto", limit=5)
    objects = response.objects
    for o in objects:
        print(o.properties["title"])
