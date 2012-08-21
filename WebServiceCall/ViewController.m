//
//  ViewController.m
//  WebServiceCall
//
//  Created by Martin Rosas on 8/15/12.
//  Copyright (c) 2012 Martin Rosas. All rights reserved.
//

#import "ViewController.h"
#import "Ride.h"

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
    
    // http://www.strava.com/api/v1/segments/229781/efforts?best=true
    
    // Efforts on segment by athlete limited by startDate and endDate
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.strava.com/api/v1/segments/229781/efforts?athleteId=11673&startDate=2012-02-01&endDate=2012-02-28"]];
    
    //Leader Board on Segment all Athletes
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.strava.com/api/v1/segments/229781/efforts?best=true"]];
    
    //Rides by Athlete
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.strava.com/api/v1/rides?athleteId=10273"]];
    
    
    //Twitter Example
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/trends"]];
    
    
    //Efforts by Ride
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.strava.com/api/v1/rides/77563/efforts"]];
    
    //Effort Detail
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.strava.com/api/v1/efforts/688432"]];
    
    
    //Google API Call
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=AIzaSyAbgGH36jnyow0MbJNP4g6INkMXqgKFfHk"]];
  
/*    dispatch_async(dispatch_get_main_queue(),^ {
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } ); */
    
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(theConnection){
        self.rideIds = [[NSMutableArray alloc]init];
        self.rideNames  = [[NSMutableArray alloc] init];
    } else {
        NSLog(@"No Connection");
        }
            

    
    

}


//Delegate methods for the NSURLConnection

//In order to download the contents of a URL, an application needs to provide a delegate object that, at a minimum, implements the following delegate methods: connection:didReceiveResponse:, connection:didReceiveData:, connection:didFailWithError: and connectionDidFinishLoading:.

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    NSLog(@"didReceiveResponse");
    
    //This message can be sent due to server redirects, or in rare cases multi-part MIME documents.
    //Each time the delegate receives the connection:didReceiveResponse: message, it should reset any progress indication and discard all previously received data.
    
    [self.responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    NSLog(@"didFailWithError");
    NSString *errorDescription = [error description];
//    NSLog([NSString stringWithFormat:@"Connection failed: %@", errorDescription]);
    NSLog(@"Connection failed: %@", errorDescription);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    //NSDictionary *jsonRes = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSDictionary *jsonRides =[jsonResult objectForKey:@"rides"];
    

    // Show all values coming out of "rides" key
    // Store ride id's and names on arrays for later display on tableview
    for (NSDictionary *rides in jsonRides) {
        
        [self.rideIds addObject:[rides objectForKey:@"id"]];
        NSLog(@"id = %@", [rides objectForKey:@"id"]);
        //NSLog(@"%@",self.rideIds);
        
        [self.rideNames addObject:[rides objectForKey:@"name"]];
        NSLog(@"name = %@", [rides objectForKey:@"name"]);
        //NSLog(@"%@",self.rideNames);
    }
        NSLog(@"%@",self.rideIds);
        NSLog(@"%@",self.rideNames);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Show all values coming out of NSKSONSerialization
    for(id key in jsonResult) {
        
        id value = [jsonResult objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    // NSArray *results = [res objectForKey:@"results"];
    /*NSArray *results = [res objectForKey:@"rides"];
    for (NSDictionary *result in results) {
        NSData *athleteData = [result objectForKey:@"name"];
        NSLog(@"Ride name: %@", athleteData);
    }*/
    

/*    dispatch_async(dispatch_get_main_queue(),^ {
        [self.rideTableView reloadData];
    } ); */

    [self.rideTableView reloadData];


}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"tableView:numberOfRowsInSection: ");
    
    return self.rideIds.count;
    NSLog(@"%u",self.rideNames.count);
    //return 3;
}

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"tableView:cellForRowAtIndexPath: ");

    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text= [self.rideNames objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tv
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}



@end


































