## Adding inactive identifier in Maintenance Pattern
Natively, there's no inactive field available on Maintenance Pattern (MP) record view. The active status of a MP seems to be driven by the status of the associated MP equipment i.e. if the MP equipment status is active we can say that the MP is active as well.

In order to identify whether an MP has an active equipment, users would need to check the MP equipment tab of each MPs. This can be daunting when dealing with thousands of MP records.

### Specification
- MP record view to display status of MP equipment via a field called inactive
- The field should be a flag type (boolean type) to indicate the MP is active or not
- The field to be protected since it is logical value determined based on MP equipment status
- Field logic:
  - inactive = TRUE
    - dddsfsfs   
