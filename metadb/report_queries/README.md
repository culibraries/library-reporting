# The FOLIO Report Query Repository 

This repository stores queries designed to produce reports of FOLIO data in 
a local LDP Metadb instance.  Many of these queries have been developed
by the FOLIO reporting community or adapted from them.  Some queries are custom queries developed by and specific to the University of Colorado Boulder FOLIO instance.


## How to find a report query

You can find queries by browsing the subfolders in this folder or by
reviewing the [Query Table of Contents](#query-table-of-contents) below.

Numbering schema: 

100s = General

200s = Business

300s = Earth Sciences and Maps

400s = Engineering Math and Physics

500s = Music

600s = Norlin

700s = Offsite

800s = Online

1000s = Projects

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
* [ACQ100: Reconciliation Report](acquisitions/ACQ100)
* [ACQ101: Order Details Report](acquisitions/ACQ101)
* [ACQ102: Unpaid Serials Report](acquisitions/ACQ102)
* [ACQ103: Serials Detail Report](acquisitions/ACQ103)

### Catalog Management (CM)
* [CM100: Backstage Record Pull](catalog_management/CM100)
* [CM102: GoldRush Holdings](catalog_management/CM102)
* [CM103: OCLC MARC Holdings (LHRs)](catalog_management/CM103)
* [CM104: Holdings To OCLC](catalog_management/CM104)
* [CM105: Occam's Reader](catalog_management/CM105)
* [CM106: RAPID - Print Monographs](catalog_management/CM106)
* [CM107: RAPID - Print Serials](catalog_management/CM107)
* [CM109: Cataloging Records by User](catalog_management/CM109)
* [CM110: 583 Colorado Alliance Retention Candidate Report](catalog_management/CM110)

### Collection Development (CD)
* [CD100: Title List Report](collection_development/CD100)
* [CD101: PASCAL Criteria Lists](collection_development/CD101)
* [CD103: 956 Bib Search](collection_development/CD103)
* [CD104: Missing Books Review List](collection_development/CD104)
* [CD300: Maps Report](collection_development/CD300)

### eResource Management (ERM)
* [ERM100: Film Expiration Search](eresource_management/ERM100)
* [ERM101: Google Analytics 856 Records Viewed](eresource_management/ERM101)
* [ERM102: E-resource Covered By An Agreement](eresource_management/ERM102)
* [ERM103: Incorrect Text in URL Field](eresource_management/ERM103)

### Materials Management (MM)
* [MM1000: Google Books Individual Manifests](materials_management/MM1000)
* [MM101: Escaped Paged Report](materials_management/MM101)
* [MM102: Trace Lost Reports](materials_management/MM102)
* [MM602: Norlin Awaiting Delivery Report](materials_management/MM602)
* [MM603: Norlin In-Transits Report](materials_management/MM603)
* [MM604: Norlin RaD 856](materials_management/MM604)

### Patron Services (PS)
* [PS100: Overdue Items](patron_services/PS100)
* [PS101: Coming Billed](patron_services/PS101)
* [PS102: Claimed Return](patron_services/PS102)
* [PS103: Patron Billing](patron_services/PS103)

### Reporting & Statistics (RS)
[Data dashboards](https://o365coloradoedu.sharepoint.com/sites/libraries/collectionmanagement/SitePages/FOLIO-Dashboards.aspx) are available on the Collection Management's Sharepoint Page.
