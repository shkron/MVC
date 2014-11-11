//
//  ViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "EventDetailViewController.h"
#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchBar;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    [self performSearchWithKeyword:@"mobile"];

}

-(void)setDataArray:(NSArray *)array
{
    _dataArray = array;
    [self.tableView reloadData];
}

-(void)performSearchWithKeyword:(NSString *)keyword
{
    [Event searchWithKeyword:^(NSArray *meetUpsArray, NSError *error)
     {
         if (error)
         {
             NSLog(@"ALARMA: %@", error.localizedDescription);
         }
         else
         {
             self.dataArray = meetUpsArray;
         }



     } withSearchString:keyword];

}


#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    Event *e = self.dataArray[indexPath.row];
    
    cell.textLabel.text = e.name;
    cell.detailTextLabel.text = e.address;
    if (e.photoURL)
    {
        [e getImageDataForURL:^(NSData *data, NSError *error)
        {
            if (!error)
            {
            [cell.imageView setImage:[UIImage imageWithData:data]];
            [cell layoutSubviews];
            }
        }];
    }
         else
    {
       [cell.imageView setImage:[UIImage imageNamed:@"logo"]];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventDetailViewController *detailVC = [segue destinationViewController];

    Event *e = self.dataArray[self.tableView.indexPathForSelectedRow.row];
    detailVC.event = e;
}

#pragma searchbar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearchWithKeyword:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
