CLASS zcx_credit DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cx_mgw_busi_exception
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF credit_no_not_found,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF credit_no_not_found,
      BEGIN OF start_year_missing,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_year_missing,
      BEGIN OF credit_sum_invalid,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF credit_sum_invalid,
      BEGIN OF insert_failed,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF insert_failed,
      BEGIN OF invalid_primary_key,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_primary_key,
      BEGIN OF update_failed,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF update_failed,
      BEGIN OF delete_not_possible,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF delete_not_possible,
      BEGIN OF credit_has_changed,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF credit_has_changed,
      BEGIN OF object_locked,
        msgid TYPE symsgid VALUE 'ZCREDIT',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF object_locked.

    METHODS constructor
      IMPORTING
        !textid                   LIKE if_t100_message=>t100key OPTIONAL
        !previous                 LIKE previous OPTIONAL
        !message_container        TYPE REF TO /iwbep/if_message_container OPTIONAL
        !http_status_code         TYPE /iwbep/mgw_http_status_code DEFAULT gcs_http_status_codes-bad_request
        !http_header_parameters   TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
        !sap_note_id              TYPE /iwbep/mgw_sap_note_id OPTIONAL
        !msg_code                 TYPE string OPTIONAL
        !method                   TYPE string OPTIONAL
        !internal_service_version TYPE /iwbep/med_grp_version OPTIONAL
        !external_service_name    TYPE /iwbep/med_grp_external_name OPTIONAL
        !service_namespace        TYPE string OPTIONAL
        !internal_service_name    TYPE /iwbep/med_grp_technical_name OPTIONAL
        !operation                TYPE char30 OPTIONAL
        !entity_type              TYPE string OPTIONAL
        !action                   TYPE string OPTIONAL
        !type_returned            TYPE string OPTIONAL
        !type_expected            TYPE string OPTIONAL
        !nav_property             TYPE /iwbep/med_external_name OPTIONAL
        !operation_id             TYPE string OPTIONAL .
protected section.
private section.
ENDCLASS.



CLASS ZCX_CREDIT IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
MESSAGE_CONTAINER = MESSAGE_CONTAINER
HTTP_STATUS_CODE = HTTP_STATUS_CODE
HTTP_HEADER_PARAMETERS = HTTP_HEADER_PARAMETERS
SAP_NOTE_ID = SAP_NOTE_ID
MSG_CODE = MSG_CODE
ENTITY_TYPE = ENTITY_TYPE
MESSAGE = MESSAGE
MESSAGE_UNLIMITED = MESSAGE_UNLIMITED
FILTER_PARAM = FILTER_PARAM
OPERATION_NO = OPERATION_NO
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
