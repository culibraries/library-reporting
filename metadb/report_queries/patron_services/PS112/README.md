# Patron Services: Patron Billing Report: Combined Reports 

## Purpose
This report provides information about fee/fine actions, combining all the Patron Billing reports into one report.
The output is all required columns needed as input to the Library's internal Patron Fee Access Database where billing and invoice generation is currently happening.

## Parameters
This report excludes results where:
- fee/fine action is for items located in the Law Library.
- fee/fine actions source is set to *Sierra*.
- fee/fine action is for patron who is a member of the *Library Department* user group (checks against this user group's id).

Users can set the following parameters(at the top of the query):
1. *invoice_interval_start*: Reports with fee/fine actions starting on this date (inclusive).
1. *invoice_interval_end*: Reports with fee/fine actions ending on this date (exclusive).

Date strings are in the format 'YYYY-MM-DD" and will need to be cast to *DATE* type.
<br>
**IE:** *'2024-01-01'::DATE*
<br>
*CURRENT_DATE* can be used for *invoice_interval_end* to get results all the way upto, but not including, the day the report is run.

## Sample Output
*Please note, some columns will be empty, but are still required to be present by the Patron Fee Access DB.*
|LineNum|InvoiceNo|InvDate|Location|PatronNo|ID|Name|Name2|Address1|Address2|Country|P1|P2|P3|pType|ItemBarcode|ItemTitle|CallNo|TYPE|Amount|Amount2|Amount3|AmtTotal|RprtDate|CutOffDate|DueDateInv|CheckNo|DatePaid|AmtPaid|WhoEntered|DateToCashiers|AcctStatus|DateNoticeSent|DateToCollection|PaidOKToMove|Notes|LblAmt|LblAmt2|LblAmt3|AmtTotal1
|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
10119240001|0e11f1e1-1111-11b1-11c1-1ccba1111111,bd1b1111-1e1b-111d-b11e-11f1d1db1b11|2023-12-01|Norlin Stacks|6000000000000000|100000000|DOE, JOHN||1111  Example Street|Boulder, CO 80302|||||CU Boulder undergraduate|U183017758232|The Item Title Here|PR6073.E443 A64 1995|Replacement|125|0|10|135|2024-01-19|2024-01-31|2024-02-29|||||||||||Rep Charge|NA|Late Fee|AmtTotal1
