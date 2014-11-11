//
//  Member.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"

@implementation Member

+(void)getMemberWithId:(NSString *)memberID withCompletion:(void (^)(Member *member, NSError *error))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=3c7f626d333e3a7433a44552f6b775f",memberID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                            {
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               Member *member = [[Member alloc]initWithDictionary:dict];

                               complete (member, connectionError);
                           }];

}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
        
        
    }
    return self;
}

-(void)getDatafromURL:(void (^)(NSData *data, NSError *error))complete
{

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.photoURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        complete (data, connectionError);

    }];

}


@end
