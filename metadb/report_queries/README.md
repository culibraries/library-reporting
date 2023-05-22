# The FOLIO Report Query Repository 

This repository stores queries designed to produce reports of FOLIO data in 
a local LDP Metadb instance.  Many of these queries have been developed
by the FOLIO reporting community or adapted from them.  Some queries are custom queries developed by and specific to the University of Colorado Boulder FOLIO instance.


## How to find a report query

You can find queries by browsing the subfolders in this folder or by
reviewing the [Query Table of Contents](#query-table-of-contents) below.

## Understanding report query files

Reports are divided into different tracks and given a track code 
and number.  For each report, you should see a .sql file and a README
file.

The README file summarizes the purpose, output, and special instructions
of the query.

The .sql file contains the SQL code for the query. You can copy and
paste the content of this file into the reporting tool of your choice
(or download the file and open it in the tool).

## Query Table of Contents

### Acquisitions (ACQ)
* [Reconciliation Report](acquisitions/ACQ100)
* [Order Details Report](acquisitions/ACQ101)
* [Unpaid Serials Report](acquisitions/ACQ102)
* [Serials Detail Report](acquisitions/ACQ103)

### Catalog Management (CM)
* [Backstage Record Pull](catalog_management/CM100)
* [GoldRush Holdings](catalog_management/CM102)
* [OCLC MARC Holdings (LHRs)](catalog_management/CM103)
* [Holdings To OCLC](catalog_management/CM104)
* [Occam's Reader](catalog_management/CM105)
* [RAPID - Print Monographs](catalog_management/CM106)
* [RAPID - Print Serials](catalog_management/CM107)
* [EDS Holdings](catalog_management/CM108)
* [Cataloging Records by User](catalog_management/CM109)

### Collection Development (CD)
* [Title List Report](collection_development/CD100)
* [PASCAL Criteria Lists](collection_development/CD101)
* [583 Bib Search](collection_development/CD102)
* [956 Bib Search](collection_development/CD103)
* [Missing Books Review List](collection_development/CD104)
* [Maps Report](collection_development/CD105)

### eResource Management (ERM)
* [Film Expiration Search](eresource_management/ERM100)
* [Google Analytics 856 Records Viewed](eresource_management/ERM101)
* [E-resource Covered By An Agreement](eresource_management/ERM102)
* [Incorrect Text in URL Field](eresource_management/ERM103)

### Materials Management (MM)
* [Google Books Individual Manifests](materials_management/MM100)
* [Escaped Paged Report](materials_management/MM101)
* [Old In-Transits Report](materials_management/MM102)
* [Trace Lost Reports](materials_management/MM103)
* [RaD 856](materials_management/MM104)

### Patron Services (PS)
* [Overdue Items](patron_services/PS100)
* [Coming Billed](patron_services/PS101)
* [Claimed Return](patron_services/PS102)
* [Patron Billing](patron_services/PS103)

### Reporting & Statistics (RS)
