//
//  ItemViewController.m
//  live RSS
//
//  Created by Nishikori Makoto on 2015/06/14.
//  Copyright (c) 2015年 Makoto Nishikori. All rights reserved.
//

#import "ItemViewController.h"
#import "DetailViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.feedTitle;
    //NSDictionary* item;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

/*
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // セルを取得する
    RSSItemCell*    cell;
    cell = (RSSItemCell*)[_itemTable dequeueReusableCellWithIdentifier:@"RSSItemCell"];
    if (!cell) {
        cell = [[RSSItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"RSSItemCell"];
    }
    
    // テキストを設定する
    cell.title = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    //cell.description = [[self.items objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 90.0f;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    //self.item = [self.items objectAtIndex:indexPath.row];
    //cell.textLabel.text = [item objectForKey:@"title"];
    
    /*
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //CGRect rect = [cell frame];
    UILabel* label =  [[UILabel alloc] init];
    //label.frame = cell.contentView.bounds;
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:17.0];
    label.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    //label.frame = cell.contentView.bounds;
    label.frame = CGRectMake(0, 0, 300, 100);
    */
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel* label =  [[UILabel alloc] init];
    
    CGRect  bounds, rect;
    bounds = cell.contentView.bounds;
    
    // タイトルラベルをレイアウトする
    rect.origin.x = 8.0f;
    rect.origin.y = 8.0f;
    rect.size.width = 280.0f;//CGRectGetWidth(bounds) - 16.0f;
    rect.size.height = CGRectGetHeight(bounds) - 16.0f;
    label.frame = rect;
    
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:17.0];
    label.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    [cell.contentView addSubview:label];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 70.0f;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    CGSize maxSize = CGSizeMake(200, CGFLOAT_MAX);
    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
    
    CGSize modifiedSize = [text boundingRectWithSize:maxSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attr
                                             context:nil
                           ].size;
    
    return modifiedSize.height;
}
*/

//-----------------------------//
// table row selected (detail) //
//-----------------------------//
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // instantiate
    DetailViewController* detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    
    // link URL setting
    detailView.detailURL = [[self.items objectAtIndex:indexPath.row] objectForKey:@"link"];

    // push
    [self.navigationController pushViewController:detailView animated:YES];
}


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
