@AbapCatalog.sqlViewName: 'ZCREDIT_BANKV1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit Bank View'
@Metadata.ignorePropagatedAnnotations: true
define view zcredit_bankv as select from zcredit_bank as c
  inner join zcredit_customer as b on b.borrower_no = c.borrower{
  
  key c.credit_no,
  c.borrower,
  b.name,
  c.start_year,
  c.credit_sum,
  c.tribute
  
}
