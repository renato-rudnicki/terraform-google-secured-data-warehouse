# Flex Templates Samples

These are Dataflow [Flex Template](https://cloud.google.com/dataflow/docs/guides/templates/using-flex-templates) samples that can be used to validate the flow of data in the Data Warehouse Secure Blueprint.

In this folder we have:

- A [terraform infrastructure script](./template-artifact-storage) to create a pair of a Docker Artifact Registry Repository and a Google Cloud Storage Bucket to store the flex template and a Python Artifact Registry Repository to host modules needed by the Python flex template when tey are staged by dataflow.
- A folder for [Java](./java/) code samples for de-identification and re-identification
- A folder for [Python](./python/) code samples for de-identification and re-identification
- In the Python folder we also have a [Cloud build file](./python/modules/cloudbuild.yaml) to populate the Python Artifact Registry Repository.

The Data Warehouse Secure Blueprint main module [creates](../README.md#outputs) a user-managed Dataflow [controller service account](https://cloud.google.com/dataflow/docs/concepts/security-and-permissions#specifying_a_user-managed_worker_service_account).
This service account is used to stage and run the Dataflow job.

To be able to deploy this Flex template you need to grant to the Dataflow controller service account the following roles in the resources create in the infrastructure script:

- Artifact Registry Reader (`roles/artifactregistry.reader`) in the Artifact Registry Repository,
- Storage Object Viewer (`roles/storage.objectViewer`) in the Storage Bucket.