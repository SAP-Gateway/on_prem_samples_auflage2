CLASS zcl_zcredit_bank_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zcredit_bank_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~execute_action REDEFINITION.

  PROTECTED SECTION.

    METHODS creditset_get_entity REDEFINITION.

    METHODS creditset_get_entityset REDEFINITION.

    METHODS creditset_create_entity REDEFINITION.

    METHODS creditset_update_entity REDEFINITION.

    METHODS creditset_delete_entity REDEFINITION.

  PRIVATE SECTION.

    METHODS validate_credit
      IMPORTING
        credit TYPE zcredit_bank
      RAISING
        zcx_credit.
    METHODS validate_primary_key
      IMPORTING
        credit     TYPE zcredit_bank
        it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      RAISING
        zcx_credit.
    METHODS credit_has_changed
      IMPORTING
        credit_entity TYPE zcredit_bank
      RAISING
        zcx_credit.

    METHODS release_credit
      IMPORTING
        parameters TYPE /iwbep/t_mgw_name_value_pair
      EXPORTING
        credit     TYPE zcredit_bank.

ENDCLASS.



CLASS ZCL_ZCREDIT_BANK_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    FIELD-SYMBOLS:
      <credit> TYPE zcredit_bank.

    CASE iv_action_name.
      WHEN 'Release'.
        CREATE DATA er_data TYPE zcredit_bank.
        ASSIGN er_data->* TO <credit>.
        release_credit(
          EXPORTING
            parameters = it_parameter
          IMPORTING
            credit = <credit> ).
    ENDCASE.

  ENDMETHOD.


  METHOD creditset_create_entity.
    DATA:
      credit_entity TYPE zcredit_bank.

    io_data_provider->read_entry_data(
      IMPORTING es_data = credit_entity ).

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '01'
        object      = 'ZCREDIT_NO'
      IMPORTING
        number      = credit_entity-credit_no.

    validate_credit( credit_entity ).

    INSERT zcredit_bank FROM credit_entity.
    IF sy-subrc = 0.
      er_entity = credit_entity.
    ELSE.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid           = zcx_credit=>insert_failed
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-bad_request.
    ENDIF.

  ENDMETHOD.


  METHOD creditset_delete_entity.
    CONSTANTS:
      state_pending_approval TYPE zcredit_state VALUE '1'.

    READ TABLE it_key_tab REFERENCE INTO DATA(key_value_pair)
      WITH KEY name = 'CreditNo'.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>credit_no_not_found.
    ENDIF.
    DATA(credit_no) = |{ CONV zcredit_no( key_value_pair->*-value ) ALPHA = IN }|.

    SELECT COUNT(*) FROM zcredit_bank
      WHERE credit_no = @credit_no AND state = @state_pending_approval.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>delete_not_possible.
    ENDIF.

    DELETE FROM zcredit_bank WHERE credit_no = @credit_no.

  ENDMETHOD.


  METHOD creditset_get_entity.

    READ TABLE it_key_tab REFERENCE INTO DATA(key_value_pair)
      WITH KEY name = 'CreditNo'.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>credit_no_not_found.
    ENDIF.
    DATA(credit_no) = |{ CONV zcredit_no( key_value_pair->*-value ) ALPHA = IN }|.

    DATA(selected_fields) = io_tech_request_context->get_select_with_mandtry_fields( ).
    IF selected_fields IS INITIAL.
      INSERT CONV string( '*' ) INTO TABLE selected_fields.
    ELSE.
      LOOP AT selected_fields ASSIGNING FIELD-SYMBOL(<field>)
        FROM 1 TO lines( selected_fields ) - 1.
        <field> = |{ <field> },|.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE (selected_fields) FROM zcredit_bank
      WHERE credit_no = @credit_no
      INTO CORRESPONDING FIELDS OF @er_entity.

  ENDMETHOD.


  METHOD creditset_get_entityset.
    DATA: offset    TYPE i,
          page_size TYPE i.

    DATA(osql_where_clause) = io_tech_request_context->get_osql_where_clause( ).

    IF io_tech_request_context->get_top( ) IS NOT INITIAL.
      " deliver a package
      page_size =
        CONV i( io_tech_request_context->get_top( ) )
        - CONV i( io_tech_request_context->get_skip( ) ).
      offset = io_tech_request_context->get_skip( ).
      SELECT * FROM zcredit_bank
        WHERE (osql_where_clause)
        ORDER BY credit_no
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        OFFSET @offset UP TO @page_size ROWS.
    ELSE.
      " deliver the result at once
      SELECT * FROM zcredit_bank
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        WHERE (osql_where_clause).
    ENDIF.

    " Get the overall count
    CLEAR es_response_context-inlinecount.
    IF io_tech_request_context->has_inlinecount( )
      = abap_true.
      SELECT COUNT(*) FROM zcredit_bank
        WHERE (osql_where_clause).
      es_response_context-inlinecount = sy-dbcnt.
    ENDIF.

  ENDMETHOD.


  METHOD creditset_update_entity.
    DATA: credit_entity TYPE zcredit_bank.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = credit_entity ).

    CALL FUNCTION 'ENQUEUE_EZCREDIT_BANK'
      EXPORTING
        credit_no    = credit_entity-credit_no
      EXCEPTIONS
        foreign_lock = 4.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>object_locked.
    ENDIF.

    validate_primary_key(
      it_key_tab = it_key_tab
      credit = credit_entity ).
    validate_credit( credit_entity ).
    credit_has_changed( credit_entity ).

    GET TIME STAMP FIELD credit_entity-last_change.

    UPDATE zcredit_bank FROM credit_entity.
    IF sy-subrc = 0.
      er_entity = credit_entity.
    ELSE.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>update_failed.
    ENDIF.

  ENDMETHOD.


  METHOD credit_has_changed.

    SELECT SINGLE last_change FROM zcredit_bank
      WHERE credit_no = @credit_entity-credit_no
      INTO @DATA(last_change_timestamp).
    IF last_change_timestamp > credit_entity-last_change.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>credit_has_changed.
    ENDIF.

  ENDMETHOD.


  METHOD release_credit.
    CONSTANTS:
      state_released TYPE zcredit_state VALUE '2'.

    TRY.
        DATA(credit_no) = |{ CONV zcredit_no( parameters[ name = 'CreditNo' ]-value ) ALPHA = IN }|.
        UPDATE zcredit_bank SET state = @state_released
          WHERE credit_no = @credit_no.

        SELECT SINGLE * FROM zcredit_bank
          WHERE credit_no = @credit_no
          INTO CORRESPONDING FIELDS OF @credit.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD validate_credit.

    IF credit-start_year IS INITIAL.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>start_year_missing.
    ENDIF.

    IF credit-credit_sum <= 0.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>credit_sum_invalid.
    ENDIF.

  ENDMETHOD.


  METHOD validate_primary_key.

    READ TABLE it_key_tab REFERENCE INTO DATA(key_value_pair)
      WITH KEY name = 'CreditNo'.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA(credit_no) = |{ CONV zcredit_no( key_value_pair->*-value ) ALPHA = IN }|.

    IF credit_no <> credit-credit_no.
      RAISE EXCEPTION TYPE zcx_credit
        EXPORTING
          textid = zcx_credit=>invalid_primary_key.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
