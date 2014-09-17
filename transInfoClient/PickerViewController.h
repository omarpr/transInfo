//
//  PickerViewController.h
//  transinfo
//
//  Created by Omar Soto Fortuño on 9/11/14.
//  Copyright (c) 2014 University of Puerto Rico Mayagüez Campus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style withElementsDictionary:(NSMutableDictionary*)elementsDictionary withMultipleChoice:(BOOL)isMultipleChoice;

@property (nonatomic, strong) NSString *selectedKey;
@property (nonatomic, strong) UITextField *outField;
@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, strong) NSMutableDictionary *elementsDictionary;
@property (nonatomic, strong) NSArray *elementKeys;
@property BOOL isMultipleChoice;


@end
