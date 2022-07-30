## Inactive field in Maintenance Pattern
Natively, inactive field is not available on Maintenance Pattern (MP) record view. The active status of a MP seems to be driven by the status of the associated MP equipment i.e. if the MP equipment status is active we can say that the MP is active as well.

Design wise this is inconsistent when compared to another scheduler module (PM Schedules)
| Screen | Tab | Inactive |
| :--- | :--- | :---: |
| Maintenance Pattern | Record View | :black_large_square: |
| Maintenance Pattern | Equipment | :ballot_box_with_check: |
| PM Schedules | Record View | :ballot_box_with_check:	|
| PM Schedules | Equipment | :black_large_square: |

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
  - [x] [Flex R5MAINTENANCEPATTERN/5 - Post Insert](./R5MAINTENANCEPATTERNS_5_Post_Insert.sql)
- MP record is active when one or more MP equipment status is Active or Pending Inactive
  - [x] [Flex R5PATTERNEQUIPMENT/20 - Post Insert](./R5PATTERNEQUIPMENT_20_Post_Insert.sql)
  - [x] [Flex R5PATTERNEQUIPMENT/20 - Post Update](./R5PATTERNEQUIPMENT_20_Post_Update.sql)
