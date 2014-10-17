//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "DivvyStation.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *stations;
@property CLLocationManager *locationManager;

@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];

    self.stations = [[NSMutableArray alloc] init];

    NSURL *url = [NSURL URLWithString:@"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", jsonString);

        NSError *jsonError = nil;

        if (data)
        {
            NSDictionary *tempStationDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *tempDataArray = [tempStationDictionary objectForKey:@"stationBeanList"];

            for (NSDictionary *tempDictionary in tempDataArray) //to be able to pull objectForKeys from Dictionary
            {
                DivvyStation *divvysInfo = [[DivvyStation alloc] init];

                divvysInfo.name = [tempDictionary objectForKey:@"stationName"];
                divvysInfo.numberOfBikes = [[tempDictionary objectForKey:@"availableBikes"] stringValue];
                divvysInfo.latitude = [[tempDictionary objectForKey:@"latitude"] floatValue];
                divvysInfo.longitude = [[tempDictionary objectForKey:@"longitude"] floatValue];

                [self.stations addObject:divvysInfo];

                //[self createPhotoClass:tempURLString];
                //NSLog(@"%@", tempURLDictionary);
            }
            //NSLog(@"self.stations %@", self.stations);
            //                 [self.tableView reloadData];

            [self.tableView reloadData];
        }

        NSLog(@"Connection Error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DivvyStation *stationsAtIndex = [self.stations objectAtIndex:indexPath.row];
    MapViewController *mapViewController = [segue destinationViewController];

    mapViewController.mapStation = stationsAtIndex;
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DivvyStation *fullDivvyStation = [self.stations objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.textLabel.text = fullDivvyStation.name;
    cell.detailTextLabel.text = fullDivvyStation.numberOfBikes;

    NSLog(@"%@", cell.textLabel.text);
    return cell;
}

@end








