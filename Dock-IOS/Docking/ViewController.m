//
//  ViewController.m
//  Docking
//
//  Created by Lion on 11/04/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//




#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"
@implementation ViewController
@synthesize imgone,imgtwo ,img1,img2,img11,img22;
@synthesize bgviewone,bgviewtwo,bgviewthree ;

#define CONST_button_size 60
#define CONST_dist_between_buttons 20
#define CONST_butons_count 4
#define CONST_TIME_flying 0.8f


UIButton *currentButton;

- (void) buttonPressed :(UIButton*)button
{
	[self.view touchesMoved:nil withEvent:nil];
}


static const CGFloat kDefaultReflectionFraction = 0.65;
static const CGFloat kDefaultReflectionOpacity = 0.40;
static const NSInteger kSliderTag = 1337;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUInteger reflectionHeight = imgone.bounds.size.height * kDefaultReflectionFraction;
	
	// create the reflection image and assign it to the UIImageView
	imgtwo.image = [self reflectedImage:imgone withHeight:reflectionHeight];
	imgtwo.alpha = kDefaultReflectionOpacity;
    
    img22.image = [self reflectedImage:img11 withHeight:reflectionHeight];
	img22.alpha = kDefaultReflectionOpacity;

    img2.image = [self reflectedImage:img1 withHeight:reflectionHeight];
	img2.alpha = kDefaultReflectionOpacity;



}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Image Reflection

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
    
	// gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,8, 0, colorSpace, kCGImageAlphaNone);
	
	// define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// convert the context into a CGImageRef and release the context
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// return the imageref containing the gradient
    return theCGImage;
}


CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,0, colorSpace,
 // this will give us an optimal BGRA format for the device:
(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}



- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage 
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}

- (IBAction)buttonTouched: (id)sender 
{
    
    count = 0 ;
    
    int btnTag = ((UIButton *)sender).tag ;
    
    /*[bgviewone setFrame:CGRectMake(50, 364, 45, 80)];
    [bgviewtwo setFrame:CGRectMake(140, 364, 45, 80)];
    [bgviewthree setFrame:CGRectMake(230, 364, 45, 80)];*/
    
    [self closeTouched];
    
    if (btnTag == 0) 
    {
        commenView = bgviewone ; 
        commenX = 50 ;
    }
    else if (btnTag == 2) 
    {
        commenView = bgviewtwo ; 
        commenX = 140 ;
    }

    else if (btnTag == 3) 
    {
        commenView = bgviewthree ; 
        commenX = 230 ;
    }

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [commenView setFrame:CGRectMake(commenX, 340, 45, 80)];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(down) userInfo:nil repeats:NO];

}

-(void)down
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [commenView setFrame:CGRectMake(commenX, 356, 45, 80)];
    [UIView commitAnimations];
    
    
    
    
    count ++ ;
    
    if (count == 5)
    {
      [self jumpAnimationForView:commenView toPoint:(CGPoint){320,480}];
        
    }
    else
    {
      [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(contiue) userInfo:nil repeats:NO];
    }
    
}

-(void)contiue

{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [commenView setFrame:CGRectMake(commenX, 340, 45, 80)];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(down) userInfo:nil repeats:NO];
    

}

- (void) jumpAnimationForView:(UIView*)animatedView
					  toPoint:(CGPoint)point 
{
	// moving
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:CONST_TIME_flying];
	
	// scaling
	CABasicAnimation *scalingAnimation = (CABasicAnimation *)[animatedView.layer animationForKey:@"scaling"];
	if (!scalingAnimation)
	{
		scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
		scalingAnimation.duration=CONST_TIME_flying/2.0f;
		scalingAnimation.autoreverses=YES;
		scalingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		scalingAnimation.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
		scalingAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)];
	}
	[animatedView.layer addAnimation:scalingAnimation forKey:@"scaling"];
    [commenView setFrame:CGRectMake(0, 20, 320, 300)];
	[UIView commitAnimations];
    
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 30, 20, 20)];
    
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [commenView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeTouched) forControlEvents:UIControlEventTouchUpInside];
}
-(void)closeTouched
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:CONST_TIME_flying];
	
	// scaling
	CABasicAnimation *scalingAnimation = (CABasicAnimation *)[commenView.layer animationForKey:@"scaling"];
	if (!scalingAnimation)
	{
		scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
		scalingAnimation.duration=CONST_TIME_flying/2.0f;
		scalingAnimation.autoreverses=YES;
		scalingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		scalingAnimation.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
		scalingAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)];
	}
	[commenView.layer addAnimation:scalingAnimation forKey:@"scaling"];
    [commenView setFrame:CGRectMake(commenX, 364, 45, 80)];
	[UIView commitAnimations];
    

}

@end
