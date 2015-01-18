//
//  XYZCustomCheckbox.m
//  WhereAmI
//
//  Created by Admin on 17.01.15.
//  Copyright (c) 2015 PlaceHolder. All rights reserved.
//

#import "XYZCustomCheckbox.h"

@interface XYZCustomCheckbox()

@property (nonatomic) CGRect boxRect;

@end


@implementation XYZCustomCheckbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}


- (void)setDefaults
{
    self.checked = YES;
    self.backgroundColor = [UIColor clearColor];
    self.boxSideLength = 40.0f;
    self.boxColor = [UIColor blueColor];
    self.checkMarkColor = [UIColor blueColor];
    self.fillColor = [UIColor clearColor];
}




- (void)drawRect:(CGRect)rect
{
    CGPoint boxOrigin = CGPointMake(10.0f, 10.0f);
    
    CGRect boxRect = CGRectMake(boxOrigin.x, boxOrigin.y, self.boxSideLength, self.boxSideLength);
    self.boxRect = boxRect;
    
    UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:5.0f];
    boxPath.lineWidth = 3.0f;
    [self.boxColor setStroke];
    [self.fillColor setFill];
    [boxPath stroke];
    [boxPath fill];
    


    
    
    if (self.checked) {
        
        UIBezierPath *checkPath = [UIBezierPath bezierPath];
        checkPath.lineWidth = 5.0f;
        checkPath.lineCapStyle = kCGLineCapRound;
        checkPath.lineJoinStyle = kCGLineJoinRound;
        
        [checkPath moveToPoint:CGPointMake(boxOrigin.x + 0.175 * self.boxSideLength, boxOrigin.y + 0.5 * self.boxSideLength)];
        [checkPath addLineToPoint:CGPointMake(boxOrigin.x + 0.5 * self.boxSideLength, boxOrigin.y + 0.825 * self.boxSideLength)];
        [checkPath addLineToPoint:CGPointMake(boxOrigin.x + 1.125 * self.boxSideLength, boxOrigin.y + 0 * self.boxSideLength)];
        [self.checkMarkColor setStroke];
        [checkPath stroke];
        
    }
    
    


}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}




- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView:self];
    if (CGRectContainsPoint(self.boxRect, touchLocation)) {
        self.checked = !self.checked;
    }
    return NO;
}



@end
