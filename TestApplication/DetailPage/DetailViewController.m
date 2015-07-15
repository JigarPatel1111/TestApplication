//
//  DetailViewController.m
//  TestApplication
//
//  Created by SYNC Technologies on 21/03/15.
//  Copyright (c) 2015 SYNC Technologies. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

- (IBAction)btnBackClicked:(id)sender;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - setting basic view setup
- (void) setUpView{
    //self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UIButton action events
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
