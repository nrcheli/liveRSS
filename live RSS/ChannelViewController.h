//
//  ChannelViewController.h
//  live RSS
//
//  Created by Nishikori Makoto on 2015/06/14.
//  Copyright (c) 2015年 Makoto Nishikori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/tree.h>

@interface ChannelViewController : UITableViewController <NSURLConnectionDataDelegate>
{
    NSMutableData* receivedData;
    
    NSArray* channelNames;
    
    NSMutableArray* channel;

    xmlSAXHandler sax;
    xmlParserCtxtPtr ctxt;
    
    BOOL _isChannel, _isItem;
    NSMutableDictionary* _channel;
    NSMutableDictionary* _currentItem;
    NSMutableString* _currentCharacters;
    
    int count;
}

- (void)startElementLocalName:(const xmlChar*)localname
                       prefix:(const xmlChar*)prefix
                          URI:(const xmlChar*)URI
                nb_namespaces:(int)nb_namespaces
                   namespaces:(const xmlChar**)namespaces
                nb_attributes:(int)nb_attributes
                 nb_defaulted:(int)nb_defaulted
                   attributes:(const xmlChar**)attributes;

- (void)endElementLocalName:(const xmlChar*)localname
                     prefix:(const xmlChar*)prefix URI:(const xmlChar*)URI;

- (void)charactersFound:(const xmlChar*)ch
                    len:(int)len;

- (void) download;

@end
