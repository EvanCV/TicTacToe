//
//  ViewController.m
//  TicTacToe
//
//  Created by Evan Vandenberg on 1/8/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "RootViewController.h"
#import "WebViewViewController.h"

//------------------------------------- Setting Properties -----------------------------------

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

@property UIGestureRecognizer *gestureRecognizer;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property NSTimer *timer;

@property int timerValue;

@property int timerStartingTime;


@end

@implementation RootViewController

//-----------------------------------setting all of the necessary data-------------------------

- (void)viewDidLoad {

    [super viewDidLoad];

    //Setting current player and corresponding title text
    [self setRandomFirstPLayer];

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

    //Timer calls
    [self startDownTimer:5];
}

//---------------------------------------------Helper Methods-----------------------------


//Creates random BOOL
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


//set first player based on input getRandomYesOrNo
-(void) setRandomFirstPLayer
{
    self.currentPlayer = [self getRandomYesOrNo];

    if (self.currentPlayer == YES)
    {
        self.whichPlayerLabel.text = @"PLayer X you're up!";
    }
    else if (self.currentPlayer == NO)
    {
        self.whichPlayerLabel.text = @"Player O you're up!";
    }
}


//comparing two sets to see if players moves = win
- (BOOL) checkIfPlayerDidWin
{
    for (NSSet *set in self.allAnswerPossibilitiesSet)
    {
        if ([set isSubsetOfSet:self.setWithUserOInputs])
        {
            
            self.whichPlayerLabel.text = @"Player O whooped yo ass!";
            [self.setWithUserXInputs removeAllObjects];
            [self.setWithUserOInputs removeAllObjects];
            return YES;
        }
        if ([set isSubsetOfSet:self.setWithUserXInputs])
        {
            self.whichPlayerLabel.text = @"Player X whooped yo ass!";
            [self.setWithUserXInputs removeAllObjects];
            [self.setWithUserOInputs removeAllObjects];
            return YES;
        }
        if ((self.setWithUserXInputs.allObjects.count + self.setWithUserOInputs.allObjects.count) >= 9 && (![set isSubsetOfSet:self.setWithUserOInputs]) && ![set isSubsetOfSet:self.setWithUserXInputs])
        {
            self.whichPlayerLabel.text = @"Cats Game...MEOW!";
            [self.setWithUserXInputs removeAllObjects];
            [self.setWithUserOInputs removeAllObjects];
            return YES;
        }
    }
    return NO;
}

- (void) startDownTimer:(int) startTime
{
    [self.timer invalidate];
    self.timerValue = startTime;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",startTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void) tick
{
    if (self.timerValue <= 0)
    {
        self.whichPlayerLabel.text = @"Time's up you lose!";
        [self.timer invalidate];
        self.gestureRecognizer.enabled = FALSE;
    }
    else
    {
        self.timerValue--;
        self.timerLabel.text = [NSString stringWithFormat:@"%i",self.timerValue];
    }
}

//Method to end game and disallow further play
- (void) restartGame
{
    //erase all images in UIImageViews
    for (UIImageView *baseViews in self.baseImageViewArray)
    {
        baseViews.image = [[UIImage alloc]initWithCGImage:nil];
    }

    //Enable touch gesture on the playing board
    self.gestureRecognizer.enabled = YES;

    //reset new first player
    [self setRandomFirstPLayer];

    //set timer
    [self startDownTimer:5];
    [self tick];
}
//--------------------------------------The Actions--------------------------------------------

//Reset button clears frames and starts new game
- (IBAction)onResetButtonPressed:(id)sender
{
    [self restartGame];
}


//The meat of the functions
- (IBAction)onScreenTapped:(UIGestureRecognizer *)gesture
{
    //
    self.gestureRecognizer = gesture;

    //CGPoint coordinates when screen is touched
    CGPoint touchPoint  = [gesture locationInView:self.view];

    if (![self checkIfPlayerDidWin])
    {
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
                    if ([self checkIfPlayerDidWin])
                    {
                        [self checkIfPlayerDidWin];
                        gesture.enabled = NO;
                    }
                    else
                        if (self.currentPlayer == NO)
                        {
                            self.currentPlayer = YES;
                            self.whichPlayerLabel.text = @"PLayer X you're up!";
                            //set timer
                            [self startDownTimer:5];
                            [self tick];

                        }
                        else
                        {
                            self.currentPlayer = NO;
                            self.whichPlayerLabel.text = @"Player O you're up!";
                            //set timer
                            [self startDownTimer:5];
                            [self tick];

                        }
                }
                
            }
        }
    }
}

@end
