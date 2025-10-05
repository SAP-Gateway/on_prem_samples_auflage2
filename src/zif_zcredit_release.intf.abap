interface ZIF_ZCREDIT_RELEASE
  public .


  types:
    ZCREDIT_NO type C length 000010 .
  types:
    ZCREDIT_START_YEAR type N length 000004 .
  types:
    ZCREDIT_SUM1 type P length 6  decimals 000002 .
  types:
    ZCREDIT_REPAY_RATE type P length 6  decimals 000002 .
  types:
    ZCREDIT_TRIBUTE type P length 3  decimals 000002 .
  types:
    ZCREDIT_STATE type C length 000001 .
  types:
    WAERS type C length 000005 .
  types:
    ZCREDIT_BORROWER type C length 000010 .
  types:
    TIMESTAMP type P length 8  decimals 000000 .
  types:
    begin of ZCREDIT_BANK,
      CLIENT type C length 000003,
      CREDIT_NO type ZCREDIT_NO,
      START_YEAR type ZCREDIT_START_YEAR,
      CREDIT_SUM type ZCREDIT_SUM1,
      MONTHLY_REPAY_RATE type ZCREDIT_REPAY_RATE,
      TRIBUTE type ZCREDIT_TRIBUTE,
      STATE type ZCREDIT_STATE,
      CURRENCY_CODE type WAERS,
      BORROWER type ZCREDIT_BORROWER,
      LAST_CHANGE type TIMESTAMP,
    end of ZCREDIT_BANK .
endinterface.
