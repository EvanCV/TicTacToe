//
//  ViewController.m
//  TicTacToe
//
//  Created by Evan Vandenberg on 1/8/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

//Setting the property for each UIImageView in the tic tac toe
//First row = A, Left most column = 1
@property (weak, nonatomic) IBOutlet UIImageView *A1;
@property (weak, nonatomic) IBOutlet UIImageView *A2;
@property (weak, nonatomic) IBOutlet UIImageView *A3;
//Second row = B, Left most column = 1
@property (weak, nonatomic) IBOutlet UIImageView *B1;
@property (weak, nonatomic) IBOutlet UIImageView *B2;
@property (weak, nonatomic) IBOutlet UIImageView *B3;
//Third row = B, Left most column = 1
@property (weak, nonatomic) IBOutlet UIImageView *C1;
@property (weak, nonatomic) IBOutlet UIImageView *C2;
@property (weak, nonatomic) IBOutlet UIImageView *C3;

//Array of all of my image views
@property NSMutableArray *baseImageViewArray;

//Top label
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

//Boolean to determine which players turn it is
@property BOOL currentPlayer;


@end

@implementation RootViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    //Setting current player and corresponding title text
    self.currentPlayer = [self getRandomYesOrNo];

    if (self.currentPlayer == YES)
    {
        self.whichPlayerLabel.text = @"PLayer X you're up!";
    }
    else if (self.currentPlayer == NO)
    {
        self.whichPlayerLabel.text = @"Player O you're up!";
    }

    //Initialize an array with all of the UIImageViews
    self.baseImageViewArray = [[NSMutableArray alloc]initWithObjects:self.A1, self.A2, self.A3, self.B1, self.B2, self.B3,self.C1, self.C2, self.C3, nil];
}

//Creates random BOOL to set which player starts first
-(BOOL) getRandomYesOrNo
{
    int random = (arc4random()%100)+1;
    if (random < 50)
    {
        return YES;
    }
    else
        return NO;
}

- (IBAction)onScreenTapped:(UIGestureRecognizer *)gesture
{

    //CGPoint coordinates when screen is touched
    CGPoint touchPoint  = [gesture locationInView:self.view];

    //For loop gets the frame property from all ImageViews then determines whether the CGPoint iis in any UIView frames. If the the CGPoint is in a frame it will place either an X or O image in the UIView depending on which user's turn it is.
    for (UIImageView *myImageView in self.baseImageViewArray)
    {
        if (CGRectContainsPoint(myImageView.frame, touchPoint))
        {
            if (self.currentPlayer == YES)
            {
                myImageView.image = [UIImage imageNamed:@"Xpicture"];
            }
            if (self.currentPlayer == NO)
            {
                myImageView.image = [UIImage imageNamed:@"Opicture"];
            }
            if (gesture.state == UIGestureRecognizerStateEnded)
            {
                if (self.currentPlayer == NO)
                {
                    self.currentPlayer = YES;
                    self.whichPlayerLabel.text = @"PLayer X you're up!";
                }
                else
                {
                    self.currentPlayer = NO;
                    self.whichPlayerLabel.text = @"Player O you're up!";
                }
            }

        }
    }


}


@end
