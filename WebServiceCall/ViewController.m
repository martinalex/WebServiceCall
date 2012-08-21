//
//  ViewController.m
//  WebServiceCall
//
//  Created by Martin Rosas on 8/15/12.
//  Copyright (c) 2012 Martin Rosas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation ViewController

@synthesize rideIds = _rideIds;
@synthesize rideNames = _rideNames;


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"viewdidload");
    
    self.responseData = [NSMutableData data];
       
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //Rides by Athlete
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.strava.com/api/v1/rides?athleteId=10273"]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(theConnection){
        self.rideIds = [[NSMutableArray alloc]init];
        self.rideNames  = [[NSMutableArray alloc] init];
    } else {
        NSLog(@"No Connection");
        }
}


//Delegate methods for the NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    NSLog(@"didReceiveResponse");
    
    //Each time the delegate receives the connection:didReceiveResponse: message, it should reset any progress indication and discard all previously received data.
    [self.responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    NSLog(@"didFailWithError");
    NSString *errorDescription = [error description];
    NSLog(@"Connection failed: %@", errorDescription);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSDictionary *jsonRides =[jsonResult objectForKey:@"rides"];
    

    // Show all values coming out of NSDictionary. Store ride id's and names on separate arrays for later display on tableview

    for (NSDictionary *rides in jsonRides) {
        
        [self.rideIds addObject:[rides objectForKey:@"id"]];
        NSLog(@"Ride id = %@", [rides objectForKey:@"id"]);
        
        [self.rideNames addObject:[rides objectForKey:@"name"]];
        NSLog(@"Ride Name = %@", [rides objectForKey:@"name"]);
        
    }
        //Display from NSArray
        NSLog(@"%@",self.rideIds);
        NSLog(@"%@",self.rideNames);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   
    
    // Show all values coming out of NSJSONSerialization
    for(id key in jsonResult) {
        
        id value = [jsonResult objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    [self.rideTableView reloadData];


}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Number of Rows in Section %u",self.rideNames.count);
    
    return self.rideIds.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    //Captures any reusable cell available
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //If there are no reusable cells it will allocate a new one
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //either reused or newly allocated it assigns the value of the cell to the ride name in the array
    cell.textLabel.text= [self.rideNames objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end


































