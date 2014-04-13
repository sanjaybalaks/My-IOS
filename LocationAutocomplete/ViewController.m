//
//  ViewController.m
//  LocationAutocomplete
//
//  Created by Sanjay Balakrishnan on 13/04/14.
//  Copyright (c) 2014 Sanjay Balakrishnan. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize placesArray;
@synthesize placeTextField;
@synthesize autocompleteTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placesArray=[[NSMutableArray alloc]init]; //initialise the nsmutable array
    autocompleteTableView.scrollEnabled=YES; //enable scroll
    autocompleteTableView.hidden=YES;  //hide the table on load
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//when the  text inside the textfield changes load the places
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
      autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self loadPlacesFromGoogleApi:(NSMutableString *)substring];
    return YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [placesArray count];
}
//load the table with autocomplete data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.text = [placesArray objectAtIndex:indexPath.row ];
    
    return cell;
}

//set the textfield with table data on select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    placeTextField.text = selectedCell.textLabel.text;
    
    
}
//dismiss keyboard on return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    autocompleteTableView.hidden=YES;
    [textField resignFirstResponder];
    return YES;
    
}
//dismiss keyboard on touch else where
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    autocompleteTableView.hidden=YES;
    [self.placeTextField resignFirstResponder];
    
}

-(void)loadPlacesFromGoogleApi:(NSMutableString *)place{
//trim the white spaces;
    NSString *newPlace = [place stringByReplacingOccurrencesOfString:@"[!?., ]+" withString:@"+" options: NSRegularExpressionSearch range:NSMakeRange(0, place.length)];
    NSString *apiKey=@"AIzaSyANwFfc3mgICnVZTe5ib_Kt91KowyQ0jYI";
   //google places api
    NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=37.76999,-122.44696&radius=500&sensor=true&key=%@",newPlace,apiKey];
    [placesArray removeAllObjects];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"JSON: %@", responseObject);
        NSArray *placesarray=[responseObject objectForKey:@"predictions"];
        
        if([placesarray count]!=0){
            for(int i=0;i<[placesarray count];i++){
                
                NSDictionary *placed=placesarray[i];
                [placesArray addObject:[placed objectForKey:@"description"]];
                
            }
            
        }
        [autocompleteTableView reloadData];
        
     
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];



}
@end
