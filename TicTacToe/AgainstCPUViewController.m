//
//  AgainstCPUViewController.m
//  TicTacToe
//
//  Created by Evan Vandenberg on 1/10/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "AgainstCPUViewController.h"

@interface AgainstCPUViewController ()

//Adding all necessary UI elements
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *a1;
@property (weak, nonatomic) IBOutlet UIImageView *a2;
@property (weak, nonatomic) IBOutlet UIImageView *a3;
@property (weak, nonatomic) IBOutlet UIImageView *b1;
@property (weak, nonatomic) IBOutlet UIImageView *b2;
@property (weak, nonatomic) IBOutlet UIImageView *b3;
@property (weak, nonatomic) IBOutlet UIImageView *c1;
@property (weak, nonatomic) IBOutlet UIImageView *c2;
@property (weak, nonatomic) IBOutlet UIImageView *c3;


//Array of all of my image views
@property NSMutableArray *baseImageViewArray;


//Set of corner/non-corner (non center)image views
@property NSSet *cornersSet;
@property NSSet *nonCornersSet;


//Mutable arrays which will be filled with the user & computer actions
@property NSMutableSet *humanInputs;
@property NSMutableSet *computerInputs;
@property NSMutableSet *currentStateOfBoard;


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


//Recognize screen gestures
@property UIGestureRecognizer *gestureRecognizer;


//determine who's turn it is
@property BOOL currentPlayer;

@property UIImage *userIconType;
@property UIImage *compIconType;



@end


@implementation AgainstCPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Setting current player and corresponding title text
    [self setRandomFirstPLayer];

    //Initialize an array with all of the UIImageViews
    self.baseImageViewArray = [[NSMutableArray alloc]initWithObjects:self.a1, self.a2, self.a3, self.b1, self.b2, self.b3,self.c1, self.c2, self.c3, nil];

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

    //sets containg all corner and non corner (non center) UIVIEWS
    self.cornersSet = [[NSSet alloc]initWithObjects:self.a1,self.a3,self.c1,self.c3, nil];
    self.nonCornersSet = [[NSSet alloc]initWithObjects:self.a2,self.b1,self.b3,self.c2, nil];

    //All of the winning conditions set as object in a comprehensive set
    self.allAnswerPossibilitiesSet = [[NSSet alloc]initWithObjects:self.winningCondition1, self.winningCondition2, self.winningCondition3, self.winningCondition4, self.winningCondition5, self.winningCondition6, self.winningCondition7, self.winningCondition8, nil];

    self.humanInputs = [NSMutableSet new];
    self.computerInputs = [NSMutableSet new];
    self.currentStateOfBoard = [NSMutableSet new];

    //Pics used for X and O
    self.compIconType = [UIImage imageNamed:@"Xpicture"];
    self.userIconType = [UIImage imageNamed:@"Opicture"];

    [self performSelector:@selector(computerMoves) withObject: self afterDelay:3.0];
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


//set first player and icon type based arc4random
-(void) setRandomFirstPLayer
{
    //set random icon type (X or O)
//    int random1 = (arc4random()%200)+1;
//    if (random1 < 100)
//    {
//        self.userIconType = [UIImage imageNamed:@"Xpicture"];
//        self.compIconType = [UIImage imageNamed:@"Opicture"];
//    }
//    else
//        self.userIconType = [UIImage imageNamed:@"Opicture"];
//        self.compIconType = [UIImage imageNamed:@"Xpicture"];

    //set random first player
    self.currentPlayer = [self getRandomYesOrNo];

    if (self.currentPlayer == YES)
    {
        self.whichPlayerLabel.text = @"CPU Is Thinking..";

    }
    else if (self.currentPlayer == NO)
    {
        self.whichPlayerLabel.text = @"You're Up!";
    }
}

- (BOOL) onlyCheckForComputerWinOrTie
{
    for (NSSet *set in self.allAnswerPossibilitiesSet)
    {
        if ([set isSubsetOfSet:self.computerInputs])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL) onlyCheckForHumanWinOrTie
{
    for (NSSet *set in self.allAnswerPossibilitiesSet)
    {
        if ([set isSubsetOfSet:self.humanInputs])
        {
            return YES;
        }
    }
    return NO;

}

//comparing two sets to see if players moves = win
- (BOOL) checkIfPlayerDidWin
{
    for (NSSet *set in self.allAnswerPossibilitiesSet)
    {
        if ([set isSubsetOfSet:self.humanInputs])
        {
            self.whichPlayerLabel.text = @"You have acheived the IMPOSSIBLE!";
//            [self.humanInputs removeAllObjects];
//            [self.computerInputs removeAllObjects];
//            [self.currentStateOfBoard removeAllObjects];
            return YES;
        }
        if ([set isSubsetOfSet:self.computerInputs])
        {
            self.whichPlayerLabel.text = @"CPU WINS";
//            [self.humanInputs removeAllObjects];
//            [self.computerInputs removeAllObjects];
//            [self.currentStateOfBoard removeAllObjects];
            return YES;
        }
        if ((self.humanInputs.allObjects.count + self.computerInputs.allObjects.count) >= 9 && (![set isSubsetOfSet:self.humanInputs]) && ![set isSubsetOfSet:self.computerInputs])
        {
            self.whichPlayerLabel.text = @"Cats Game...MEOW!";
//            [self.humanInputs removeAllObjects];
//            [self.computerInputs removeAllObjects];
//            [self.currentStateOfBoard removeAllObjects];
            return YES;
        }
        return NO;
    }
    return NO;
}


//Method to end game and disallow further play
- (void) restartGame
{
    //erase all images in UIImageViews
    for (UIImageView *baseViews in self.baseImageViewArray)
    {
        baseViews.image = [[UIImage alloc]initWithCGImage:nil];
    }

    //Reset array and sets
    [self.humanInputs removeAllObjects];
    [self.computerInputs removeAllObjects];
    [self.currentStateOfBoard removeAllObjects];

    //Enable touch gesture on the playing board
    self.gestureRecognizer.enabled = YES;

    //reset new first player
    [self setRandomFirstPLayer];
}

//----------------------------------------- The Actions ------------------------------------------

- (IBAction)onResetButtonPressed:(id)sender
{
    [self restartGame];
    [self performSelector:@selector(computerMoves) withObject: self afterDelay:2.0];
}

- (void)computerMoves
{
    if (self.currentPlayer == YES)
    {
        self.gestureRecognizer.enabled = NO;

        if (![self.currentStateOfBoard containsObject:@"5"] || (self.currentStateOfBoard == nil))
        {
            UIImageView *centerUIView = self.baseImageViewArray[4];
            centerUIView.image = self.compIconType;
            [self.computerInputs addObject:[NSString stringWithFormat:@"5"]];
            [self.currentStateOfBoard addObject:[NSString stringWithFormat:@"5"]];
            self.currentPlayer = NO;
            self.whichPlayerLabel.text = @"You're Up!";
            self.gestureRecognizer.enabled = YES;
            NSLog(@"%@", self.currentStateOfBoard);
            NSLog(@"%@", self.computerInputs);

        }
        else if ((self.currentStateOfBoard.count < 3))
        {
            for (UIImageView *firstNonCenter in self.cornersSet)
            {
                if (firstNonCenter.image == nil)
                {
                    if (firstNonCenter.image == nil)
                    {
                        firstNonCenter.image = self.compIconType;
                        [self.computerInputs addObject:[NSString stringWithFormat:@"%li", (long)firstNonCenter.tag]];
                        [self.currentStateOfBoard addObject:[NSString stringWithFormat:@"%li", (long)firstNonCenter.tag]];
                        self.currentPlayer = NO;
                        self.whichPlayerLabel.text = @"You're Up!";
                        self.gestureRecognizer.enabled = YES;
                        NSLog(@"%@", self.currentStateOfBoard);
                        NSLog(@"%@", self.computerInputs);
                        return;
                    }
                }
            }
        }

        else if ((self.currentStateOfBoard.count > 2))
        {
            for (UIImageView *cell in self.baseImageViewArray)
            {
                if (cell.image == nil)
                {
                    [self.computerInputs addObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];
                    [self.humanInputs addObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];

                    if ([self onlyCheckForComputerWinOrTie])
                    {
                        cell.image = self.compIconType;
                        [self.currentStateOfBoard addObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];
                        self.currentPlayer = NO;
                        [self checkIfPlayerDidWin];
                        self.whichPlayerLabel.text = @"The CPU Won Again!";
                        self.gestureRecognizer.enabled = NO;
                        return;
                    }

                    else if ([self onlyCheckForHumanWinOrTie])
                    {
                        cell.image = self.compIconType;
                        [self.currentStateOfBoard addObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];
                        [self.humanInputs removeObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];
                        self.currentPlayer = NO;
                        if (self.currentStateOfBoard.count > 8)
                        {
                            self.whichPlayerLabel.text = @"Cats Game... Meow";
                            self.gestureRecognizer.enabled = NO;
                        }
                        else
                            self.whichPlayerLabel.text = @"You're Up!";
                        self.gestureRecognizer.enabled = YES;
                        return;
                    }
                    [self.computerInputs removeObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];
                    [self.humanInputs removeObject:[NSString stringWithFormat:@"%li", (long)cell.tag]];
                }
            }
            [self checkIfPlayerDidWin];
        }
    }
}



- (IBAction)onScreenTapped:(UIGestureRecognizer *)gesture
{
    self.gestureRecognizer = gesture;

    //CGPoint coordinates when screen is touched
    CGPoint touchPoint  = [gesture locationInView:self.view];

    if (![self checkIfPlayerDidWin] && (self.currentPlayer == NO))
    {
        //For loop gets the frame property from all ImageViews then determines whether the CGPoint iis in any UIView frames. If the the CGPoint is in a frame it will place either an X or O image in the UIView depending on which user's turn it is.
        for (UIImageView *myImageView in self.baseImageViewArray)
        {
            //Check to see if touch was in a frame and whether or not that frame is empty
            if (CGRectContainsPoint(myImageView.frame, touchPoint) && myImageView.image == nil)
            {
                {
                    myImageView.image = self.userIconType;
                    [self.humanInputs addObject:[NSString stringWithFormat:@"%li", (long)myImageView.tag]];
                    [self.currentStateOfBoard addObject:[NSString stringWithFormat:@"%li", (long)myImageView.tag]];
                    NSLog(@"%@",self.humanInputs.description);
                }
                if (gesture.state == UIGestureRecognizerStateEnded)
                {
                    NSLog(@"%@", self.currentStateOfBoard);

                    if ([self checkIfPlayerDidWin])
                    {
                        [self checkIfPlayerDidWin];
                        gesture.enabled = NO;
                    }
                    else
                    {
                        self.whichPlayerLabel.text = @"CPU is thinking...";
                        self.currentPlayer = YES;
                        [self computerMoves];
//                        [self performSelector:@selector(computerMoves) withObject: self afterDelay:2.0];
                    }
                }
            }
        }
    }
}


@end
