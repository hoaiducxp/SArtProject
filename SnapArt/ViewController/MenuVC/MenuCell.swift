//
//  MenuCell.swift
//  SnapArt
//
//  Created by HD on 10/12/15.
//  Copyright (c) 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var titleLb: CustomLabelGotham!
    private var  button:CustomButton!
    private var  sepView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLb.hidden = true
        self.backgroundColor = SA_STYPE.BACKGROUND_SCREEN_COLOR
        self.contentView.backgroundColor = SA_STYPE.BACKGROUND_SCREEN_COLOR
        sepView = UIView(frame: CGRectMake(0,self.frame.size.height - 1,self.frame.size.width,1))
        sepView.backgroundColor = UIColor.whiteColor()
        self.addSubview(sepView)

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> MenuCell {
        return UINib(nibName: "MenuCell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! MenuCell
    }
    
    func setTextTitle(text:String) -> Void {
        titleLb.hidden = false
        titleLb.text = text
    }
    
    func hiddenTextField(flag:Bool) -> Void {
        titleLb.hidden = flag
        sepView.hidden = true
    }
    
    func addButton(titleText:String) -> UIButton {
        titleLb.hidden = true
        sepView.hidden = true
        var rect:CGRect = self.contentView.frame
        rect.size.width = rect.size.width - 140
        rect.size.height = rect.size.height - 10
        rect.origin.y = 20
        rect.origin.x = titleLb.frame.origin.x
        let button   = UIButton(type: UIButtonType.System)
        button.frame = rect
        button.backgroundColor = SA_STYPE.BACKGROUND_BUTTON_COLOR
        button.setTitle(titleText, forState: UIControlState.Normal)
        button.setTitleColor(SA_STYPE.TEXT_BUTTON_COLOR, forState: UIControlState.Normal)
        button.setTitleColor(SA_STYPE.TEXT_BUTTON_COLOR, forState: UIControlState.Highlighted)
        button.titleLabel?.font = SA_STYPE.FONT_GOTHAM_BOLD
        self.addSubview(button)
        return button
    }
    
}
