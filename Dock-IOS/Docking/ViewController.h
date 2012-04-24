//
//  ViewController.h
//  Docking
//
//  Created by Lion on 11/04/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

{
    int y;
    UIView *commenView ;
    int commenX ;
    int count ;
    NSTimer *timer ;
    
}

@property  (nonatomic,strong)IBOutlet UIImageView *imgone;
@property  (nonatomic,strong)IBOutlet UIImageView *imgtwo ;
@property  (nonatomic,strong)IBOutlet UIImageView *img1;
@property  (nonatomic,strong)IBOutlet UIImageView *img2 ;
@property  (nonatomic,strong)IBOutlet UIImageView *img11;
@property  (nonatomic,strong)IBOutlet UIImageView *img22 ;
@property  (nonatomic,strong)IBOutlet UIView *bgviewone ;
@property  (nonatomic,strong)IBOutlet UIView *bgviewtwo ;
@property  (nonatomic,strong)IBOutlet UIView *bgviewthree ;

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height ;

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh) ;
CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh);
- (void) buttonPressed :(UIButton*)button ;

- (IBAction)buttonTouched: (id)sender ;

- (void) jumpAnimationForView:(UIView*)animatedView
					  toPoint:(CGPoint)point ;
-(void)closeTouched ;
@end
