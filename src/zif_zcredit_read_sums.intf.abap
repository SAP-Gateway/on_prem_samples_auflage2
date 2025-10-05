interface ZIF_ZCREDIT_READ_SUMS
  public .


  types:
    ZCREDIT_START_YEAR type N length 000004 .
  types:
    ZCREDIT_SUM type P length 6  decimals 000002 .
  types:
    WAERS type C length 000005 .
  types:
    begin of ZCREDIT_BANK_SUM,
      START_YEAR type ZCREDIT_START_YEAR,
      CREDIT_SUM type ZCREDIT_SUM,
      CURRENCY_CODE type WAERS,
    end of ZCREDIT_BANK_SUM .
  types:
    ZCREDIT_BANK_SUMS              type standard table of ZCREDIT_BANK_SUM               with non-unique default key .
endinterface.
