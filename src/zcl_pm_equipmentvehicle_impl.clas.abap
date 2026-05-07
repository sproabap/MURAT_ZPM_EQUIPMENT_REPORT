CLASS zcl_pm_equipmentvehicle_impl DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.



CLASS ZCL_PM_EQUIPMENTVEHICLE_IMPL IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_original_data      TYPE STANDARD TABLE OF ZC_EquipmentVehicle WITH DEFAULT KEY.
    DATA condensed_description TYPE c LENGTH 40.

    MOVE-CORRESPONDING it_original_data TO lt_original_data.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      IF <fs_original_data>-EquipmentNameTurkish IS INITIAL.
        MESSAGE e001(zpm_equipment_report) INTO DATA(message).
        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>cr_lf }|.
      ENDIF.

*      IF <fs_original_data>-EquipmentNameEnglish IS INITIAL.
*        MESSAGE e002(zpm_equipment_report) INTO message.
*        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
*      ENDIF.

*      IF <fs_original_data>-EquipmentNameTurkish <> <fs_original_data>-EquipmentNameEnglish.
*        MESSAGE e003(zpm_equipment_report) INTO message.
*        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
*      ENDIF.

      IF <fs_original_data>-InspectionEndDate IS INITIAL.
        MESSAGE e004(zpm_equipment_report) INTO message.
        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      IF <fs_original_data>-InsuranceEndDate IS INITIAL.
        MESSAGE e005(zpm_equipment_report) INTO message.
        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      IF <fs_original_data>-TrafficEndDate IS INITIAL.
        MESSAGE e006(zpm_equipment_report) INTO message.
        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      IF <fs_original_data>-PersonalAccidentEndDate IS INITIAL.
        MESSAGE e007(zpm_equipment_report) INTO message.
        <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
      ENDIF.

*      DATA(plate) = COND maktx( WHEN <fs_original_data>-EquipmentNameTurkish IS NOT INITIAL
*                                THEN <fs_original_data>-EquipmentNameTurkish
*                                ELSE <fs_original_data>-EquipmentNameEnglish ).

      DATA(plate) = <fs_original_data>-EquipmentNameTurkish.

      IF plate IS NOT INITIAL.
        IF strlen( plate ) <> 8 AND strlen( plate ) <> 7.
          MESSAGE e001(zmm_custom_logic) INTO message.
          <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
        ENDIF.

        IF plate <> to_upper( plate ).
          MESSAGE e002(zmm_custom_logic) INTO message.
          <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
        ENDIF.

        condensed_description = plate.
        condensed_description = condense( val  = condensed_description
                                          from = ` `
                                          to   = `` ).
        IF plate <> condensed_description.
          MESSAGE e004(zmm_custom_logic) INTO message.
          <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
        ENDIF.

        SELECT SINGLE COUNT(*) FROM I_EquipmentText
          WHERE Equipment     <> @<fs_original_data>-Equipment
            AND EquipmentName  = @plate.
        IF sy-subrc = 0.
          MESSAGE e008(zpm_equipment_report) WITH plate INTO message.
          <fs_original_data>-VehicleErrors = |{ <fs_original_data>-VehicleErrors }{ message }{ cl_abap_char_utilities=>newline }|.
        ENDIF.
      ENDIF.

      IF <fs_original_data>-VehicleErrors IS NOT INITIAL.
        <fs_original_data>-VehicleCriticality = 1.
      ELSE.
        <fs_original_data>-VehicleCriticality = 3.
      ENDIF.
    ENDLOOP.

    MOVE-CORRESPONDING lt_original_data TO ct_calculated_data.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
