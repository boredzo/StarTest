//
//  PRHStarView.m
//  StarTest
//
//  Created by Peter Hosey on 2012-06-02.
//

#import "PRHStarView.h"

#import <tgmath.h>

@implementation PRHStarView

@synthesize shouldClosePath = _shouldClosePath;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (NSBezierPath *)starPathWithNumberOfPoints:(NSUInteger)numPoints distalRadius:(CGFloat)distalRadius {
	NSBezierPath *path = [NSBezierPath bezierPath];

	CGFloat angle = (M_PI * 2.0) / numPoints;
	CGFloat halfAngle = angle / 2.0;
	CGFloat proximalRadius =  distalRadius * (cos(angle) / cos(halfAngle));

	//We're going to draw around 0, 0, then translate by the distal radius.
	[path moveToPoint:(NSPoint){ 0.0, distalRadius }];
	CGFloat currentAngle = M_PI / 2.0;
	while (numPoints--) {
		currentAngle += halfAngle;
		[path lineToPoint:(NSPoint){ proximalRadius * cos(currentAngle), proximalRadius * sin(currentAngle) }];
		currentAngle += halfAngle;
		[path lineToPoint:(NSPoint){ distalRadius * cos(currentAngle), distalRadius * sin(currentAngle) }];
	}

	currentAngle += halfAngle;
	[path lineToPoint:(NSPoint){ proximalRadius * cos(currentAngle), proximalRadius * sin(currentAngle) }];
	if (self.shouldClosePath)
		[path closePath];
	else {
		currentAngle += halfAngle;
		[path lineToPoint:(NSPoint){ distalRadius * cos(currentAngle), distalRadius * sin(currentAngle) }];
	}

	NSAffineTransform *recenter = [NSAffineTransform transform];
	[recenter translateXBy:distalRadius
					   yBy:distalRadius];
	[path transformUsingAffineTransform:recenter];

	return path;
}

- (void)drawRect:(NSRect)dirtyRect {
	CGFloat strokeWidth = 20.0;

	CGFloat starDistalRadius = self.bounds.size.width / 2.0 - strokeWidth;
	NSBezierPath *path = [self starPathWithNumberOfPoints:5U distalRadius:starDistalRadius];

	for (NSUInteger i = 0U, numOps = [path elementCount]; i < numOps; ++i) {
		NSString *elementTypeName;
		NSString *pointsStr;

		NSPoint points[4];
		switch ([path elementAtIndex:i associatedPoints:points]) {
			case NSMoveToBezierPathElement:
				elementTypeName = @"moveto";
				pointsStr = [NSString stringWithFormat:@"%f %f", points[0].x, points[0].y];
				break;
			case NSLineToBezierPathElement:
				elementTypeName = @"lineto";
				pointsStr = [NSString stringWithFormat:@"%f %f", points[0].x, points[0].y];
				break;
			case NSCurveToBezierPathElement:
				elementTypeName = @"curveto";
				pointsStr = [NSString stringWithFormat:@"%f %f  %f %f  %f %f",
					points[0].x, points[0].y,
					points[1].x, points[1].y,
					points[2].x, points[2].y];
				break;
			case NSClosePathBezierPathElement:
				elementTypeName = @"closepath";
				pointsStr = @"";
				break;

			default:
				elementTypeName = @"unknown";
				break;
		}

		NSLog(@"Path element %lu is %@ %@", (unsigned long)i, pointsStr, elementTypeName);
	}

	[path setLineWidth:strokeWidth];
	[path setLineJoinStyle:NSRoundLineJoinStyle];
	[path setLineCapStyle:NSButtLineCapStyle];

	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform translateXBy:strokeWidth yBy:-strokeWidth];
	[transform scaleBy:[self bounds].size.width / ([path bounds].size.width + strokeWidth * 2.0 * 2.0)];
	[path transformUsingAffineTransform:transform];

	//Fill color: Yellowish-orange.
	[[NSColor colorWithCalibratedHue:1.0/8.0 saturation:1.0 brightness:1.0 alpha:1.0] setFill];
	[path fill];
	[[NSColor blackColor] setStroke];
	[path stroke];
}

- (void) setShouldClosePath:(bool)scp {
	_shouldClosePath = scp;
	[self setNeedsDisplay:YES];
}

@end
