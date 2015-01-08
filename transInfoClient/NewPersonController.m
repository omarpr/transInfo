//
//  NewPersonController.m
//  transinfo
//
//  Created by Omar Soto Fortuño on 12/15/14.
//  Copyright (c) 2014 University of Puerto Rico Mayagüez Campus. All rights reserved.
//

#import "NewPersonController.h"
#import "UIDatePickerOKView.h"
#import "CollectionManager.h"
#import "Utilities.h"
#import "restComm.h"
#import "Config.h"
#import "CarTableViewCell.h"
#import "Vehicle.h"

@interface NewPersonController ()

@property UINavigationBar *navigationBar;

@end

@implementation NewPersonController

- (void)setEditingModeFor:(Person*)person forRegistrationPlate:(NSString*)registrationPlate {
    self.editingPerson = person;
    self.editingRegistrationPlate = registrationPlate;
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:nil action:nil];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"report.third.edit-person", nil)];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [rightButton setAction:@selector(addButonAction:)];
    
    self.personTypeCategoryKey = self.editingPerson.typeCategoryKey;
    self.personTypeKey = [NSString stringWithFormat: @"%ld", (long)self.editingPerson.typeKey];
    self.genderKey = self.editingPerson.genderKey;
    self.licenseTypeKey = self.editingPerson.licenseTypeKey;
    self.organDonorKey = self.editingPerson.organDonorKey;
    
    [self.navigationBar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:self.navigationBar];
}

- (IBAction)addButonAction:(id)sender {
    if (self.navigationBar != nil) {
        NSLog(@"IsEditing!");
        //return;
    } else {
        NSLog(@"Add person!");
    }
    
    NSIndexPath *indexPath = [self.vehicleTableView indexPathForSelectedRow];
    NSString *vehicleLicensePlate = @"";
    
    NSLog(@"%@", indexPath);
    
    if ([self.personTypeCategoryKey isEqualToString:@"1"]) {
        if (indexPath == nil) {
            [Utilities displayAlertWithMessage:NSLocalizedString(@"report.third.required-vehicle.msg", nil) withTitle:NSLocalizedString(@"report.third.required-vehicle.title", nil)];
            return;
        } else {
            Vehicle *vehicle = [self.vehicles objectAtIndex:indexPath.row];
            vehicleLicensePlate = vehicle.registrationPlate;
        }
    }
    
    NSDictionary *personDictionary = @{@"typeCategoryKey" : (self.personTypeCategoryKey == nil) ? @"-1" : self.personTypeCategoryKey,
                                       @"typeKey" : (self.personTypeKey == nil) ? @"-1" : self.personTypeKey,
                                       @"name" : (self.personNameField.text == nil) ? @"" : self.personNameField.text,
                                       @"genderKey" : (self.genderKey == nil) ? @"-1" : self.genderKey,
                                       @"licenseTypeKey" : (self.licenseTypeKey == nil) ? @"-1" : self.licenseTypeKey,
                                       @"driverLicense" : (self.licenseNumberField.text == nil) ? @"" :self.licenseNumberField.text,
                                       @"organDonorKey" : (self.organDonorKey == nil) ? @"-1" : self.organDonorKey,
                                       @"licenseExpirationDate" : (self.licenseExpirationDate == nil) ? @"" : self.licenseExpirationDate,
                                       @"licenseExpirationNA" : @NO,
                                       @"streetAddress" : (self.personStreetAddressField.text == nil) ? @"" : self.personStreetAddressField.text,
                                       @"neighbohood" : (self.personNeighbohoodField.text == nil) ? @"" : self.personNeighbohoodField.text,
                                       @"city" : (self.personCityField.text == nil) ? @"" : self.personCityField.text,
                                       @"stateCountry" : (self.personStateCountryField.text == nil) ? @"" : self.personStateCountryField.text,
                                       @"zipCode" : (self.personZipCodeField.text == nil) ? @"" : self.personZipCodeField.text,
                                       @"phoneNumber" : (self.personPhoneNumberField.text == nil) ? @"" : self.personPhoneNumberField.text,
                                       @"vehicleLicensePlate" : vehicleLicensePlate,
                                       @"uuid" : (self.navigationBar != nil) ? self.editingPerson.uuid : @""};
    
    
    
    NSLog(@"Sending %@", personDictionary);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPerson" object:nil userInfo:personDictionary];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationBar != nil) {
        [self.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [(UIScrollView *)self.view setContentSize:CGSizeMake(700,800)];
        
        self.personNameField.text = self.editingPerson.name;
        self.licenseNumberField.text = self.editingPerson.driverLicense;
        if (self.editingPerson.licenseExpirationDate != nil) {
            self.licenseExpirationDate = self.editingPerson.licenseExpirationDate;
            [self setLicenseExpirationDateFormat];
        }
        self.personStreetAddressField.text = self.editingPerson.streetAddress;
        self.personNeighbohoodField.text = self.editingPerson.neighbohood;
        self.personCityField.text = self.editingPerson.city;
        self.personStateCountryField.text = self.editingPerson.stateCountry;
        self.personZipCodeField.text = self.editingPerson.zipCode;
        self.personPhoneNumberField.text = self.editingPerson.phoneNumber;
        
        self.personTypeCategoryKey = self.editingPerson.typeCategoryKey;
        self.personTypeKey = [NSString stringWithFormat: @"%ld", (long)self.editingPerson.typeKey];
        self.genderKey = self.editingPerson.genderKey;
        self.licenseTypeKey = self.editingPerson.licenseTypeKey;
        self.organDonorKey = self.editingPerson.organDonorKey;
        
        if (self.editingPerson.typeKey == 1) {
            [self licenseAreaIsEnabled:YES];
        } else {
            [self licenseAreaIsEnabled:NO];
        }
    }
    
    //NSLog(@"Size 2: %f", self.view.frame.size.width);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"getVehicles" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestVehicles" object:nil userInfo:nil];
}

- (void)viewDidLoad {
    //NSLog(@"Size 3: %f", self.view.frame.size.width);
    [self loadCollections];
    
    // Delegates
    self.personTypeCategoryField.delegate = self;
    self.personTypeField.delegate = self;
    self.genderField.delegate = self;
    self.licenseTypeField.delegate = self;
    self.organDonorField.delegate = self;
    self.licenseExpirationDateField.delegate = self;
    
    self.vehicleTableView.delegate = self;
    self.vehicleTableView.dataSource = self;
    
    if (self.navigationBar == nil && ![self.editingRegistrationPlate isEqualToString: @""]) {
        self.vehicleTableView.userInteractionEnabled = YES;
    } else {
        self.vehicleTableView.userInteractionEnabled = NO;
    }
    
    //self.vehicleTypeField.enabled = NO;
}

- (void)receiveNotification:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    
    if ([[notification name] isEqualToString:@"getVehicles"]) {
        self.vehicles = [dict objectForKey:@"vehicles"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vehicles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CarCell";
    
    CarTableViewCell *cell = (CarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CarViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Vehicle *vehicle = [self.vehicles objectAtIndex:indexPath.row];
    
    cell.carMake = vehicle.make;
    cell.carModel = vehicle.model;
    cell.carYear = vehicle.year;
    cell.registrationPlate = vehicle.registrationPlate;
    
    if ([vehicle.registrationPlate isEqualToString:self.editingRegistrationPlate]) {
        [cell setSelected:YES];
    }
    
    return cell;
}

- (void)loadCollections {
    self.collections = [[NSMutableDictionary alloc] init];
    
    NSArray *collectionNames = @[@"personTypeCategories", @"personTypes", @"driverLicenseTypes", @"genders", @"organDonor", @"vehicleTypes"];
    
    NSMutableArray *collectionsManagers = [[NSMutableArray alloc] init];
    int i = 0;
    
    for (NSString *collectionName in collectionNames) {
        [self.collections setObject:[NSDate date] forKey:collectionName];
        [collectionsManagers addObject:[[CollectionManager alloc] init]];
        ((CollectionManager*)collectionsManagers[i]).delegate = self;
        [collectionsManagers[i] getCollection:collectionName];
        
        i++;
    }
}

- (void)receivedCollection:(NSArray *)collection withName:(NSString *)collectionName {
    [self.collections setObject:collection forKey:collectionName];
    
    // NSDictionary *personDictionary = @{@"typeCategoryKey" : self.personTypeCategoryKey, @"typeKey" : self.personTypeKey, @"genderKey" : self.genderKey, @"licenseTypeKey" : self.licenseTypeKey, @"organDonorKey" : self.organDonorKey,
    //NSArray *collectionNames = @[@"personTypeCategories", @"personTypes", @"driverLicenseTypes", @"genders", @"organDonor", @"vehicles", @"vehicleTypes"];
    
    //NSLog(@"Received Collection %@ %@", collectionName, collection);
    
    if (self.editingPerson != nil) {
        if ([collectionName isEqualToString:@"personTypeCategories"]) {
            [self loadDefaultForCollection:collectionName toField:self.personTypeCategoryField withKey:@"PersonTypeCategoryID" defaultValue:self.editingPerson.typeCategoryKey];
        } else if ([collectionName isEqualToString:@"personTypes"]) {
            //self.personTypeField.text = [collection objectAtIndex:[self.personTypeKey longLongValue]];
            [self loadDefaultForCollection:collectionName toField:self.personTypeField withKey:@"PersonTypeID" defaultValue:[NSString stringWithFormat:@"%ld", (long)self.editingPerson.typeKey]];
        } else if ([collectionName isEqualToString:@"driverLicenseTypes"]) {
            //self.licenseTypeField.text = [collection objectAtIndex:[self.licenseTypeKey longLongValue]];
            [self loadDefaultForCollection:collectionName toField:self.licenseTypeField withKey:@"DriverLicenseTypeID" defaultValue:self.editingPerson.licenseTypeKey];
        } else if ([collectionName isEqualToString:@"genders"]) {
            //self.genderField.text = [collection objectAtIndex:[self.genderKey longLongValue]];
            [self loadDefaultForCollection:collectionName toField:self.genderField withKey:@"GenderID" defaultValue:self.editingPerson.genderKey];
        } else if ([collectionName isEqualToString:@"organDonor"]) {
            //self.organDonorField.text = [collection objectAtIndex:[self.organDonorKey longLongValue]];
            [self loadDefaultForCollection:collectionName toField:self.organDonorField withKey:@"OrganDonorID" defaultValue:self.editingPerson.organDonorKey];
        }
    }
    
    NSLog(@"Received Collection: %@ (%lu elements)", collectionName, (unsigned long)[collection count]);
}

- (void)loadDefaultForCollection:(NSString*)collectionName toField:(UITextField*)field withKey:(NSString*)key defaultValue:(NSString*)value {
    NSArray *collection = [self.collections objectForKey:collectionName];
    
    NSLog(@"Loading default for %@, value: %@", key, value);
    
    for (NSDictionary *dict in collection) {
        if ([[NSString stringWithFormat:@"%@", [dict objectForKey:key]] isEqualToString:value]) {
            field.text = [dict objectForKey:[Utilities collectionColumn]];
            break;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    
    if (textField == self.personTypeCategoryField) {
        [self showCollection:@"personTypeCategories" withIDColumn:@"PersonTypeCategoryID" withField:textField];
        return NO;
    } else if (textField == self.personTypeField) {
        [self showCollection:@"personTypes" withIDColumn:@"PersonTypeID" withField:textField];
        return NO;
    } else if (textField == self.genderField) {
        [self showCollection:@"genders" withIDColumn:@"GenderID" withField:textField];
        return NO;
    } else if (textField == self.licenseTypeField) {
        [self showCollection:@"driverLicenseTypes" withIDColumn:@"DriverLicenseTypeID" withField:textField];
        return NO;
    } else if (textField == self.organDonorField) {
        [self showCollection:@"organDonor" withIDColumn:@"OrganDonorID" withField:textField];
        return NO;
    } else if (textField == self.licenseExpirationDateField) {
        UIDatePickerOKView *customPicker = [[[NSBundle mainBundle] loadNibNamed:@"UIPickerOKView" owner:self options:nil] objectAtIndex:0];
        
        /*if (self.licenseExpirationDate != nil) {
         customPicker.datePicker.date = self.licenseExpirationDate;
         }*/
        
        customPicker.datePicker.datePickerMode = UIDatePickerModeDate;
        [customPicker.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        customPicker.parent = textField;
        
        textField.inputView = customPicker;
    } else if (textField == self.vehicleTypeField) {
        [self showCollection:@"vehicleTypes" withIDColumn:@"VehicleTypeID" withField:textField];
        return NO;
    }
    
    return YES;
}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDate *pickerDate = [sender date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    if ([self.licenseExpirationDateField isFirstResponder]) {
        self.licenseExpirationDate = pickerDate;
        self.licenseExpirationDateField.text = [dateFormatter stringFromDate:self.licenseExpirationDate];
    }
    
    [self setLicenseExpirationDateFormat];
    
}

- (IBAction)driverIsOwnerSwitchValueChanged:(id)sender {
    if (self.driverIsOwnerSwitch.on) {
        self.vehicleTypeField.enabled = NO;
    } else {
        self.vehicleTypeField.enabled = YES;
    }
}

- (void)setLicenseExpirationDateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.licenseExpirationDateField.text = [dateFormatter stringFromDate:self.licenseExpirationDate];
}

- (void)keysSelected:(NSArray *)keys withIdentifier:(NSString *)identifier {
    NSLog(@"Recibiendo... %@ (%@)", identifier, keys);
    if ([identifier isEqualToString:@"personTypeCategories"]) {
        self.personTypeCategoryKey = keys[0];
        self.personTypeField.text = @"";
        
        self.vehicleTableView.userInteractionEnabled = [self.personTypeCategoryKey isEqualToString:@"1"];
        if ([self.personTypeCategoryKey isEqualToString:@"1"] == NO) {
            [self.vehicleTableView deselectRowAtIndexPath:[self.vehicleTableView indexPathForSelectedRow] animated:YES];
        }
    } else if ([identifier isEqualToString:@"personTypes"]) {
        self.personTypeKey = keys[0];
        if ([keys[0] isEqualToString:@"1"]) {
            // Is Driver
            [self licenseAreaIsEnabled:YES];
        } else {
            // It's not driver
            
            [self licenseAreaIsEnabled:NO];
        }
    } else if ([identifier isEqualToString:@"driverLicenseTypes"]) {
        self.licenseTypeKey = keys[0];
    } else if ([identifier isEqualToString:@"genders"]) {
        self.genderKey = keys[0];
    } else if ([identifier isEqualToString:@"organDonor"]) {
        self.organDonorKey = keys[0];
    }
}

- (void)licenseAreaIsEnabled:(BOOL)isEnabled {
    self.licenseTypeField.enabled = isEnabled;
    self.licenseNumberField.enabled = isEnabled;
    self.organDonorField.enabled = isEnabled;
    self.licenseExpirationDateField.enabled = isEnabled;
}

- (IBAction)showCollection:(NSString*)collectionName withIDColumn:(NSString*)IDColumn withField:(id)field {
    if ([self.collections[collectionName] isKindOfClass:[NSArray class]]) {
        NSMutableDictionary *collection = [[NSMutableDictionary alloc] init];
        
        BOOL isPersonTypes = [collectionName isEqualToString:@"personTypes"];
        
        if (isPersonTypes && self.personTypeCategoryKey == nil) {
            [Utilities displayAlertWithMessage:NSLocalizedString(@"report.third.no-person-type-category.msg", nil) withTitle:NSLocalizedString(@"report.third.no-person-type-category.title", nil) ];
            return;
        }
        
        for (NSDictionary *elem in self.collections[collectionName]) {
            if (isPersonTypes) {
                if (![self.personTypeCategoryKey isEqualToString:[NSString stringWithFormat:@"%@", [elem objectForKey:@"PersonTypeCategoryID"]]]) {
                    continue;
                }
            }
            
            //NSLog(@"%@", elem);
            
            if ([elem objectForKey:[Utilities collectionColumn]] == [NSNull null]) {
                [collection setObject:(NSString*)[elem objectForKey:@"DescriptionES"] forKey:[NSString stringWithFormat:@"%@", [elem objectForKey:IDColumn]]];
            } else {
                [collection setObject:(NSString*)[elem objectForKey:[Utilities collectionColumn]] forKey:[NSString stringWithFormat:@"%@", [elem objectForKey:IDColumn]]];
            }
        }
        
        //NSLog(@"%@ %@ %@", collection, field, collectionName);
        
        [self showPickerView:collection withField:field withIdentifier:collectionName];
    } else {
        NSLog(@"No collection yet... %@", collectionName);
        CollectionManager *collManager = [[CollectionManager alloc] init];
        [collManager getCollection:collectionName];
        collManager.delegate = self;
    }
}

- (void)showPickerView:(NSMutableDictionary*)elements withField:(UITextField*)field withIdentifier:(NSString*)identifier {
    self.pickerView = [[PickerViewController alloc] initWithStyle:UITableViewStylePlain withElementsDictionary:elements withMultipleChoice:NO];
    self.pickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.pickerView];
    
    self.pickerView.delegate = self;
    self.pickerView.outField = field;
    self.pickerView.popover = self.pickerPopover;
    [self.pickerView setIdentifier:identifier];
    
    [self.pickerPopover presentPopoverFromRect:field.bounds inView:field permittedArrowDirections:UIPopoverArrowDirectionUnknown animated:YES];
}

@end