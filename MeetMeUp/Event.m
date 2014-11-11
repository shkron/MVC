//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "Comment.h"

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        

        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
    }
    return self;
}

+ (NSArray *)eventsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];
    
    for (NSDictionary *d in incomingArray) {
        Event *e = [[Event alloc]initWithDictionary:d];
        [newArray addObject:e];
        
    }
    return newArray;
}

+ (void)searchWithKeyword:(void(^)(NSArray *meetUpsArray, NSError *error))complete withSearchString:(NSString *)keyword
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=3c7f626d333e3a7433a44552f6b775f",keyword]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:nil] objectForKey:@"results"];


                               NSArray *dataArray = [self eventsFromArray:jsonArray];
                                 complete(dataArray, nil);
                           }];

}

-(void)getImageDataForURL:(void (^)(NSData *, NSError *erorr))complete
{

    NSURLRequest *imageReq = [NSURLRequest requestWithURL:self.photoURL];

    [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {

            complete (data, connectionError);

        }
     ];


}

-(void)getCommentsArray:(void (^)(NSArray *array, NSError *error))complete
{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=3c7f626d333e3a7433a44552f6b775f",self.eventID]];
    
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
                                   NSArray *jsonArray = [dict objectForKey:@"results"];
    
                                   complete ([Comment objectsFromArray:jsonArray], connectionError);
                               }];
}


@end
