# PV Defintions

This directory contains the PVs we use.  At this time,
our PVs are tied to a specific machine since we do not
have NAS and NFS died using Postgresql.

## Reusing the PV

I haven't tested this yet, but:

When deleting a persistent volume claim such as
deleting the database definition, the PV will end
up in the state of Release.  To make it available
for use with a new database defintion resource:

In a released state, edit the PV and remove spec.claimRef block

kubectl edit pv <pv name>

This is supposed to make the PV available.
