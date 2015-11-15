//
//  CropItVC.swift
//  SnapArt
//
//  Created by HD on 10/31/15.
//  Copyright © 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit
import SwiftyJSON
class CropItVC: CustomViewController ,UIWebViewDelegate {
    
    @IBOutlet weak var cropBtn: UIButton!
    @IBOutlet weak var rotationBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cropWebView: UIWebView!
    internal var imageCrop:UIImage!
    internal var ratio:Float = 0

    private var TITTLE = "Crop It"
    private var ROTATE_FUNCTION = "rotateImage()"
    private var CROP_FUNCTION = "cropImage()"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TITTLE
        let api:Api = Api()
        self.containerView.backgroundColor = UIColor.clearColor()
        self.cropWebView.scrollView.scrollEnabled = false
        self.cropWebView.delegate = self
        applyBackIcon()
        self.callLoading(self.navigationController?.view)
        api.uploadFile(imageCrop,ratio:self.ratio, resulf:{(dataResult: (success: Bool, message: String!, data: String!))->() in
            if dataResult.success == true {
                let url = NSURL (string: dataResult.data)
                let requestObj = NSURLRequest(URL: url!)
                print(url)
                self.cropWebView.loadRequest(requestObj)
            } else {
                Util().showAlert(dataResult.message, parrent: self)
                self.removeLoading(self.navigationController?.view)
            }
            
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rotationTap(sender: AnyObject) {
        self.cropWebView.stringByEvaluatingJavaScriptFromString(ROTATE_FUNCTION)
    }
    
    @IBAction func cropTap(sender: AnyObject) {
        
        let json = self.cropWebView.stringByEvaluatingJavaScriptFromString(CROP_FUNCTION)
        let dic:[String:AnyObject]! = Util().convertStringToDictionary(json!)
       
        let vc = Util().getControllerForStoryBoard("PreviewVC") as! PreviewVC

        if let url = dic["url_detail"]  as? String {
            vc.previewURL = url
        }
        
        if let id = dic["id"]  as? Int {
            vc.image_id = id
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.removeLoading(self.navigationController?.view)
    }
    func webViewDidStartLoad(webView: UIWebView) {
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        self.removeLoading(self.navigationController?.view)
    }
    func pressBackIcon(sender: UIBarButtonItem!) -> Void{
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
