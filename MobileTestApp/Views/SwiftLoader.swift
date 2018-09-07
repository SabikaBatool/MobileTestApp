//
//  SwiftLoader.swift
//  Art Cars
//
//  Created by IOS Developer on 29/05/2017.
//  Copyright © 2017 IOS Developer. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftLoader {
    var progressHud = MBProgressHUD()
    
    func showLoader(title : String) -> Void {
       /* if(progressHud)
        {
            // only show hud
        }
        else{
            //progressHud=nil;
            
            UIWindow *window=[[[UIApplication sharedApplication]delegate]window];
            progressHud=[[MBProgressHUD alloc]initWithView:[window.subviews lastObject]];
            [window addSubview:progressHud];
        }
        [progressHud show:NO];
        [progressHud setLabelText:message];  */
        
        let window = UIApplication.shared.keyWindow
        
        if !(window?.subviews.contains(progressHud))!{
            
            progressHud = MBProgressHUD.init(view: (window?.subviews.last!)!)
            window?.addSubview(progressHud);
        }
        progressHud.show(animated: false)
        progressHud.label.text = title
    }
    
    func hideLoader() -> Void {
        progressHud.hide(animated: false)
    }
}
