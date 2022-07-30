## Adding inactive identifier in Maintenance Pattern
Natively, there's no inactive field available on Maintenance Pattern (MP) record view. The active status of a MP seems to be driven by the status of the associated MP equipment i.e. if the MP equipment status is active we can say that the MP is active as well.

In order to identify whether an MP has an active equipment, users would need to check the MP equipment tab of each MPs. This can be daunting when dealing with thousands of MP records.

### Specification
- MP record view to display status of MP equipment via a field called ***Inactive***
- The field should be a flag type (boolean type) to indicate the MP is active or not
- The field to be protected since it is logical value determined by the MP equipment status
- Field logic:
  - Inactive :white_check_mark:
    - no MP equipment exist
    - all MP equipment status inactive
  - Inactive :green_square:
    - one or more MP equipment status is not inactive

### Solution
- mtp_udfchkbox04 on MP record view is chosen to be the  ***Inactive*** field
  - [x] add to field allocation spreadsheet
  - [x] label field to Inactive in VAMS
  - [x] set field to protected (currently configured for ADMIN, VCS-* UG)
  - [ ] set field to protected via extensible framework (fallback safeguard)
- MP record is inactive by default
  - [x] Flex R5MAINTENANCEPATTERN/5 - Post Insert
- MP record is active when one or more MP equipment status is Active or Pending Inactive
  - [x] Flex R5PATTERNEQUIPMENT/20 - Post Insert/Update
