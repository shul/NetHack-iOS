//
//  StatsView.m
//  SlashEM
//
//  Created by Dirk Zimmermann on 4/24/10.
//  Copyright 2010 Dirk Zimmermann. All rights reserved.
//

/*
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation, version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#import "StatsView.h"
#import "NhStatus.h"

#import "hack.h"

@implementation StatsView

- (void)setup {
	status = [[NhStatus alloc] init];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		[self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	if (!program_state.gameover && program_state.something_worth_saving) {
		float space = 5.0f;
		UIFont *font = nil;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			font = [UIFont systemFontOfSize:16.0f];
		} else {
			font = [UIFont systemFontOfSize:13.0f];
		}
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
		CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
				
		NSString *name = [NSString stringWithFormat:@"%s",status.nameAndTitle];
		NSString *level = [NSString stringWithFormat:@"%s",status.level];
		NSString *money = [NSString stringWithFormat:@"$%d",status.money];
		NSString *hp = [NSString stringWithFormat:@"Hp:%u/%u",status.hitpoints,status.maxHitpoints];
		NSString *pw = [NSString stringWithFormat:@"Pw:%u/%u",status.power,status.maxPower];
		NSString *ac = [NSString stringWithFormat:@"AC:%d",status.ac];
		NSString *xp = [NSString stringWithFormat:@"XP:%u",status.xlvl];
		NSString *t = [NSString stringWithFormat:@"T:%u",status.turn];

		CGPoint p = CGPointMake(5.0f, 0.0f);
		
		CGSize size = [name drawAtPoint:p withFont:font];
		p.y += size.height;
		
		size = [level drawAtPoint:p withFont:font];
		p.y += size.height;

		 size = [money drawAtPoint:p withFont:font];
		p.y += size.height;

		if (status.maxHitpoints) {
			if (((float)status.hitpoints/(float)status.maxHitpoints) > 0.5) {
				if (((float)status.hitpoints/(float)status.maxHitpoints) < 0.9) {
					CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
					CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
				}
			}
			else {
				CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
				CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);

			}
		}

		 size = [hp drawAtPoint:p withFont:font];
		p.y += size.height;
		
		CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
		CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
		
		if (status.maxPower) {
			if (((float)status.power/(float)status.maxPower) > 0.5) {
				if (((float)status.power/(float)status.maxPower) < 0.9) {
					CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
					CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
				}
			}
			else {
				CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
				CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
				
			}
		}

		 size = [pw drawAtPoint:p withFont:font];
		p.y += size.height;
		
		CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
		CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
		

		 size = [ac drawAtPoint:p withFont:font];
		p.y += size.height;

		 size = [xp drawAtPoint:p withFont:font];
		p.y += size.height;

		 size = [t drawAtPoint:p withFont:font];
		p.y += size.height;
		
		// make font smaller if a lot to display
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			if (self.bounds.size.width <= 320.0f && (status.hungryState != 1 || strlen(status.status))) {
				font = [UIFont systemFontOfSize:10.0f];
			}
		}
		
		if (status.hungryState != 1) {
			if (status.hungryState > 1) {
				CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
				CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
			}
			NSString *hunger = [NSString stringWithCString:status.hunger encoding:NSASCIIStringEncoding];
			size = [hunger drawAtPoint:p withFont:font];
			p.x += size.width + space;
		}
		
		if (strlen(status.status)) {
			CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
			CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
			NSString *info = [NSString stringWithCString:status.status encoding:NSASCIIStringEncoding];
			[info drawAtPoint:p withFont:font];
		}
	}
}

- (void)update {
	[status update];
	[self setNeedsDisplay];
}

- (void)dealloc {
	[status release];
    [super dealloc];
}

@end
