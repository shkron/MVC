//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#import "MemberViewController.h"

@interface MemberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Member *member;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.alpha = 0;

    [Member getMemberWithId:self.memberID withCompletion:^(Member *member, NSError *error)
    {
        if (error)
        {
            NSLog(@"ALARMA: %@", error.localizedDescription);
        }
        else
        {
            self.member = member;
        }
    }];
    
}

- (void)setMember:(Member *)member
{
    _member = member;
    self.nameLabel.text = member.name;


    [member getDatafromURL:^(NSData *data, NSError *error)
    {
        if (error)
        {
            NSLog(@"ALARMA %@", error.localizedDescription);
        }
        else
        {

            self.photoImageView.image = [UIImage imageWithData:data];

            [UIView animateWithDuration:.3 animations:^{
                self.photoImageView.alpha = 1;
            }];
        }
    }];

}



@end
