# [PGO](https://github.com/CrunchyData/postgres-operator), Crunchy [Postgres Operator](https://github.com/CrunchyData/postgres-operator) Examples

This repository contains examples for deploying PGO, the Postgres Operator from Crunchy Data, using a variety of examples.

The examples are grouped by various tools that can be used to deploy them.

The best way to get started is to fork this repository and experiment with the examples.

Each of the examples has its own README that guides you through the process of deploying it.

You can find the full [PGO documentation](https://access.crunchydata.com/documentation/postgres-operator/v5/) for the project here:

[https://access.crunchydata.com/documentation/postgres-operator/v5/](https://access.crunchydata.com/documentation/postgres-operator/v5/)

You can find out more information about [PGO](https://github.com/CrunchyData/postgres-operator), the [Postgres Operator](https://github.com/CrunchyData/postgres-operator) from [Crunchy Data](https://www.crunchydata.com) at the project page:

[https://github.com/CrunchyData/postgres-operator](https://github.com/CrunchyData/postgres-operator)

# UofD Notes

## Pull Images.

See the script 'b'.  Edit the files listed and obtain the image
names after a fresh pull.  Add them to the 'b' script and pull them
all.  Change the repository names to use captain.escs.udel.edu:5000
and add the imagePullSecrets wheere necessary.

Run the script to pull the images and tag them locally.  If you do
not do this correctly, you won't be able to start the pods because
we won't be able to access the crunchy repository.  Besides, we
do not really want to be pulling images from a public repository
except once.

If needed, find captain-regcreds-secrets.yaml and apply it to the
postgres-operator namespace.  If you do not do this, the operator
will not be able to pull its images.

## Notes

If this project ever really gets a Dockerfile, then we will have to
change the 'b' script.  Right now, Dockerfile is in .gitignore.
