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

## Useful commands:

### Login to the database grouper-prod.

```
DB=grouper-prod
kubectl exec -it -n postgres-operator -c database   $(kubectl get pods -n postgres-operator --selector='postgres-operator.crunchydata.com/cluster='${DB}',postgres-operator.crunchydata.com/role=master' -o name) -- psql
```

```
kubectl -n postgres-operator get svc --selector=postgres-operator.crunchydata.com/cluster=grouper-prod
```

### Take a pg_dumpall Dump

This type of dump will generate SQL output that can be fed back into psql.

```
DB=grouper-prod
kubectl exec -i -n postgres-operator -c database   $(kubectl get pods -n postgres-operator --selector='postgres-operator.crunchydata.com/cluster='${DB}',postgres-operator.crunchydata.com/role=master' -o name) -- pg_dumpall | gzip > ${DB}-dump-`date +'%Y-%m-%dT%H:%M:%S'`.gz
```

### Restore a dump

This will restore a logical dump.  You probably want to set replicas on the cluster to one, first.  There is not much point in generating and saving all that
WAL data.

Consider the following:

```
postgres=# show archive_command ;
             archive_command
------------------------------------------
 pgbackrest --stanza=db archive-push "%p"
```

Save in a notes file the archive_command and then set it to nothing.



```
DB=grouper-prod
zcat the-dump-file.gz | kubectl exec -i -n postgres-operator -c database   $(kubectl get pods -n postgres-operator --selector='postgres-operator.crunchydata.com/cluster='${DB}',postgres-operator.crunchydata.com/role=master' -o name) -- psql | gzip > ${DB}-dump-`date +'%Y-%m-%dT%H:%M:%S'`.gz
```

NOTE: if you have running pods, you can get the logs of any one of them and they will tell you process leader.  There are other ways to get it, too.
Make sure you are careful and not running replicas and WAL archiving when doing this.  It is possible to generate enough IO to kill a NetApp.

### What You might not want to see:

```
kubectl get statefulsets -n postgres-operator

kubectl get statefulsets grouper-prod-instance1-b297 -n postgres-operator -o yaml
```

### Viewing a Database State

This is for database grouper_prod

```
kubectl -n postgres-operator get pods \
  --selector=postgres-operator.crunchydata.com/cluster=grouper-prod,postgres-operator.crunchydata.com/instance
```

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

## PVs

The persistent volume resources are defined in the pvs/ directory.

## Databases

To create, for instance, grouper-prod:

```
kubectl apply -k grouper-prod
```

## Notes

If this project ever really gets a Dockerfile, then we will have to
change the 'b' script.  Right now, Dockerfile is in .gitignore.
