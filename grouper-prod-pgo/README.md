# Grouper-prod-pgo Crunchy Postgres Operator Installation

This directory contains the resource files to create the
grouper-prod-pgo Crunchy Postgres installtion.o

The [main](https://access.crunchydata.com/documentation/postgres-operator/latest/) documentation
is hosted at Crunchy.  Make sure you are looking at *latest* or *version 5* documents.  They
changed a lot between version four and five.  There no longer is a **pgo** command, so do not
spend time looking for it.  Everything is done with kubectl, and generally declarative.

## Create the Namespace

```
kubectl apply -f grouper-prod-pgo-ns.yaml
```

This creates the namespace and sets up the basic IP pool
we will use.

## Check the Namespace

You might want to check file `kustomization.yaml`.  This is
where the namespace name is set.  It should match what
you created in the prior step.

## Apply Network policy

We need to apply a network policy that lets the pods talk
to each other and decide what access the outside world
gets into our service.

> Note that this likely needs to be copied to `gainful-cp01.escs.udel.edu`
> and executed from there using the calicoctl command.  The appropriate
> definitions were not on `captain.escs.udel.edu` the last time I
> checked.

```
calicoctl apply -f grouper-prod-network-policy-pgo.yaml
```


## Our Volumes

These are the current volumes we are using.  If you started
another database or are otherwise workin on them, check their
status:

```
kubectl get pv | grep 'grouper-prod-.*-pgo'
grouper-prod-3-pgo                      40G        RWO            Retain           Released   postgres-operator/grouper-prod-instance1-rmrx-pgdata   grouper-prod-pgo                       6d19h
grouper-prod-pgo                        40G        RWO            Retain           Released   postgres-operator/grouper-prod-instance1-2vgq-pgdata   grouper-prod-pgo                       11d
grouper-prod-repo-iscsi-pgo             300Gi      RWO            Retain           Released   postgres-operator/grouper-prod-repo1                   grouper-prod-repo-iscsi-pgo            23h
udpsqlnetdb-pv-iscsi-3                  60Gi       RWO            Retain           Released   postgres-operator/grouper-prod-instance2-mbb7-pgdata   grouper-prod-iscsi-pgo                 3d23h
```

Since these are not in `Available` state, we will need to release them by getting rid
of the current claim against them.  Do this as such:

```
kubectl patch pv grouper-prod-3-pgo -p '{"spec":{"claimRef": null}}' grouper-prod-3-pgo
kubectl patch pv grouper-prod-3-pgo -p '{"spec":{"claimRef": null}}' grouper-prod-pgo
kubectl patch pv grouper-prod-3-pgo -p '{"spec":{"claimRef": null}}' grouper-prod-repo-iscsi-pgo
kubectl patch pv grouper-prod-3-pgo -p '{"spec":{"claimRef": null}}' udpsqlnetdb-pv-iscsi-3
```

Note: the PVs are defined in `pvs` directory, which is [one and and one down](../pvs/).

After running the above, you should see:

```
[mike@captain grouper-prod-pgo]$ kubectl get pv | grep 'grouper-prod-.*pgo'
grouper-prod-3-pgo                      40G        RWO            Retain           Available                                                 grouper-prod-pgo                       6d19h
grouper-prod-pgo                        40G        RWO            Retain           Available                                                 grouper-prod-pgo                       11d
grouper-prod-repo-iscsi-pgo             300Gi      RWO            Retain           Available                                                 grouper-prod-repo-iscsi-pgo            23h
udpsqlnetdb-pv-iscsi-3                  60Gi       RWO            Retain           Available                                                 grouper-prod-iscsi-pgo                 3d23h
```

If one of the volumes is `Bound`, you might have an instance running or something else is trying to
grab one of your volumes.  This is not a good thing.  Look at the PVC and it's yaml and see if
you can determine what it is.

## Add the iSCSI Secret

If iSCSI volumes are used, a secret is required to mojunt these volumes.  The secret is currently
in the ../pvs directory.  Apply it is as so:

```
kubectl apply -f ../pvs/test-iscsi-secret-pv.yaml -n grouper-prod-pgo
```

Well, maybe.  I'm not sure if -n overrides the resource Namespace, so
maybe just change the namespace in the resource file.

## Add the Private Image Repository Secret

```
kubectl apply -f ../captain-regcreds-secrets.yaml -n grouper-prod-pgo
```

## Deployment

Assuming your current directory is this one, the basic deployment command
is:

```
kubectl apply -k ../grouper-prod-pgo
```

Note the **-k** flag.

# End.
