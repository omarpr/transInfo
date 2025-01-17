//
//  NewVehicleController.h
//  transinfo
//
//  Created by Omar Soto Fortuño on 12/15/14.
//  Copyright (c) 2014 University of Puerto Rico Mayagüez Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "Vehicle.h"

@interface NewVehicleController : UIViewController <UITextFieldDelegate, UIPopoverPresentationControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *vehicleTypeField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleOccupantsField;

@property (weak, nonatomic) IBOutlet UITextField *vehicleLicensePlateField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleJurisdictionField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleRegistrationStateField;

@property (weak, nonatomic) IBOutlet UITextField *vehicleIdentificationNumberField;
@property (weak, nonatomic) IBOutlet UIButton *searchVehicleInformationButton;
@property (weak, nonatomic) IBOutlet UITextField *vehicleYearField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleMakeField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleModelField;

@property (weak, nonatomic) IBOutlet UITextField *vehicleRegistrationNumberField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleInsuranceField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleBuyDateField;
@property (weak, nonatomic) IBOutlet UITextField *vehicleRegistrationExpirationDateField;

@property NSDate *vehicleBuyDate;
@property NSDate *vehicleRegistrationExpirationDate;

@property NSString *trash;
@property NSMutableDictionary *collections;
@property (nonatomic, strong) PickerViewController *pickerView;
@property (nonatomic, strong) UIPopoverController *pickerPopover;

@property Vehicle *editingVehicle;

@property NSMutableArray *viewElements;

- (void)showPickerView:(NSMutableDictionary*)elements withField:(UITextField*)field withIdentifier:(NSString*)identifier;
- (void)setEditingModeFor:(Vehicle*)vehicle;

@end
