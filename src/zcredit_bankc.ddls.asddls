@AbapCatalog.sqlViewName: 'ZCREDIT_BANKC1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit Bank View'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define view zcredit_bankc as select from zcredit_bank as c
  inner join zcredit_customer as b on b.borrower_no = c.borrower{
  
  key c.credit_no,
  c.borrower,
  b.name,
  c.start_year,
  c.credit_sum,
  c.tribute
  
}
