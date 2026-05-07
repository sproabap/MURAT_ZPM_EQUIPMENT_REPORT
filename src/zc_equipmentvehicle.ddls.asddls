@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Equipment Vehicle'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_EquipmentVehicle
  as projection on ZI_EquipmentVehicle

{
  key     Equipment,

          EquipmentNameTurkish,
//          EquipmentNameEnglish,
          InspectionEndDate,
          InsuranceEndDate,
          TrafficEndDate,
          PersonalAccidentEndDate,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PM_EQUIPMENTVEHICLE_IMPL'
  virtual VehicleErrors : abap.string(0),

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PM_EQUIPMENTVEHICLE_IMPL'
  virtual VehicleCriticality : abap.int1,

          InspectionCriticality,
          InsuranceCriticality,
          TrafficCriticality,
          PersonalAccidentCriticality
}
