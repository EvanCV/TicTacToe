//
//  ViewController.m
//  TicTacToe
//
//  Created by Evan Vandenberg on 1/8/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

//Mutable arrays which will be filled with the users actions
@property NSMutableSet *setWithUserXInputs;
@property NSMutableSet *setWithUserOInputs;

//Winning condition sets.
@property NSSet *allAnswerPossibilitiesSet;
@property NSSet *winningCondition1;
@property NSSet *winningCondition2;
@property NSSet *winningCondition3;
@property NSSet *winningCondition4;
@property NSSet *winningCondition5;
@property NSSet *winningCondition6;
@property NSSet *winningCondition7;
@property NSSet *winningCondition8;

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

    //Setting the winning conditions
    //3 in a row vertically
    self.winningCondition1 = [[NSSet alloc]initWithObjects:@"1",@"4", @"7", nil];
    self.winningCondition2 = [[NSSet alloc]initWithObjects:@"2",@"5", @"8", nil];
    self.winningCondition3 = [[NSSet alloc]initWithObjects:@"3",@"6", @"9", nil];

    //3 in a row horizontally
    self.winningCondition4 = [[NSSet alloc]initWithObjects:@"1",@"2", @"3", nil];
    self.winningCondition5 = [[NSSet alloc]initWithObjects:@"4",@"5", @"6", nil];
    self.winningCondition6 = [[NSSet alloc]initWithObjects:@"7",@"8", @"9", nil];

    //3 in a row diaganol
    self.winningCondition7 = [[NSSet alloc]initWithObjects:@"1",@"5", @"9", nil];
    self.winningCondition8 = [[NSSet alloc]initWithObjects:@"3",@"5", @"7", nil];

    //All of the winning conditions set as object in a comprehensive set
    self.allAnswerPossibilitiesSet = [[NSSet alloc]initWithObjects:self.winningCondition1, self.winningCondition2, self.winningCondition3, self.winningCondition4, self.winningCondition5, self.winningCondition6, self.winningCondition7, self.winningCondition8, nil];

    //Initialize user sets
    self.setWithUserXInputs = [NSMutableSet new];
    self.setWithUserOInputs = [NSMutableSet new];
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

//comparing two sets to see if players moves = win
- (BOOL) checkIfPlayerDidWin
{
    if ([self.setWithUserOInputs intersectsSet:self.allAnswerPossibilitiesSet] || [self.setWithUserXInputs intersectsSet:self.allAnswerPossibilitiesSet])
    {
        return YES;
    }
        return NO;
}


- (IBAction)onScreenTapped:(UIGestureRecognizer *)gesture
{

    //CGPoint coordinates when screen is touched
    CGPoint touchPoint  = [gesture locationInView:self.view];

    //For loop gets the frame property from all ImageViews then determines whether the CGPoint iis in any UIView frames. If the the CGPoint is in a frame it will place either an X or O image in the UIView depending on which user's turn it is.
    for (UIImageView *myImageView in self.baseImageViewArray)
    {
        //Check to see if touch was in a frame and whether or not that frame is empty
        if (CGRectContainsPoint(myImageView.frame, touchPoint) && myImageView.image == nil)
        {
            if (self.currentPlayer == YES)
            {
                myImageView.image = [UIImage imageNamed:@"Xpicture"];
                [self.setWithUserXInputs addObject:[NSString stringWithFormat:@"%li", (long)myImageView.tag]];
                NSLog(@"%@",self.setWithUserXInputs.description);
            }
            if (self.currentPlayer == NO)
            {
                myImageView.image = [UIImage imageNamed:@"Opicture"];
                [self.setWithUserOInputs addObject:[NSString stringWithFormat:@"%li", (long)myImageView.tag]];
                NSLog(@"%@",self.setWithUserOInputs.description);
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
            if ([self checkIfPlayerDidWin])
            {
                [self.setWithUserXInputs removeAllObjects];
                [self.setWithUserOInputs removeAllObjects];
                self.whichPlayerLabel.text = @"game over";
            }
        }
    }


}


@end
