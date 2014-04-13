//
//  ViewController.h
//  LocationAutocomplete
//
//  Created by Sanjay Balakrishnan on 13/04/14.
//  Copyright (c) 2014 Sanjay Balakrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UITableView *autocompleteTableView;
@property (retain,nonatomic)NSMutableArray *placesArray;

-(void)loadPlacesFromGoogleApi:(NSMutableString *)place;

@end
