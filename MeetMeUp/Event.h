//
//  Event.h
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Comment.h"
#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *RSVPCount;
@property (nonatomic, strong) NSString *hostedBy;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSURL *eventURL;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSArray *commentsArray;

+ (NSArray *)eventsFromArray:(NSArray *)incomingArray;
+ (void)searchWithKeyword:(void(^)(NSArray *meetUpsArray, NSError *error))complete withSearchString:(NSString *)keyword;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(void)getImageDataForURL:(void(^)(NSData *data, NSError *error))complete;
-(void)getCommentsArray:(void(^)(NSArray *array, NSError *error))complete;

@end
