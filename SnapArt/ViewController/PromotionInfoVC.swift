//
//  PromotionInfoVC.swift
//  SnapArt
//
//  Created by Khanh Duong on 11/11/15.
//  Copyright © 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit
import SwiftyJSON

class PromotionInfoVC: CustomViewController {
    
    @IBOutlet weak var lbPromoCode: UILabel!
    
    @IBOutlet weak var lbDiscount: UILabel!
    
    @IBOutlet weak var lbStart: UILabel!
    
    @IBOutlet weak var lbEnd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBackIcon()
        getPromoInfor()
    }
    
    func pressBackIcon(sender: UIBarButtonItem!) -> Void{
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getPromoInfor(){
        let param = ["country_code" : MemoryStoreData().getString(MemoryStoreData.user_country_code)]
        let api:Api = Api()
        let parentView:UIView! = self.navigationController?.view
        api.initWaiting(parentView)
        api.execute(ApiMethod.GET, url: ApiUrl.get_promotion, parameters: param, resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
            if(dataResult.success){
                self.lbPromoCode.text = dataResult.data["code"].stringValue
                self.lbDiscount.text = dataResult.data["sale_off"].numberValue.stringValue + "% OFF"
                self.lbStart.text = "Start: " + dataResult.data["start_time"].stringValue
                self.lbEnd.text = "End: " + dataResult.data["end_time"].stringValue
            }else{
                Util().showAlert(dataResult.message, parrent: self)
            }
        })
    }
}