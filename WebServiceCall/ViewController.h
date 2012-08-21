//
//  ViewController.h
//  WebServiceCall
//
//  Created by Martin Rosas on 8/15/12.
//  Copyright (c) 2012 Martin Rosas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{

}

@property (weak, nonatomic) IBOutlet UITableView *rideTableView;
@property (strong, nonatomic) NSMutableArray *rideIds;
@property (strong, nonatomic) NSMutableArray *rideNames;

@end










