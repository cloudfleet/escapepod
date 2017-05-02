Backup System for CloudFleet
============================

This is a disaster recovery Backup System. The goal is to recreate the system after a total failure.

Algorithm
---------

### Storing

1. If no backup exists, create full backup
2. Get metadata of last backup
3. If metadata matches one of the currently available snapshots, 
   create incremental backup from this snapshot. Else got to step 1.

### Snapshotting

There are up to four snapshots, that are kept on the system.

1. __Root__: The snapshot the last full backup was taken from
2. __Last Parent__: The snapshot that was the parent of the last incremental backup
3. __Current Parent__: The snapshot that was the current state of the last incremental backup
4. __Current State__: The snapshot that is the state for the current incremental backup

### Metadata stored for per backup

1. Size in bytes
2. SHA512 of encrypted BLOB
3. Date of Snapshot
4. UUID of Snapshot
5. Type (full or incremental)
6. Metadata of Parent (if not full backup)

The metadata is stored as JSON.


Encryption
----------

The binary blob will be encrypted with `openssl`.

### Keys

The keyfile wil be stored in the selected CloudFleet key space and in the escapepod data space.


### Algorithm

The algorithm will be aes256 [TBD variant, ctr?]

Storage
-------

Every encrypted blob is sent to the Storage Driver along with the encrypted metadata

### API

A storage driver must provide the following functions:

1. `store_backup metadata`
   - `Ìnput ` encrypted blob and the encrypted metadata
   - `Output` Success

2. `store_backup` 
   - `Ìnput ` encrypted blob and the encrypted metadata
   - `Output` Success

3. `get_last_backup_metadata`
   - `Input ` domain
   - `Output` encrypted metadata of last backup or 404
   
4. `get_next_backup_metadata`
   - `Input ` domain, sha256 of previous backup or nothing
   - `Output` encrypted metadata of backup

5. `get_backup_blob`
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
