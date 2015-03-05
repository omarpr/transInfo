//
//  Person.m
//  transinfo
//
//  Created by Omar Soto Fortuño on 12/8/14.
//  Copyright (c) 2014 University of Puerto Rico Mayagüez Campus. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize typeCategoryKey;
@synthesize typeKey;
@synthesize name;
@synthesize genderKey;
@synthesize licenseTypeKey;
@synthesize driverLicense;
@synthesize organDonorKey;
@synthesize licenseExpirationDate;
@synthesize licenseExpirationNA;
@synthesize streetAddress;
@synthesize neighbohood;
@synthesize city;
@synthesize stateCountry;
@synthesize zipCode;
@synthesize phoneNumber;
@synthesize uuid;
@synthesize vehicleUuid;

@synthesize rowKey;
@synthesize seatKey;
@synthesize seatingOtherKey;
@synthesize restraintSystemKey;
@synthesize helmetUseKey;

@synthesize airbagDeployedKey;
@synthesize ejectionKey;
@synthesize speedingSuspectedKey;
@synthesize extricationKey;
@synthesize contribActionsCircumstancesKey;
@synthesize distractedByKey;

- (id)init {
    self = [super init];
    
    if (self) {
        self.contribActionsCircumstancesKey = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
