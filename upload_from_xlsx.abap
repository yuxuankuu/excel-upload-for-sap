*&---------------------------------------------------------------------*
*& Report ZBMM0054
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBMM0054.

INCLUDE ZBMM0054TOP.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_mm18 RADIOBUTTON GROUP rad1 USER-COMMAND rad1 DEFAULT 'X',
            p_mm21 RADIOBUTTON GROUP rad1,
            p_mm24 RADIOBUTTON GROUP rad1.

*SELECT-OPTIONS: p_year FOR ZTMM0024-GJAHR NO-EXTENSION NO INTERVALS MODIF ID ID1 OBLIGATORY.
PARAMETERS: p_year(4) MODIF ID ID1. "OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.
PARAMETERS: p_upfil LIKE RLGRAP-FILENAME. "OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-t03.
*PARAMETERS: p_test AS CHECKBOX DEFAULT 'X'.
PARAMETERS: p_dcpfm AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b3.

INCLUDE ZBMM0054F01.

INITIALIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_upfil.
  PERFORM FILENAME_GET.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN .
    IF p_mm24 = abap_false.
      IF screen-group1 = 'ID1'.
        screen-active = '0'.
        MODIFY SCREEN.
      ELSE.
        screen-active = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.


START-OF-SELECTION.

IF p_mm24 IS NOT INITIAL AND p_year IS INITIAL.
  MESSAGE s398(00) WITH TEXT-M01 DISPLAY LIKE 'E'.
  EXIT.
ELSE.
ENDIF.

IF p_upfil IS INITIAL.
  MESSAGE s398(00) WITH TEXT-M02 DISPLAY LIKE 'E'.
  EXIT.
ELSE.
ENDIF.



PERFORM GET_EXCEL.

IF p_mm18 IS NOT INITIAL.

  IF g_message IS INITIAL.

    IF I_TABLE18[] IS INITIAL.
      MESSAGE TEXT-M05 TYPE 'I' DISPLAY LIKE 'E'.

    ELSEIF I_TABLE18[] IS NOT INITIAL.
      PERFORM PROCESS_DATA.

      MESSAGE TEXT-M04 TYPE 'I' DISPLAY LIKE 'S'.

*... Select Data
      select * from ZTMM0018 into corresponding fields of table GT_TABLE18.

*... Create Instance
      call method cl_salv_table=>factory
       IMPORTING
        R_SALV_TABLE = gr_table
       changing
        t_table = GT_TABLE18.

*... Open alv std functions
      gr_table->get_functions( )->set_all( abap_true ).

*... Display Table
      gr_table->display( ).

    ENDIF.

  ELSE.
    MESSAGE g_message TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ELSEIF p_mm21 IS NOT INITIAL.

  IF g_message IS INITIAL.

    IF I_TABLE21[] IS INITIAL.
      MESSAGE TEXT-M05 TYPE 'I' DISPLAY LIKE 'E'.

    ELSEIF I_TABLE21[] IS NOT INITIAL.
      PERFORM PROCESS_DATA_ZTMM0021.

      MESSAGE TEXT-M04 TYPE 'I' DISPLAY LIKE 'S'.

*... Select Data
      select * from ZTMM0021 into corresponding fields of table GT_TABLE21.

*... Create Instance
      call method cl_salv_table=>factory
       IMPORTING
        R_SALV_TABLE = gr_table
       changing
        t_table = GT_TABLE21.

*... Open alv std functions
      gr_table->get_functions( )->set_all( abap_true ).

*... Display Table
      gr_table->display( ).

    ENDIF.

  ELSE.
    MESSAGE g_message TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ELSEIF p_mm24 IS NOT INITIAL.

  IF g_message IS INITIAL.

    IF I_TABLE24[] IS INITIAL.
      MESSAGE TEXT-M05 TYPE 'I' DISPLAY LIKE 'E'.

    ELSEIF I_TABLE24[] IS NOT INITIAL.
      PERFORM PROCESS_DATA_ZTMM0024.

      MESSAGE TEXT-M04 TYPE 'I' DISPLAY LIKE 'S'.

*... Select Data
      select * from ZTMM0024 into corresponding fields of table GT_TABLE24.

*... Create Instance
      call method cl_salv_table=>factory
       IMPORTING
        R_SALV_TABLE = gr_table
       changing
        t_table = GT_TABLE24.

*... Open alv std functions
      gr_table->get_functions( )->set_all( abap_true ).

*... Display Table
      gr_table->display( ).

    ENDIF.

  ELSE.
    MESSAGE g_message TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDIF.


END-OF-SELECTION.