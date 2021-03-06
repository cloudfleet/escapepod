Backup System for CloudFleet
============================

This is a disaster recovery Backup System. The goal is to recreate the system after a total failure.

Algorithm
---------

### Storing

1. If no backup exists, create full backup
2. Get metadata of last backup
3. If metadata matches one of the currently available snapshots,
   create incremental backup from this snapshot. Else go to step 1.

### Snapshotting

There are up to four snapshots, that are kept on the system.

1. __Root__: The snapshot the last full backup was taken from
2. __Last Parent__: The snapshot that was the parent of the last incremental backup
3. __Current Parent__: The snapshot that was the current state of the last incremental backup
4. __Current State__: The snapshot that is the state for the current incremental backup

### Metadata stored for per backup

1. UUID of Snapshot
3. Date of Snapshot
2. Size of cleartext BLOB in bytes
4. SHA512 of cleartext BLOB
5. Type (full or incremental)
6. UUID of Parent (if not full backup)

The metadata is stored as JSON.


Encryption
----------

The binary blob will be encrypted with `openssl`.

### Keys

The keyfile wil be stored in the selected CloudFleet key space and in the escapepod data space.


### Algorithm

The algorithm will be aes256 [TBD variant, cbc, ctr?]

Storage
-------

Every encrypted blob is sent to the Storage Driver along with the encrypted metadata

### API

A storage driver must provide the following functions:

1. `store_backup_metadata`
   - `Ìnput ` encrypted metadata and backup uuid
   - `Output` Success

2. `store_backup`
   - `Ìnput ` encrypted blob and sha256 of cleartext blob
   - `Output` Success

3. `get_backup_metadata`
   - `Input ` None or uuid of backup (if none, metadata of last backup is returned)
   - `Output` encrypted metadata of backup

4. `get_backup`
   - `Input ` sha256 of requested blob
   - `Output` encrypted blob of backup



Storage Drivers
---------------

For the first implementation we will target two storage drivers.

_Careful_ One set of snapshots will be kept per storage driver. If you use more than one storage
drivers, you might use more disk space than expected.

### DuneSea

A very simple service by CloudFleet, that allows to have your encrypted data stored remotely.

See https://dunesea.cloudfleet.io

### External Storage

You need a USB drive, that is labeled escapepod.

If the system finds an external storage with that label, it will create a folder
escapepod (if not present) and store the backup data in there.
