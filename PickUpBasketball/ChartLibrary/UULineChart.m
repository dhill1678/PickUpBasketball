//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//
#import "AppDelegate.h"
#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"

@implementation UULineChart
AppDelegate *appDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    appDelegate=[UIApplication sharedApplication ].delegate;
    appDelegate.yChartLableArray=[[NSMutableArray alloc] init];
    appDelegate.yChartLableFrameArray=[[NSMutableArray alloc] init];
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
         for (NSArray * aryy in ary) {
             for (NSString *valueString in aryy) {
                 NSInteger value = [valueString integerValue];
                 if (value > max) {
                     max = value;
                 }
                 if (value < min) {
                     min = value;
                 }
             }
         }
    }
    if (max < 4) {
        max = 4;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
//    _yValueMax = (int)max;
    _yValueMax = (int)max + (4-((int)max%4));
    NSLog(@"_yValueMax===>%f",_yValueMax);
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;

    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5+10, 20, UULabelHeight)];//UUYLabelwidth
		label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
        [appDelegate.yChartLableArray addObject:[NSString stringWithFormat:@"%@",label.text]];
        [appDelegate.yChartLableFrameArray addObject:[NSValue valueWithCGRect:label.frame]];
//		[self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        [self addSubview:view];
    }

    //Draw a horizontal line
    for (int i=0; i<5; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+10+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+10+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    CGFloat num = 0;
//    if (xLabels.count>=36) {
//        num=36.0;
//    }else if (xLabels.count<=1){
//        num=1.0;
//    }else{
        num = xLabels.count;
//    }
    _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
//        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+15, self.frame.size.height - UULabelHeight+2, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
        label.textAlignment=NSTextAlignmentLeft;
        [self addSubview:label];
    }
    
    //Draw a vertical line
    for (int i=0; i<xLabels.count+1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight+10)];
        [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight+10)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}
- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}
- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int k=0; k<_yValues.count; k++) {
         NSArray *ary = _yValues[0];
        for (int i=0; i<ary.count; i++) {
            NSArray *childAry = ary[i];
            if (childAry.count==0) {
                return;
            }
            //获取最大最小位置
            CGFloat max = [childAry[0] floatValue];
            CGFloat min = [childAry[0] floatValue];
            NSInteger max_i=0;
            NSInteger min_i=0;
            
            for (int j=0; j<childAry.count; j++){
                CGFloat num = [childAry[j] floatValue];
                if (max<=num){
                    max = num;
                    max_i = j;
                }
                if (min>=num){
                    min = num;
                    min_i = j;
                }
            }
            
            //Score
            CAShapeLayer *_chartLine = [CAShapeLayer layer];
            _chartLine.lineCap = kCALineCapRound;
            _chartLine.lineJoin = kCALineJoinBevel;
            _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
            _chartLine.lineWidth   = 2.0;
            _chartLine.strokeEnd   = 0.0;
            [self.layer addSublayer:_chartLine];
            
            UIBezierPath *progressline = [UIBezierPath bezierPath];
            CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
//            CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
            CGFloat xPosition = UUYLabelwidth;
            CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
            
            float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
            
            //First point
            BOOL isShowMaxAndMinPoint = YES;
            if (self.ShowMaxMinArray) {
                if ([self.ShowMaxMinArray[i] intValue]>0) {
                    isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
                }else{
                    isShowMaxAndMinPoint = YES;
                }
            }
            [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight+10)
                     index:i
                    isShow:isShowMaxAndMinPoint
                     value:firstValue];
            
            
            [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight+10)];
            [progressline setLineWidth:2.0];
            [progressline setLineCapStyle:kCGLineCapRound];
            [progressline setLineJoinStyle:kCGLineJoinRound];
            NSInteger index = 0;
            for (NSString * valueString in childAry) {
                
                float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
                if (index != 0) {
                    
                    CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight+10);
                    [progressline addLineToPoint:point];
                    
                    BOOL isShowMaxAndMinPoint = YES;
                    if (self.ShowMaxMinArray) {
                        if ([self.ShowMaxMinArray[i] intValue]>0) {
                            isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                        }else{
                            isShowMaxAndMinPoint = YES;
                        }
                    }
                    [progressline moveToPoint:point];
                    [self addPoint:point
                             index:i
                            isShow:isShowMaxAndMinPoint
                             value:[valueString floatValue]];
                    
                    //                [progressline stroke];
                }
                index += 1;
            }
            
            _chartLine.path = progressline.CGPath;
            if ([[_colors objectAtIndex:i] CGColor]) {
                _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
            }else{
                _chartLine.strokeColor = [UUGreen CGColor];
            }
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = childAry.count*0.4;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            
            _chartLine.strokeEnd = 1.0;
        }
    }
//    
//    for (int i=0; i<_yValues.count; i++) {
//        NSArray *childAry = _yValues[i];
//        if (childAry.count==0) {
//            return;
//        }
//        //获取最大最小位置
//        CGFloat max = [childAry[0] floatValue];
//        CGFloat min = [childAry[0] floatValue];
//        NSInteger max_i=0;
//        NSInteger min_i=0;
//        
//        for (int j=0; j<childAry.count; j++){
//            CGFloat num = [childAry[j] floatValue];
//            if (max<=num){
//                max = num;
//                max_i = j;
//            }
//            if (min>=num){
//                min = num;
//                min_i = j;
//            }
//        }
//        
//        //Score
//        CAShapeLayer *_chartLine = [CAShapeLayer layer];
//        _chartLine.lineCap = kCALineCapRound;
//        _chartLine.lineJoin = kCALineJoinBevel;
//        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
//        _chartLine.lineWidth   = 2.0;
//        _chartLine.strokeEnd   = 0.0;
//        [self.layer addSublayer:_chartLine];
//        
//        UIBezierPath *progressline = [UIBezierPath bezierPath];
//        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
//        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
//        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
//        
//        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
//       
//        //First point
//        BOOL isShowMaxAndMinPoint = YES;
//        if (self.ShowMaxMinArray) {
//            if ([self.ShowMaxMinArray[i] intValue]>0) {
//                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
//            }else{
//                isShowMaxAndMinPoint = YES;
//            }
//        }
//        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
//                 index:i
//                isShow:isShowMaxAndMinPoint
//                 value:firstValue];
//
//        
//        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
//        [progressline setLineWidth:2.0];
//        [progressline setLineCapStyle:kCGLineCapRound];
//        [progressline setLineJoinStyle:kCGLineJoinRound];
//        NSInteger index = 0;
//        for (NSString * valueString in childAry) {
//            
//            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
//            if (index != 0) {
//                
//                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
//                [progressline addLineToPoint:point];
//                
//                BOOL isShowMaxAndMinPoint = YES;
//                if (self.ShowMaxMinArray) {
//                    if ([self.ShowMaxMinArray[i] intValue]>0) {
//                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
//                    }else{
//                        isShowMaxAndMinPoint = YES;
//                    }
//                }
//                [progressline moveToPoint:point];
//                [self addPoint:point
//                         index:i
//                        isShow:isShowMaxAndMinPoint
//                         value:[valueString floatValue]];
//                
////                [progressline stroke];
//            }
//            index += 1;
//        }
//        
//        _chartLine.path = progressline.CGPath;
//        if ([[_colors objectAtIndex:i] CGColor]) {
//            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
//        }else{
//            _chartLine.strokeColor = [UUGreen CGColor];
//        }
//        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation.duration = childAry.count*0.4;
//        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//        pathAnimation.autoreverses = NO;
//        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
//        
//        _chartLine.strokeEnd = 1.0;
//    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
//        label.text = [NSString stringWithFormat:@"%d",(int)value];
        label.text = [NSString stringWithFormat:@"%.2f",value];
        [self addSubview:label];
    }
    
    [self addSubview:view];
}


@end

