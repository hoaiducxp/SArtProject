//
//  PromoCodeVC.swift
//  SnapArt
//
//  Created by HD on 11/2/15.
//  Copyright © 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit
import SwiftyJSON

class PromoCodeVC: ViewController {

    @IBOutlet weak var tfCode: UITextField!
    
    @IBOutlet weak var lbError: UILabel!
    
    let errorText = "Promo Code Not Valid"
    var countryCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
//        lbError.textColor = SA_STYPE.BORDER_TEXTFIELD_COLOR
    }

    func dismissKeyboard(){
        tfCode.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressbtnCancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pressBtnApply(sender: AnyObject) {
        Util().getCountryCode { (success) -> () in
            if(success){
                self.applyPromoCode()
            }else{
                Util().showAlert(MESSAGES.COMMON.CAN_NOT_GET_LOCATION, parrent: self)
            }
        }
    }
    
    func applyPromoCode(){
        let param = ["code" : tfCode.text!, "country_code" : MemoryStoreData().getString(MemoryStoreData.user_country_code)]
        let api = Api()
        let parentView:UIView! = self.navigationController?.view
        //api.initWaiting(parentView)
        api.execute(.GET, url: ApiUrl.get_discount_promo_code, parameters: param, resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
            print(param)
            if(dataResult.success){
                ShoppingCartVC.paymentDetail.promo_code = self.tfCode.text!
                ShoppingCartVC.discount = dataResult.data["sale_off"].numberValue.floatValue
                if(ShoppingCartVC.discount == 0){
                    self.lbError.text = self.errorText
                }else{
                    NSNotificationCenter.defaultCenter().postNotificationName(MESSAGES.NOTIFY.RESET_COST, object: nil)
                    self.pressbtnCancel("")
                }
            }else{
                self.pressbtnCancel("")
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
