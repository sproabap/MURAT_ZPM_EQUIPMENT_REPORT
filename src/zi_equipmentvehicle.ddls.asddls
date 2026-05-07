@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Equipment Vehicle'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_EquipmentVehicle
  as select from I_Equipment as Equipment

{
  key Equipment.Equipment,

      Equipment._EquipmentText[1: Language = 'T'].EquipmentName as EquipmentNameTurkish,
//      Equipment._EquipmentText[1: Language = 'E'].EquipmentName as EquipmentNameEnglish,
      Equipment.YY1_InspectionEnd_IEQ                           as InspectionEndDate,
      Equipment.YY1_InsuranceEndDate_IEQ                        as InsuranceEndDate,
      Equipment.YY1_TrafficEndDate_IEQ                          as TrafficEndDate,
      Equipment.YY1_PersAccidentEndDat_IEQ                      as PersonalAccidentEndDate,

      case
        when dats_days_between( $session.system_date, Equipment.YY1_InspectionEnd_IEQ ) < 0 then 1
        when dats_days_between( $session.system_date, Equipment.YY1_InspectionEnd_IEQ ) between 0 and 30 then 2
        when dats_days_between( $session.system_date, Equipment.YY1_InspectionEnd_IEQ ) > 31 then 3
        else 0
      end                                                       as InspectionCriticality,

      case
        when dats_days_between( $session.system_date, Equipment.YY1_InsuranceEndDate_IEQ ) < 0 then 1
        when dats_days_between( $session.system_date, Equipment.YY1_InsuranceEndDate_IEQ ) between 0 and 30 then 2
        when dats_days_between( $session.system_date, Equipment.YY1_InsuranceEndDate_IEQ ) > 30 then 3
        else 0
      end                                                       as InsuranceCriticality,

      case
        when dats_days_between( $session.system_date, Equipment.YY1_TrafficEndDate_IEQ ) < 0 then 1
        when dats_days_between( $session.system_date, Equipment.YY1_TrafficEndDate_IEQ ) between 0 and 30 then 2
        when dats_days_between( $session.system_date, Equipment.YY1_TrafficEndDate_IEQ ) > 30 then 3
        else 0
      end                                                       as TrafficCriticality,

      case
        when dats_days_between( $session.system_date, Equipment.YY1_PersAccidentEndDat_IEQ ) < 0 then 1
        when dats_days_between( $session.system_date, Equipment.YY1_PersAccidentEndDat_IEQ ) between 0 and 30 then 2
        when dats_days_between( $session.system_date, Equipment.YY1_PersAccidentEndDat_IEQ ) > 30 then 3
        else 0
      end                                                       as PersonalAccidentCriticality
}

where Equipment.EquipmentCategory = 'M';
