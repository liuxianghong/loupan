//
//  LPPlateTableViewController.m
//  loupan
//
//  Created by 刘向宏 on 15-4-1.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LPPlateTableViewController.h"
#import "LPMobileRequest.h"
#import "MBProgressHUD.h"

@interface LPPlateTableViewController ()
@property (nonatomic,strong) IBOutlet UITextField *nameTextField;
@property (nonatomic,strong) IBOutlet UITextField *emailTextField;
@property (nonatomic,strong) IBOutlet UITextField *mobileTextField;
@property (nonatomic,strong) IBOutlet UITextField *region_nameTextField;
@property (nonatomic,strong) IBOutlet UITextField *districtTextField;
@property (nonatomic,strong) IBOutlet UITextView *reamrkTextView;

@property (nonatomic,strong) IBOutlet UIButton *sellButton;
@property (nonatomic,strong) IBOutlet UIButton *rentButton;
@end

@implementation LPPlateTableViewController
{
    NSInteger type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    CGRect tableviewfootrect = self.tableView.tableFooterView.frame;
    tableviewfootrect.size.height = 55;
    [self.tableView.tableFooterView setFrame:tableviewfootrect];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    type = 1;
    [self modifixButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)sellButonClicked:(id)sender
{
    type = 1;
    [self modifixButton];
}

-(IBAction)RentButonClicked:(id)sender
{
    type = 2;
    [self modifixButton];
}

-(IBAction)commitButonClicked:(id)sender
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    if(self.nameTextField.text.length<1||self.emailTextField.text.length<1||self.mobileTextField.text.length<1||self.region_nameTextField.text.length<1||self.districtTextField.text.length<1||self.reamrkTextView.text.length<1)
    {
        hud.labelText = @"请完善信息";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
        return;
    }
    hud.labelText = @"上传中";
    NSString *signaturestr = [NSString stringWithFormat:@"%@%@%@%ld%@%@%@",self.nameTextField.text,self.emailTextField.text,self.mobileTextField.text,type,self.region_nameTextField.text,self.districtTextField.text,self.reamrkTextView.text];
    NSDictionary *dic = @{
                          @"name" : self.nameTextField.text,
                          @"email" : self.emailTextField.text,
                          @"mobile" : self.mobileTextField.text,
                          @"type" : @(type),
                          @"region_name" : self.region_nameTextField.text,
                          @"district" : self.districtTextField.text,
                          @"reamrk" : self.reamrkTextView.text,
                          @"signature" : [signaturestr stringFromMD5],
                          };
    [LPMobileRequest houseAddWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        hud.labelText = [responseObject[@"data"] firstObject][@"msg"];
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
    }];
}



-(void)modifixButton
{
    UIImage *imageSelected = [UIImage imageNamed:@"Plate07"];
    UIImage *imageUnSelected = [UIImage imageNamed:@"Plate06"];
    [self.sellButton setImage:(type==1?imageSelected:imageUnSelected) forState:UIControlStateNormal];
    [self.rentButton setImage:(type==2?imageSelected:imageUnSelected) forState:UIControlStateNormal];
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
