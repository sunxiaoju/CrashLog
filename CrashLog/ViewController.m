//
//  ViewController.m
//  CrashLog
//
//  Created by chedao on 17/3/15.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import "ViewController.h"
#import "CrashLog.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[CrashLog share] openCrashLogCollection];
    NSArray *arr = [[CrashLog share] readCrahLog];
    NSLog(@"%@",arr);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSArray * arr = @[@"1"];
    NSString *str = arr[2];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
