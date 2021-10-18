method get_orders.
  types:
    tyr_aufnr type range of aufnr.
  data:
     order                         type zdim_gw_ls_order,
     lv_system_status              type string,
     lv_sys_status_technical       type string,
     lv_user_status                type string,
     lv_low                        type string,
     lo_filter                     type ref to /iwbep/if_mgw_req_filter,
     lt_select_option              type /iwbep/t_mgw_select_option,
     ls_order_number_select_option type /iwbep/s_mgw_select_option,
     ls_desc_select_option         type /iwbep/s_mgw_select_option,
     ls_funcloc_select_option      type /iwbep/s_mgw_select_option,
     ls_gstrp_select_option        type /iwbep/s_mgw_select_option,
     ls_notif_num_select_option    type /iwbep/s_mgw_select_option,
     ls_funcloc_desc_select_option type /iwbep/s_mgw_select_option,
     ls_equipment_select_option    type /iwbep/s_mgw_select_option,
     ls_equi_desc_select_option    type /iwbep/s_mgw_select_option,
     ls_gltrp_select_option        type /iwbep/s_mgw_select_option,
     ls_prio_select_option         type /iwbep/s_mgw_select_option,
     ls_qmnam_select_option        type /iwbep/s_mgw_select_option,
     ls_nachn_select_option        type /iwbep/s_mgw_select_option,
     ls_vorna_select_option        type /iwbep/s_mgw_select_option,
     ls_parnr_select_option        type /iwbep/s_mgw_select_option,
     ls_sys_stat_select_option     type /iwbep/s_mgw_select_option,
     ls_phase_select_option        type /iwbep/s_mgw_select_option,
     ls_user_stat_select_option    type /iwbep/s_mgw_select_option,
     ls_order_type_select_option   type /iwbep/s_mgw_select_option,
     ltr_order_number              type range of aufnr,
     lr_order_number              type line of tyr_aufnr,
     ltr_order_type                type range of auart,
     ltr_desc                      type range of ktext,
     ll_desc                       like line  of ltr_desc,
     lv_desc                       type auftext,
     ltr_tplnr                     type range of tplnr,
     ltr_gstrp                     type range of co_gstrp,
     ltr_qmnum                     type range of qmnum,
     ltr_pltxt                     type range of pltxt,
     ltr_equnr                     type range of equnr,
     ltr_ktx01                     type range of ktx01,
     ltr_gltrp                     type range of co_gltrp,
     ltr_priok                     type range of priok,
     ltr_qmnam                     type range of qmnam,
     ltr_vorna                     type range of pad_vorna,
     ltr_nachn                     type range of pad_nachn,
     ltr_phase                     type range of j_stonr,
     lv_desc_uc                    type string,
     lv_funcloc_uc                 type string,
     lv_funcloc_desc_uc            type string,
     lv_equi_desc_uc               type string,
     lv_vorna_uc                   type string,
     lv_nachn_uc                   type string,
     lv_qmnam_uc                   type string,
     lt_orders                     type zdim_ls_order_t,
     ls_order                      type zdim_gw_ls_order,
     lt_bapi_ranges                type eams_t_order_range,
     ls_bapi_ranges                type bapi_alm_order_listhead_ranges,
     lt_result type table of bapi_alm_order_listhead_result,
     ls_result type bapi_alm_order_listhead_result,
     lt_return type bapiret2_t,
     lv_top type int4,
     lv_skip type int4,
     lv_diff type int4,
     lv_total_lines type int4,
     lv_do type boole_d,
     lv_last type boole_d.

  field-symbols:
     <fs_order>        type zdim_gw_ls_order,
     <fs_order_uc>     type zdim_gw_ls_order,
     <fs_user_stat>    type /iwbep/s_cod_select_option,
     <fs_sys_stat>     type /iwbep/s_cod_select_option,
     <fs_opt>          type any,
     <fs_low>          type any.

  if not io_tech_request_context is initial.
    lo_filter = io_tech_request_context->get_filter( ).
    lt_select_option = lo_filter->get_filter_select_options( ).

*   Performance issue (do not execute any query without filters)
    check lt_select_option is not initial.

    read table lt_select_option into ls_order_number_select_option with table key property = 'ORDER_NUMBER'.
    read table lt_select_option into ls_order_type_select_option   with table key property = 'ORDER_TYPE'.
    read table lt_select_option into ls_desc_select_option         with table key property = 'DESCRIPTION'.
    read table lt_select_option into ls_funcloc_select_option      with table key property = 'TECHNICAL_OBJECT'.
    read table lt_select_option into ls_gstrp_select_option        with table key property = 'START_DATE'.
    read table lt_select_option into ls_gltrp_select_option        with table key property = 'FINISH_DATE'.
    read table lt_select_option into ls_notif_num_select_option    with table key property = 'NOTIFICATION_NUMBER'.
    read table lt_select_option into ls_funcloc_desc_select_option with table key property = 'TECHNICAL_OBJECT_DESCRIPTION'.
    read table lt_select_option into ls_equipment_select_option    with table key property = 'EQUIPMENT_NUMBER'.
    read table lt_select_option into ls_equi_desc_select_option    with table key property = 'EQUIPMENT_DESCRIPTION'.
    read table lt_select_option into ls_prio_select_option         with table key property = 'PRIORITY'.
    read table lt_select_option into ls_qmnam_select_option        with table key property = 'REPORTED_BY'.
    read table lt_select_option into ls_vorna_select_option        with table key property = 'RP_FIRST_NAME'.
    read table lt_select_option into ls_nachn_select_option        with table key property = 'RP_LAST_NAME'.
    read table lt_select_option into ls_parnr_select_option        with table key property = 'RESPONSIBLE_PERSON'.
    read table lt_select_option into ls_sys_stat_select_option     with table key property = 'SYSTEM_STATUS'.
    read table lt_select_option into ls_phase_select_option        with table key property = 'PHASE'.
    read table lt_select_option into ls_user_stat_select_option    with table key property = 'USER_STATUS'.

*    loop at ls_user_stat_select_option-select_options assigning <fs_user_stat>.
*      clear lv_low.
*      assign component: 'LOW'  of structure <fs_user_stat> to <fs_low>,
*                        'OPTION' of structure <fs_user_stat> to <fs_opt>.
*
*      concatenate '*' <fs_low> '*' into lv_low.
*      <fs_low> = lv_low.
*      <fs_opt> = 'CP'.
*    endloop.
    map_selection_to_bapi_range(
      exporting
        iv_field_name   = 'OPTIONS_FOR_STATUS_INCLUSIVE'     " Component name
        is_sel_criteria = ls_user_stat_select_option    " NAV - Range table line
      changing
        et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
    ).

*    loop at ls_sys_stat_select_option-select_options assigning <fs_sys_stat>.
*      clear lv_low.
*      assign component: 'LOW'  of structure <fs_sys_stat> to <fs_low>,
*                        'OPTION' of structure <fs_sys_stat> to <fs_opt>.
*
*      concatenate '*' <fs_low> '*' into lv_low.
*      <fs_low> = lv_low.
*      <fs_opt> = 'CP'.
*    endloop.
    map_selection_to_bapi_range(
       exporting
         iv_field_name   = 'OPTIONS_FOR_STATUS_INCLUSIVE'     " Component name
         is_sel_criteria = ls_sys_stat_select_option    " NAV - Range table line
       changing
         et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
     ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_order_number_select_option
*    importing
*      et_select_option = ltr_order_number ).
    map_selection_to_bapi_range(
      exporting
        iv_field_name   = 'OPTIONS_FOR_ORDERID'     " Component name
        is_sel_criteria = ls_order_number_select_option    " NAV - Range table line
      changing
        et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_order_type_select_option
*    importing
*      et_select_option = ltr_order_type ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_DOC_TYPE'     " Component name
       is_sel_criteria = ls_order_type_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_desc_select_option
*    importing
*      et_select_option = ltr_desc ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_SHORT_TEXT'     " Component name
       is_sel_criteria = ls_desc_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_desc
*    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_funcloc_select_option
*    importing
*      et_select_option = ltr_tplnr ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_FUNCLOC'     " Component name
       is_sel_criteria = ls_funcloc_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_tplnr
*    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_gstrp_select_option
*    importing
*      et_select_option = ltr_gstrp ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_START_DATE'     " Component name
       is_sel_criteria = ls_gstrp_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_notif_num_select_option
*    importing
*      et_select_option = ltr_qmnum ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_NOTIF_NO'     " Component name
       is_sel_criteria = ls_notif_num_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_gltrp_select_option
*    importing
*      et_select_option = ltr_gltrp ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_FINISH_DATE'     " Component name
       is_sel_criteria = ls_gltrp_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_funcloc_desc_select_option
*    importing
*      et_select_option = ltr_pltxt ).

*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_pltxt
*    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_equipment_select_option
*    importing
*      et_select_option = ltr_equnr ).
    map_selection_to_bapi_range(
         exporting
           iv_field_name   = 'OPTIONS_FOR_EQUIPMENT'     " Component name
           is_sel_criteria = ls_equipment_select_option    " NAV - Range table line
         changing
           et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
       ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_equi_desc_select_option
*    importing
*      et_select_option = ltr_ktx01 ).
*
*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_ktx01
*    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_prio_select_option
*    importing
*      et_select_option = ltr_priok ).
    map_selection_to_bapi_range(
     exporting
       iv_field_name   = 'OPTIONS_FOR_PRIORITY'     " Component name
       is_sel_criteria = ls_prio_select_option    " NAV - Range table line
     changing
       et_bapi_ranges  = lt_bapi_ranges    " ALM Order BAPIs: Copy Structure for Selection Parameter
   ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_qmnam_select_option
*    importing
*      et_select_option = ltr_qmnam ).
*
*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_qmnam
*    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_vorna_select_option
*    importing
*      et_select_option = ltr_vorna ).
*
*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_vorna
*    ).
*
*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_nachn_select_option
*    importing
*      et_select_option = ltr_nachn ).
*
*    zcl_tab_convert_util=>convert_range_tab_to_upper(
*      changing
*        range = ltr_nachn
*    ).

    lo_filter->convert_select_option(
      exporting
        is_select_option = ls_phase_select_option
      importing
        et_select_option = ltr_phase
    ).

*    lo_filter->convert_select_option(
*    exporting
*      is_select_option = ls_parnr_select_option
*    importing
*      et_select_option = ltr_parnr ).
  else.
    ltr_order_number = it_order_filter.
    loop at it_order_filter into lr_order_number.
      clear ls_bapi_ranges.
      ls_bapi_ranges-field_name = 'OPTION_FOR_ORDERID'.
      ls_bapi_ranges-sign = lr_order_number-sign.
      ls_bapi_ranges-option = lr_order_number-option.
      ls_bapi_ranges-low_value = lr_order_number-low.
      append ls_bapi_ranges to lt_bapi_ranges.
    endloop.
  endif.

  if iv_search_string is not initial.
    concatenate '*' iv_search_string '*' into lv_desc.
*    ll_desc-sign = 'I'.
*    ll_desc-option = 'CP'.
*    ll_desc-low = lv_desc.
*    append ll_desc to ltr_desc.

    clear ls_bapi_ranges.
    ls_bapi_ranges-field_name = 'OPTION_FOR_SHORT_TEXT'.
    ls_bapi_ranges-sign = 'I'.
    ls_bapi_ranges-option = 'CP'.
    ls_bapi_ranges-low_value = lv_desc.
    append ls_bapi_ranges to lt_bapi_ranges.

  endif.

  data: ls_param type bapi_alm_list_navigation_in.

  if io_tech_request_context->get_top( ) is initial.
    return.
  endif.
  ls_param-pagelength = io_tech_request_context->get_top( ).
  ls_param-show_page_number = io_tech_request_context->get_top( ) / 20.

  "show all documents
  clear ls_bapi_ranges.
  ls_bapi_ranges-field_name = 'SHOW_OPEN_DOCUMENTS'.
  ls_bapi_ranges-low_value = 'X'.
  append ls_bapi_ranges to lt_bapi_ranges.

  clear ls_bapi_ranges.
  ls_bapi_ranges-field_name = 'SHOW_DOCUMENTS_IN_PROCESS'.
  ls_bapi_ranges-low_value = 'X'.
  append ls_bapi_ranges to lt_bapi_ranges.

  clear ls_bapi_ranges.
  ls_bapi_ranges-field_name = 'SHOW_COMPLETED_DOCUMENTS'.
  ls_bapi_ranges-low_value = 'X'.
  append ls_bapi_ranges to lt_bapi_ranges.

  clear ls_bapi_ranges.
  ls_bapi_ranges-field_name = 'SHOW_HISTORICAL_DOCUMENTS'.
  ls_bapi_ranges-low_value = 'X'.
  append ls_bapi_ranges to lt_bapi_ranges.

  clear ls_bapi_ranges.
  ls_bapi_ranges-field_name = 'SHOW_DOCS_WITH_FROM_DATE'.
  ls_bapi_ranges-low_value = '00000000'.
  append ls_bapi_ranges to lt_bapi_ranges.

  call function 'BAPI_ALM_ORDERHEAD_GET_LIST'
     exporting
       display_parameters = ls_param    " ALM Order Lists: Parameter for Navigation
*     importing
*       navigation_data    =     " ALM Order Lists: Basic Dates for Navigation
    tables
      it_ranges          = lt_bapi_ranges     " ALM Order BAPIs: Copy Structure for Selection Parameter
      et_result          = lt_result    " ALM Orders: Order List from Selection
*       et_template        =     " ALM Order BAPIs: Copy Structure for Selection Parameter
      return             = lt_return    " Return Parameters
    .

  loop at lt_result into ls_result.
    clear ls_order.

    ls_order-order_number = ls_result-orderid.
    ls_order-order_type = ls_result-order_type.
    ls_order-description = ls_result-short_text.
    ls_order-technical_object = ls_result-funcloc.
    ls_order-technical_object_description = ls_result-funcldescr.
    ls_order-start_date = ls_result-start_date.
    ls_order-finish_date = ls_result-finish_date.
    ls_order-notification_number = ls_result-notif_no.
    ls_order-priority = ls_result-priority.
    ls_order-equipment_number = ls_result-equipment.
*    ls_order-responsible_person
    ls_order-equipment_description = ls_result-equidescr.
    ls_order-reported_by = ls_result-entered_by.
*    ls_order-rp_first_name
*    ls_order-rp_last_name
    ls_order-system_status = ls_result-s_status.
*    ls_order-system_status_technical = ls_result-
    ls_order-user_status = ls_result-u_status.
    ls_order-phase = ls_result-phase.
    ls_order-phase_description = ls_result-phase.
    ls_order-object_number = ls_result-object_no.

    append ls_order to rt_orders.
  endloop.
*
*  lv_top = io_tech_request_context->get_top( ).
*  if lv_top is initial.
*    return.
*  endif.
*  lv_skip = io_tech_request_context->get_skip( ).
*  lv_diff = lv_top - lv_skip.
*  lv_top = lv_top + lv_skip.
*
*
*  select count( * )
*    into lv_total_lines
*    from aufk
*      inner join afih   on aufk~aufnr   = afih~aufnr
*      inner join afko   on aufk~aufnr   = afko~aufnr
*      inner join iloa   on afih~iloan   = iloa~iloan
*    where aufk~aufnr   in ltr_order_number
*      and aufk~auart   in ltr_order_type
*      "and aufk~ktext   in ltr_desc
*      "and iloa~tplnr   in ltr_tplnr
*      and afko~gstrp   in ltr_gstrp
*      and afih~qmnum   in ltr_qmnum
*      "and iflotx~pltxt in ltr_pltxt
*      and afih~equnr   in ltr_equnr
*      "and eqkt~eqktx   in ltr_ktx01
*      and afko~gltrp   in ltr_gltrp
*      and afih~priok   in ltr_priok.
*
*  while lv_do = abap_false or ( lv_top < lv_total_lines and lines( rt_orders ) < io_tech_request_context->get_top( ) ).
*    lv_do = abap_true. " this boolean is used to execute a do while loop, this sql statement always has to be executed at least once
*    select aufk~aufnr   as order_number
*           aufk~auart   as order_type
*           aufk~ktext   as description
*           iloa~tplnr   as technical_object
*           iflotx~pltxt as technical_object_description
*           afko~gstrp   as start_date
*           afko~gltrp   as finish_date
*           afih~qmnum   as notification_number
*           afih~priok   as priority
*           afih~equnr   as equipment_number
*           ihpa~parnr   as responsible_person
*           eqkt~eqktx   as equipment_description
*           qmel~qmnam   as reported_by
*           ihpa~vorna   as rp_first_name
*           ihpa~nachn   as rp_last_name
**         tj02t~txt04  as system_status
**         tj02t~istat  as system_status_technical
**         tj30t~txt04  as user_status
**         tj30~stonr   as phase
**         tj30t~txt30  as phase_description
*           aufk~objnr   as object_number
*    into corresponding fields of table rt_orders
*    up to lv_top rows
*    from aufk
*      inner join afih   on aufk~aufnr   = afih~aufnr
*      inner join afko   on aufk~aufnr   = afko~aufnr
*      inner join iloa   on afih~iloan   = iloa~iloan
*      left outer join qmel   on afih~qmnum   = qmel~qmnum
**    inner join jest   on aufk~objnr   = jest~objnr
**                     and jest~inact  <> 'X'
*      left outer join iflotx               on iloa~tplnr   = iflotx~tplnr
*                                          and iflotx~spras = sy-langu
*      left outer join eqkt                 on afih~equnr   = eqkt~equnr
*                                          and eqkt~spras   = sy-langu
*      left outer join zihpa_name_v as ihpa on aufk~objnr   = ihpa~objnr
*                                          and ihpa~parvw   = 'VW'
*                                          and ihpa~kzloesch = abap_false
**    left outer join tj02t                on jest~stat    = tj02t~istat
**                                        and tj02t~spras  = sy-langu
**    left outer join tj30                 on jest~stat    = tj30~estat
**                                        and tj30~stsma  = 'ZPM00003'
**    left outer join tj30t                on jest~stat    = tj30t~estat
**                                        and tj30t~stsma  = 'ZPM00003'
**                                        and tj30t~spras  = sy-langu
*    where aufk~aufnr   in ltr_order_number
*      and aufk~auart   in ltr_order_type
*      "and aufk~ktext   in ltr_desc
*      "and iloa~tplnr   in ltr_tplnr
*      and afko~gstrp   in ltr_gstrp
*      and afih~qmnum   in ltr_qmnum
*      "and iflotx~pltxt in ltr_pltxt
*      and afih~equnr   in ltr_equnr
*      "and eqkt~eqktx   in ltr_ktx01
*      and afko~gltrp   in ltr_gltrp
*      and afih~priok   in ltr_priok.
*    "and qmel~qmnam   in ltr_qmnam
**    and (    jest~stat = 'I0002'
**          or jest~stat = 'I0045'
**          or jest~stat = 'I0001'
**          or jest~stat = 'I0046'
**          or jest~stat = 'I0010'
**          or jest~stat = 'I0076'
**          or jest~stat like 'E%').
*    "     and pa0002~vorna in ltr_vorna
*    "   and pa0002~nachn in ltr_nachn
*    "   and ihpa~parnr   in ls_parnr_select_option-select_options.
*
*    if lv_skip is not initial.
*      delete rt_orders to lv_skip.
*    endif.
*
*    loop at rt_orders assigning <fs_order_uc>.
*      lv_desc_uc         = <fs_order_uc>-description.
*      lv_funcloc_uc      = <fs_order_uc>-technical_object.
*      lv_funcloc_desc_uc = <fs_order_uc>-technical_object_description.
*      lv_equi_desc_uc    = <fs_order_uc>-equipment_description.
*      lv_vorna_uc        = <fs_order_uc>-rp_first_name.
*      lv_nachn_uc        = <fs_order_uc>-rp_last_name.
*      lv_qmnam_uc        = <fs_order_uc>-reported_by.
*      translate lv_desc_uc         to upper case.
*      translate lv_funcloc_uc      to upper case.
*      translate lv_funcloc_desc_uc to upper case.
*      translate lv_equi_desc_uc    to upper case.
*      translate lv_vorna_uc        to upper case.
*      translate lv_nachn_uc        to upper case.
*      translate lv_qmnam_uc        to upper case.
*      <fs_order_uc>-description_uc           = lv_desc_uc.
*      <fs_order_uc>-technical_object_uc      = lv_funcloc_uc.
*      <fs_order_uc>-technical_object_desc_uc = lv_funcloc_desc_uc.
*      <fs_order_uc>-equipment_desc_uc        = lv_equi_desc_uc.
*      <fs_order_uc>-rp_first_name_uc         = lv_vorna_uc.
*      <fs_order_uc>-rp_last_name_uc          = lv_nachn_uc.
*      <fs_order_uc>-reported_by_uc           = lv_qmnam_uc.
*    endloop.
*
*    delete rt_orders where description_uc           not in ltr_desc.
*    delete rt_orders where technical_object_uc      not in ltr_tplnr.
*    delete rt_orders where technical_object_desc_uc not in ltr_pltxt.
*    delete rt_orders where equipment_desc_uc        not in ltr_ktx01.
*    delete rt_orders where rp_first_name_uc         not in ltr_vorna.
*    delete rt_orders where rp_last_name_uc          not in ltr_nachn.
*    delete rt_orders where reported_by_uc           not in ltr_qmnam.
*    delete rt_orders where responsible_person       not in ls_parnr_select_option-select_options.
*
*
** retrieve user statusses
*    lt_orders[] = rt_orders[].
*    if lines( lt_orders ) > 0.
*      select
*          jest~objnr   as object_number
*          tj02t~txt04  as system_status
*          tj02t~istat  as system_status_technical
*          tj30t~txt04  as user_status
*          tj30~stonr   as phase
*          tj30t~txt30  as phase_description
*        from jest
*         left outer join tj02t                on jest~stat    = tj02t~istat
*                                             and tj02t~spras  = sy-langu
*         left outer join tj30                 on jest~stat    = tj30~estat
*                                             and tj30~stsma  = 'ZPM00003'
*         left outer join tj30t                on jest~stat    = tj30t~estat
*                                             and tj30t~stsma  = 'ZPM00003'
*                                             and tj30t~spras  = sy-langu
*        into corresponding fields of table rt_orders
*        for all entries in lt_orders
*        where jest~objnr = lt_orders-object_number
*          and jest~inact = abap_false
*          and (    jest~stat = 'I0002'
*              or jest~stat = 'I0045'
*              or jest~stat = 'I0001'
*              or jest~stat = 'I0046'
*              or jest~stat = 'I0010'
*              or jest~stat = 'I0076'
*              or jest~stat like 'E%').
*
*      loop at rt_orders assigning <fs_order>.
*        clear lv_user_status.
*        clear lv_system_status.
*        if <fs_order>-phase is initial and <fs_order>-user_status is not initial.
*          lv_user_status = <fs_order>-user_status.
*        elseif <fs_order>-system_status is not initial.
*          lv_system_status = <fs_order>-system_status.
*          lv_sys_status_technical = <fs_order>-system_status_technical.
*          if <fs_order>-system_status_technical = 'I0045'.
*            <fs_order>-teco_flag = abap_true.
*          endif.
*        endif.
*        loop at rt_orders into order where object_number = <fs_order>-object_number. "order_number = <fs_order>-order_number.
*          if order-system_status is initial and order-user_status is not initial and <fs_order>-user_status <> order-user_status.
*            if order-phase is not initial.
*              <fs_order>-phase = order-phase.
*              <fs_order>-phase_description = order-phase_description.
*            else.
*              if lv_user_status is initial.
*                lv_user_status = order-user_status.
*              else.
*                concatenate order-user_status ', ' lv_user_status into lv_user_status.
*              endif.
*            endif.
*            delete rt_orders index sy-tabix.
*          endif.
*
*          if order-system_status is not initial and order-user_status is initial and <fs_order>-system_status <> order-system_status.
*            if order-system_status_technical = 'I0045'.
*              <fs_order>-teco_flag = abap_true.
*            endif.
*
*            if lv_system_status is initial.
*              lv_system_status = order-system_status.
*              lv_sys_status_technical = order-system_status_technical.
*            else.
*              concatenate order-system_status ', ' lv_system_status into lv_system_status.
*              concatenate order-system_status_technical ', ' lv_sys_status_technical into lv_sys_status_technical.
*            endif.
*            delete rt_orders index sy-tabix.
*          endif.
*        endloop.
*
** save phase
*        order-phase = <fs_order>-phase.
*        order-phase_description = <fs_order>-phase_description.
*        read table lt_orders into ls_order with table key object_number = <fs_order>-object_number.
*        move-corresponding ls_order to <fs_order>.
*        <fs_order>-user_status = lv_user_status.
*        <fs_order>-system_status = lv_system_status.
*        <fs_order>-system_status_technical = lv_sys_status_technical.
*        <fs_order>-phase = order-phase.
*        <fs_order>-phase_description = order-phase_description.
*      endloop.
*
*      delete rt_orders where user_status not in ls_user_stat_select_option-select_options.
*      delete rt_orders where system_status not in ls_sys_stat_select_option-select_options.
*      delete rt_orders where phase not in ltr_phase.
*      delete adjacent duplicates from rt_orders comparing order_number.
*    endif.
*
*    lv_skip = lv_top.
*    lv_top = lv_top + lv_diff.
*    "If top is bigger then lv_total_lines, execute the query one last time.
*    if lv_top > lv_total_lines and lv_last = abap_false.
*      lv_top = lv_total_lines.
*      lv_last = abap_true.
*    endif.
*  endwhile.

endmethod.