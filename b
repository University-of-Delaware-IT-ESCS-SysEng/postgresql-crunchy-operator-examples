#!/bin/sh

if [ `git status --porcelain | wc -l` -gt 0 ]; then
    echo Likely uncommitted changes.  Please commit changes
    echo or switch to an appropriate branch that does not
    echo require checkins.
    echo
    git status
#    exit 1
fi

#
# Get all the images from kustomize/install/default/kustomization.yaml
# Get all the images from kustomize/install/manager/manager.yaml
# Get all the images from kustomize/install/manager/manager-upgrade.yaml
#
# It would be hard to parse this file in bash.  Probably nost any harder to
# just edit it by hand.
#

for o in  "registry.developers.crunchydata.com/crunchydata/postgres-operator:ubi8-5.1.0-0" \
          "registry.developers.crunchydata.com/crunchydata/postgres-operator-upgrade:ubi8-5.1.0-0" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-13.6-1" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-postgres-gis:ubi8-13.6-3.1-1" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-14.2-1" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-postgres-gis:ubi8-14.2-3.1-1" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-pgadmin4:ubi8-4.30-0" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.38-0" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-pgbouncer:ubi8-1.16-2" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-postgres-exporter:ubi8-5.1.0-0" \
          "registry.developers.crunchydata.com/crunchydata/crunchy-upgrade:ubi8-5.1.0-0" \
                        ; do \
    OURIMAGE=`basename $o`
    echo "FROM ${o}" > Dockerfile
    docker build -f Dockerfile -t  $OURIMAGE .
    echo docker image tag ${OURIMAGE} captain.escs.udel.edu:5000/${OURIMAGE}
    docker image tag ${OURIMAGE} captain.escs.udel.edu:5000/${OURIMAGE}
    echo docker image push captain.escs.udel.edu:5000/${OURIMAGE}
    docker image push captain.escs.udel.edu:5000/${OURIMAGE}
done

# End.
