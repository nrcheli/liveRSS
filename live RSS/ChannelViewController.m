//
//  ChannelViewController.m
//  live RSS
//
//  Created by Nishikori Makoto on 2015/06/14.
//  Copyright (c) 2015年 Makoto Nishikori. All rights reserved.
//

#import "ChannelViewController.h"
#import "ItemViewController.h"

@interface ChannelViewController ()

@end

static void startElementSAX(void *context,
                            const xmlChar *localname,
                            const xmlChar *prefix,
                            const xmlChar *URI,
                            int nb_namespaces,
                            const xmlChar **namespaces,
                            int nb_attributes,
                            int nb_defaulted,
                            const xmlChar **attributes)
{
    [(__bridge ChannelViewController*)context
     startElementLocalName:localname
     prefix:prefix URI:URI
     nb_namespaces:nb_namespaces
     namespaces:namespaces
     nb_attributes:nb_attributes
     nb_defaulted:nb_defaulted
     attributes:attributes];
}

static void endElementSAX(void *context,
                          const xmlChar *localname,
                          const xmlChar *prefix,
                          const xmlChar *URI)
{
    [(__bridge ChannelViewController*)context
     endElementLocalName:localname
     prefix:prefix
     URI:URI];
}

static void charactersFoundSAX(void *context,
                               const xmlChar *characters,
                               int length)
{
    [(__bridge ChannelViewController*)context
     charactersFound:characters len:length];
}

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    channelNames = [NSArray arrayWithObjects:@"主要", @"国内", @"海外", @"IT 経済", @"芸能", @"スポーツ", @"映画", @"グルメ", @"女子", @"トレンド", nil];
    
    channel = [NSMutableArray array];
    // Start Download
    [self download];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------//
// Table view setting //
//--------------------//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [channelNames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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

//-----------------------------//
// table row selected (detail) //
//-----------------------------//
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // instantiate
    ItemViewController* itemView = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemView"];
    
    // channel setting
    itemView.items = [[channel objectAtIndex:indexPath.row] objectForKey:@"items"];
    itemView.feedTitle = [channelNames objectAtIndex:indexPath.row];
    
    // push
    [self.navigationController pushViewController:itemView animated:YES];
}

//--------------//
// RSS download //
//--------------//
- (void)download
{
    //feed URL
    NSArray *feeds = [NSArray arrayWithObjects:
                             @"http://news.livedoor.com/topics/rss/top.xml",
                             @"http://news.livedoor.com/topics/rss/dom.xml",
                             @"http://news.livedoor.com/topics/rss/int.xml",
                             @"http://news.livedoor.com/topics/rss/eco.xml",
                             @"http://news.livedoor.com/topics/rss/ent.xml",
                             @"http://news.livedoor.com/topics/rss/spo.xml",
                             @"http://news.livedoor.com/rss/summary/52.xml",
                             @"http://news.livedoor.com/topics/rss/gourmet.xml",
                             @"http://news.livedoor.com/topics/rss/love.xml",
                             @"http://news.livedoor.com/topics/rss/trend.xml", nil];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[feeds objectAtIndex:count]]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    xmlDefaultSAXHandlerInit();
    sax.characters = charactersFoundSAX;
    sax.initialized = XML_SAX2_MAGIC;
    sax.startElementNs = startElementSAX;
    sax.endElementNs = endElementSAX;
    ctxt = xmlCreatePushParserCtxt(&sax, (__bridge void *)(self), NULL, 0, NULL);
    
    _channel = [NSMutableDictionary dictionary];
    //_currentItem = [NSMutableDictionary dictionary];
    [_channel setObject:[NSMutableArray array] forKey:@"items"];
    _currentItem = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    xmlParseChunk(ctxt, (const char*)[data bytes], (const int)[data length], 0);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Did finish loading!");
    [channel addObject:_channel];
    if (count<10-1) {
        count++;
        [self download];
    }
}

//----------------//
// libxml handler //
//----------------//
- (void)startElementLocalName:(const xmlChar*)localname
                       prefix:(const xmlChar*)prefix
                          URI:(const xmlChar*)URI
                nb_namespaces:(int)nb_namespaces
                   namespaces:(const xmlChar**)namespaces
                nb_attributes:(int)nb_attributes
                 nb_defaulted:(int)nb_defaulted
                   attributes:(const xmlChar**)attributes
{
    // channel
    if (strncmp((char*)localname, "channel", sizeof("channel")) == 0) {
        // フラグを設定する
        _isChannel = YES;
        
        return;
    }
    
    // item
    if (strncmp((char*)localname, "item", sizeof("item")) == 0) {
        // フラグを設定する
        _isItem = YES;
        
        // itemを作成する
        _currentItem = [NSMutableDictionary dictionary];
        [[_channel objectForKey:@"items"] addObject:_currentItem];
        
        return;
    }
    
    // title, link, description
    if (strncmp((char*)localname, "title", sizeof("title")) == 0 ||
        strncmp((char*)localname, "link", sizeof("link")) == 0 ||
        strncmp((char*)localname, "description", sizeof("description")) == 0)
    {
        // 文字列のためのバッファを作成する
        _currentCharacters = [NSMutableString string];// retain];
    }
}

- (void)endElementLocalName:(const xmlChar*)localname
                     prefix:(const xmlChar*)prefix URI:(const xmlChar*)URI
{
    // channel
    if (strncmp((char*)localname, "channel", sizeof("channel")) == 0) {
        // フラグをクリアする
        _isChannel = NO;
        
        return;
    }
    
    // item
    if (strncmp((char*)localname, "item", sizeof("item")) == 0) {
        // フラグをクリアする
        _isItem = NO;
        _currentItem = nil;
        
        return;
    }
    
    // title, link, description
    if (strncmp((char*)localname, "title", sizeof("title")) == 0 ||
        strncmp((char*)localname, "link", sizeof("link")) == 0 ||
        strncmp((char*)localname, "description", sizeof("description")) == 0)
    {
        // キー文字列を作成する
        NSString*   key;
        key = [NSString stringWithCString:(char*)localname encoding:NSUTF8StringEncoding];
        
        // 辞書を決定する
        NSMutableDictionary*    dict = nil;
        if (_isItem) {
            dict = _currentItem;
        }
        else if (_isChannel) {
            dict = _channel;
        }
        
        // 文字列を設定する
        [dict setObject:_currentCharacters forKey:key];
        _currentCharacters = nil;
    }
}

- (void)charactersFound:(const xmlChar*)ch
                    len:(int)len
{
    // 文字列を追加する
    if (_currentCharacters) {
        NSString*   string;
        string = [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
        [_currentCharacters appendString:string];
    }
}

@end
