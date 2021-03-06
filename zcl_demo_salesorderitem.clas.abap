CLASS zcl_demo_salesorderitem DEFINITION
  PUBLIC
  INHERITING FROM zcl_bo_abstract
  CREATE PROTECTED .

  PUBLIC SECTION.

    INTERFACES zif_demo_salesorderitem .
    INTERFACES zif_gw_methods .

    ALIASES get
      FOR zif_demo_salesorderitem~get .
    ALIASES get_arktx
      FOR zif_demo_salesorderitem~get_arktx .
    ALIASES get_matnr
      FOR zif_demo_salesorderitem~get_matnr .
    ALIASES get_mseht
      FOR zif_demo_salesorderitem~get_mseht .
    ALIASES get_netwr
      FOR zif_demo_salesorderitem~get_netwr .
    ALIASES get_posnr
      FOR zif_demo_salesorderitem~get_posnr .
    ALIASES get_vbeln
      FOR zif_demo_salesorderitem~get_vbeln .
    ALIASES get_waerk
      FOR zif_demo_salesorderitem~get_waerk .
    ALIASES get_waerk_txt
      FOR zif_demo_salesorderitem~get_waerk_txt .
    ALIASES get_zieme
      FOR zif_demo_salesorderitem~get_zieme .
    ALIASES get_zmeng
      FOR zif_demo_salesorderitem~get_zmeng .

    METHODS constructor
      IMPORTING
        !key TYPE zif_demo_salesorderitem=>key
      RAISING
        zcx_demo_bo .
  PROTECTED SECTION.

    TYPES:
      BEGIN OF uom_type,
        msehi TYPE msehi,
        mseht TYPE mseht,
      END OF uom_type .
    TYPES:
      uom_ttype TYPE TABLE OF uom_type .
    TYPES:
      BEGIN OF curr_type,
        waers TYPE waers_curc,
        ltext TYPE ltext,
      END OF curr_type .
    TYPES:
      curr_ttype TYPE TABLE OF curr_type .

    CLASS-DATA uom_texts TYPE uom_ttype .
    CLASS-DATA currency_texts TYPE curr_ttype .

    METHODS load_item_data
      IMPORTING
        !key TYPE zif_demo_salesorderitem=>key
      RAISING
        zcx_demo_bo .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEMO_SALESORDERITEM IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).

    load_item_data( key ).
  ENDMETHOD.


  METHOD load_item_data.
    SELECT SINGLE *
      FROM vbap
      INTO CORRESPONDING FIELDS OF zif_demo_salesorderitem~item_data
      WHERE vbeln = key-vbeln
      AND posnr = key-posnr.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'SalesOrderItem'
          bo_id   = |{ key-vbeln }/{ key-posnr }|.
    ENDIF.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get.

    DATA: lv_key LIKE key.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = key-vbeln
      IMPORTING
        output = lv_key-vbeln.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = key-posnr
      IMPORTING
        output = lv_key-posnr.

    TRY.
        DATA(inst) = zif_demo_salesorderitem~instances[ key = lv_key ].
      CATCH cx_sy_itab_line_not_found.
        inst-key = lv_key.
        DATA(class_name) = get_subclass( 'ZCL_DEMO_SALESORDERITEM' ).
        CREATE OBJECT inst-instance
          TYPE (class_name)
          EXPORTING
            key = inst-key.
        APPEND inst TO zif_demo_salesorderitem~instances.
    ENDTRY.

    instance ?= inst-instance.

  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_arktx.
    arktx = zif_demo_salesorderitem~item_data-arktx.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_matnr.
    matnr = zif_demo_salesorderitem~item_data-matnr.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_mseht.

    TRY.
        mseht = uom_texts[ msehi = zif_demo_salesorderitem~item_data-zieme ]-mseht.
      CATCH cx_sy_itab_line_not_found.
        SELECT *
          FROM t006a
          APPENDING CORRESPONDING FIELDS OF TABLE uom_texts
          WHERE spras = sy-langu
          AND msehi = zif_demo_salesorderitem~item_data-zieme.
        IF sy-subrc NE 0.
          APPEND VALUE #( msehi = zif_demo_salesorderitem~item_data-zieme mseht = 'N/A' ) TO uom_texts.
        ENDIF.
        mseht = uom_texts[ msehi = zif_demo_salesorderitem~item_data-zieme ]-mseht.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_netwr.
    netwr = zif_demo_salesorderitem~item_data-netwr.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_posnr.
    posnr = zif_demo_salesorderitem~item_data-posnr.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_vbeln.
    vbeln = zif_demo_salesorderitem~item_data-vbeln.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_waerk.
    waerk = zif_demo_salesorderitem~item_data-waerk.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_waerk_txt.

    TRY.
        waerk_txt = currency_texts[ waers = zif_demo_salesorderitem~item_data-waerk ]-ltext.
      CATCH cx_sy_itab_line_not_found.
        SELECT *
          FROM tcurt
          APPENDING CORRESPONDING FIELDS OF TABLE currency_texts
          WHERE spras = sy-langu
          AND waers = zif_demo_salesorderitem~item_data-waerk.
        IF sy-subrc NE 0.
          APPEND VALUE #( waers = zif_demo_salesorderitem~item_data-waerk ltext = 'N/A' ) TO currency_texts.
        ENDIF.
        waerk_txt = currency_texts[ waers = zif_demo_salesorderitem~item_data-waerk ]-ltext.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_zieme.
    zieme = zif_demo_salesorderitem~item_data-zieme.
  ENDMETHOD.


  METHOD zif_demo_salesorderitem~get_zmeng.
    zmeng = zif_demo_salesorderitem~item_data-zmeng.
  ENDMETHOD.


  METHOD zif_gw_methods~create_deep_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_DEEP_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~create_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~delete_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~DELETE_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~execute_action.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~EXECUTE_ACTION'.
  ENDMETHOD.


  METHOD zif_gw_methods~get_entity.

    TRY.
        zcl_demo_salesorderitem=>get(
          VALUE #(
            vbeln = it_key_tab[ name = 'SalesOrderId' ]-value
            posnr = it_key_tab[ name = 'ItemNo' ]-value )
            )->zif_gw_methods~map_to_entity( REF #( er_entity ) ).

      CATCH cx_root INTO DATA(cx_root).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = cx_root
            message  = |{ cx_root->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_gw_methods~get_entityset.

    FIELD-SYMBOLS: <entityset> TYPE STANDARD TABLE.
    ASSIGN et_entityset TO <entityset>.

    " Use RTTS/RTTC to create anonymous object like line of et_entityset
    DATA: entity         TYPE REF TO data.
    TRY.
        DATA(struct_descr) = get_struct_descr( et_entityset ).
        CREATE DATA entity TYPE HANDLE struct_descr.
        ASSIGN entity->* TO FIELD-SYMBOL(<entity>).
      CATCH cx_sy_create_data_error INTO DATA(cx_sy_create_data_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_tech_exception=>internal_error
            previous = cx_sy_create_data_error.
    ENDTRY.

    TRY.
        DATA(osreftab) = zcl_demo_salesorder=>get(
          |{ it_key_tab[ name = 'SalesOrderId' ]-value }|
          )->get_items( ).

        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          es_response_context-inlinecount = lines( osreftab ).
        ENDIF.

        " Fill entities
        DATA: item TYPE REF TO zif_demo_salesorderitem.
        LOOP AT osreftab INTO DATA(osref).
          item ?= osref.
          APPEND INITIAL LINE TO <entityset> REFERENCE INTO entity.
          CHECK io_tech_request_context->has_count( ) NE abap_true.
          item->zif_gw_methods~map_to_entity( entity ).
        ENDLOOP.

      CATCH cx_sy_itab_line_not_found zcx_demo_bo INTO DATA(exception).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = exception
            message  = |{ exception->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_gw_methods~map_to_entity.
    call_all_getters( entity ).
  ENDMETHOD.


  METHOD zif_gw_methods~update_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~UPDATE_ENTITY'.
  ENDMETHOD.
ENDCLASS.