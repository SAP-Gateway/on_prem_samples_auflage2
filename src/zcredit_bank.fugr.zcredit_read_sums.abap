FUNCTION ZCREDIT_READ_SUMS.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  EXPORTING
*"     VALUE(CREDIT_SUMS) TYPE  ZCREDIT_BANK_SUMS
*"----------------------------------------------------------------------
  CONSTANTS:
    state_released TYPE zcredit_state VALUE '2'.

  SELECT start_year, SUM( credit_sum ) AS credit_sum, currency_code
    FROM zcredit_bank
    WHERE state = @state_released
    GROUP BY start_year, currency_code
    INTO CORRESPONDING FIELDS OF TABLE @credit_sums.

ENDFUNCTION.
