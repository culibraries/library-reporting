# The FOLIO Report Query Repository 

This repository stores queries designed to produce reports of FOLIO data in 
a local LDP metadb instance.  Many of these queries have been developed
by the FOLIO reporting community or adapted from them.  Some queries are custom queries developed by and specific to the University of Colorado Boulder FOLIO instance.


## How to find a query

You can find queries by browsing the subfolders in this folder or by
reviewing the [Query Table of Contents](#query-table-of-contents) below.

## Understanding query files

Queries are divided into different tracks and given a track code and number.
In the folder for each query, you should see a .sql file and a README
file.

The README file summarizes the purpose, output, and special instructions
of the query.

The .sql file contains the SQL code for the query. You can copy and
paste the content of this file into the reporting tool of your choice
(or download the file and open it in the tool).

## Query Table of Contents

### Acquisitions (ACQ)

### Catalog Management (CM)

### Collection Development (CD)
* [Circulation Activity](collection_development/CD100)
* [Item Count By Material Type](collection_development/CD101)
* [Item Count by Language Codes](collection_development/CD102)
* [PPOD Title List with Status and Amount Paid](collection_development/CD103)

### eResource Management (ERM)
* [Film Expiration Search](eresource_management/ERM100)

### External Reporting (EXR)

### Materials Management (MM)
* [Trace Lost and Missing Lists](materials_management/MM100)

### Patron Services (PS)
* [Overdue Items](patron_services/PS100)
* [Coming Billed](patron_services/PS101)
