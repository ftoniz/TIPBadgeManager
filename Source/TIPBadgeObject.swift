//
//  File.swift
//  TIPBadgeManager
//
//  Created by John Coschigano on 6/17/15.
//  Copyright (c) 2015 John Coschigano. All rights reserved.
//

import Foundation

public protocol TIPBadgeObject {
    var badgeValue: Int {get set}
}


open class TIPViewObject: NSObject, TIPBadgeObject{
    
    open var observerTriggered: Bool = false
    open var badgeValue: Int = 0 {
        willSet(newVal){
            changeBadgeValue(newVal)
        }
    }
    open var badgeInset : CGPoint = CGPoint.zero {
        didSet{
            guard badgeValue > 0 else {
                clearBadge()
                return
            }
            
            if self.badgeView == nil {
                addBadge()
            }
        }
    }
    open weak var view: UIView?
    open weak var badgeView:TIPBadgeView?
    
    public init(view: UIView){
        self.view = view
        super.init()
    }
    
    func addBadge(){
       let bv : TIPBadgeView? = TIPBadgeView()
       self.view!.addSubview(bv!)
        
       bv!.translatesAutoresizingMaskIntoConstraints = false
        
        let badgeHeightConstraint = NSLayoutConstraint(item: bv!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 18.0)
        
        bv!.addConstraints([badgeHeightConstraint])
        
        let rightConstraint = NSLayoutConstraint(item: self.view!, attribute: .right, relatedBy: .equal, toItem: bv!, attribute: .left, multiplier: 1.0, constant: 7.0 + badgeInset.x)
        
        let topConstraint = NSLayoutConstraint(item: self.view!, attribute: .top, relatedBy: .equal, toItem: bv!, attribute: .top, multiplier: 1.0, constant: 5.0 + badgeInset.y )
        
        self.view!.addConstraints([rightConstraint, topConstraint])
        
        self.badgeView = bv
    }
    
    open func changeBadgeValue(_ value : Int){
        if value > 0 {
            if self.badgeView == nil {
                addBadge()
            }
            self.badgeView!.setBadgeValue(value)
        } else {
            clearBadge()
        }
    }
    
    open func clearBadge(){
        if self.badgeView != nil {
            self.badgeView!.removeFromSuperview()
            self.badgeView = nil
        }
    }
    
}

open class TIPTabBarItemObject: NSObject, TIPBadgeObject {
    
    open weak var tabBar:UITabBarItem?
    
    open var badgeValue: Int = 0 {
        willSet(newVal){
            changeBadgeValue(newVal)
        }
    }
    
    public init(tabBar: UITabBarItem){
        self.tabBar = tabBar
        super.init()
    }
    
    open func changeBadgeValue(_ value : Int){
        if value > 0 {
            self.tabBar!.badgeValue = "\(value)"
        } else {
            self.tabBar!.badgeValue = nil
        }
    }
}
