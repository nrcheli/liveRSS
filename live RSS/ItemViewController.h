//
//  ItemViewController.h
//  live RSS
//
//  Created by Nishikori Makoto on 2015/06/14.
//  Copyright (c) 2015年 Makoto Nishikori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UITableViewController
{
IBOutlet UITableView*   _itemTable;
}
@property NSArray* items;
@property NSString* feedTitle;

@end
