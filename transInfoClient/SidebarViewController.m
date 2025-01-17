//
//  SidebarViewController.m
//  transinfo
//
//  Created by Omar Soto Fortuño on 9/29/14.
//  Copyright (c) 2014 University of Puerto Rico Mayagüez Campus. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "Utilities.h"
#import "CrashSummary.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    self.menuItems = @[@"title", @"userInfo", @"newReport", @"myReports", @"logout"];
    self.tableView.alwaysBounceVertical = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([CellIdentifier isEqualToString:@"logout"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults removeObjectForKey:@"login"];
        [userDefaults synchronize];
        
        //[Utilities displayAlertWithMessage:@"Logout!" withTitle:@"Debug"];
        
        [CrashSummary resetSharedCrashSummary];
        
        [self performSegueWithIdentifier:@"GoToLoginFromSidebar" sender:self];
    } else if ([CellIdentifier isEqualToString:@"myReports"]) {
        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        [self.revealViewController pushFrontViewController:viewController animated:YES];
    } else if ([CellIdentifier isEqualToString:@"newReport"]) {
        [CrashSummary resetSharedCrashSummary];
        
        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReportTabBarController"];
        [self.revealViewController pushFrontViewController:viewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    if ([CellIdentifier isEqual: @"title"] || [CellIdentifier isEqual:@"userInfo"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([CellIdentifier isEqual:@"userInfo"]) {
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *loginInfo = [userDefaults objectForKey:@"login"];
        
        if (loginInfo != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", loginInfo[@"FirstName"], loginInfo[@"LastName"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"# %@", loginInfo[@"PlateNumber"]];
            //NSString *out = [NSString stringWithFormat:@"First Name: %@\nLast Name: %@\nPlate Number: %@\nAgency ID: %@", loginInfo[@"FirstName"], loginInfo[@"LastName"], loginInfo[@"PlateNumber"], loginInfo[@"AgencyID"]];
            
        }
        
    }
    
    return cell;
}

@end
