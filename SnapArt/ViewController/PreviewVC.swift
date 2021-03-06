//
//  PreviewVC.swift
//  SnapArt
//
//  Created by HD on 10/25/15.
//  Copyright © 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit
import AVFoundation
import AlamofireImage
import Alamofire
import SwiftyJSON

class PreviewVC: CustomViewController , UIWebViewDelegate {
    @IBOutlet weak var selectBtnView: UIView!
    @IBOutlet weak var webPreview: UIWebView!
    @IBOutlet weak var framePriceLb: CustomLabelGotham!
    
    internal var previewURL = ""
    internal var imagePreview:UIImage!
    internal static var goToScreen = "RegisterNC"
    
    private var TITTLE = "Preview"
    private var ADD_TO_CARD = "Add to card"
    private var message:String = ""
    private var unitArray:[Float]!
    
    internal static var order = Order()
    internal static var frame_size = FrameSize()
    
    private var isAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TITTLE
        self.webPreview.scrollView.scrollEnabled = false
        self.webPreview.backgroundColor = UIColor.whiteColor()
        self.callLoading(self.navigationController?.view)
        self.webPreview.delegate = self
        self.framePriceLb.text = "\(PreviewVC.frame_size.frame_size) \(PreviewVC.frame_size.price)"
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.webPreview.loadRequest(NSURLRequest(URL: NSURL(string: self.previewURL)!))
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "sendTap:")
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutLogin:", name:MESSAGES.NOTIFY.CHECKOUT_LOGIN, object: nil)
        applyBackIcon()
        
        self.getCurrentUnit({(dataResult:(message:String,values:[AnyObject]!))->() in
            self.message = dataResult.message
            if let arr = dataResult.values as? [Float] {
                self.unitArray = arr
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        isAdded = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func previewOnWallTap(sender: AnyObject) {
        self.callLoading(self.navigationController?.view)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let vc = Util().getControllerForStoryBoard("ViewOnWallVC") as! ViewOnWallVC
            vc.message = self.message
            print(self.message)
            vc.unitArray = self.unitArray
            self.createCaptureVideoPreviewLayer(vc)
            self.removeLoading(self.navigationController?.view)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func sendTap(sender: AnyObject) {
        // Test
        let textToShare = "Share image Snapart"
        
        if imagePreview != nil {
            let objectsToShare = [textToShare, imagePreview]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    // MARK: ADD TO CARD
    @IBAction func addToCartTap(sender: AnyObject) {
        self.addToCart()
    }
    
    func addToCart(){
        if(MemoryStoreData().getString(APIKEY.ACCESS_TOKEN) == ""){
            SignInVC.loginForCheckout = true
            let nv = Util().getControllerForStoryBoard(PreviewVC.goToScreen) as! CustomNavigationController
            self.navigationController?.presentViewController(nv, animated: true, completion: nil)
        }else{
            createOrder()
        }
    }
    
    func createOrder(){
        if(!isAdded){
            isAdded = true
            if(ShoppingCartVC.listCart.count >= Configs.max_order_in_transaction && MemoryStoreData().getInt(MemoryStoreData.current_order_id) == 0){
                ShoppingCartVC.errorMaxRecord = true
                let nv = Util().getControllerForStoryBoard("ShoppingCheckoutNC") as! CustomNavigationController
                self.navigationController?.presentViewController(nv, animated: true, completion: nil)
            }else{
                ShoppingCartVC.errorMaxRecord = false
                let api = Api()
                let parameters = [
                    "id": MemoryStoreData().getInt(MemoryStoreData.current_order_id),
                    "picture_id": PreviewVC.order.image_id,
                    "frame_size_id": PreviewVC.frame_size.frame_size_id,
                    "frame_size_config": PreviewVC.frame_size.frame_size_config
                ]
                print("parameters createOrder: \(parameters)")
                api.execute(.POST, url: ApiUrl.create_order_url, parameters: parameters as! [String : AnyObject], resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
                    self.isAdded = false
                    if(dataResult.success){
                        MemoryStoreData().setValue(MemoryStoreData.current_order_id, value: dataResult.data.intValue)
                        let nv = Util().getControllerForStoryBoard("ShoppingCheckoutNC") as! CustomNavigationController
                        self.navigationController?.presentViewController(nv, animated: true, completion: nil)
                    }else{
                        Util().showAlert(dataResult.message, parrent: self)
                    }
                })
            }
            
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) -> Void {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) -> Void {
        self.removeLoading(self.navigationController?.view)
        let api = Api()
        let parameters = ["id":PreviewVC.order.image_id]
        api.execute(.GET, url: ApiUrl.get_image_url, parameters: parameters, resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
            if(dataResult.success){
                if(dataResult.data != nil){
                    self.getImageFromLink(dataResult.data.stringValue)
                }
            }else{
                Util().showAlert(dataResult.message, parrent: self)
            }
        })
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) ->Void {
        self.removeLoading(self.navigationController?.view)
    }
    
    func getImageFromLink(url:String) -> Void {
        Alamofire.request(.GET, url)
            .responseImage { response in
                debugPrint(response)
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                if let image = response.result.value {
                    self.imagePreview = image
                }
        }
    }
    
    func createCaptureVideoPreviewLayer(controller: ViewOnWallVC) {
        self.callLoading(self.navigationController?.view)
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
        self.removeLoading(self.navigationController?.view)
        let captureSession = AVCaptureSession()
        let stillImageOutput = AVCaptureStillImageOutput()
        
        if let captureDevice = devices.first as? AVCaptureDevice  {
            captureSession.addInput(try! AVCaptureDeviceInput(device: captureDevice))
            captureSession.sessionPreset = AVCaptureSessionPresetMedium
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.bounds = CGRectMake(0.0, 0.0, view.bounds.size.width, view.bounds.size.height)
                previewLayer.position = CGPointMake(view.bounds.midX, view.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                let cameraPreview = UIView(frame: CGRectMake(0.0, 0.0, view.bounds.size.width, view.bounds.size.height))
                cameraPreview.layer.addSublayer(previewLayer)
                controller.view.addSubview(cameraPreview)
                controller.section = captureSession
                if self.imagePreview != nil {
                    controller.addViewPreview(self.imagePreview)
                }
            }
            
        }
    }
    
    func checkoutLogin(sender:AnyObject){
        self.addToCartTap(self)
    }
    
    func pressBackIcon(sender: UIBarButtonItem!) -> Void{
        self.navigationController?.popViewControllerAnimated(true)
    }
    private func getCurrentUnit(resulf:(String, [AnyObject]!)-> () ){
        let api = Api()
        let parameters = ["country_code" : MemoryStoreData().getString(MemoryStoreData.user_country_code)]
        api.execute(.GET, url: ApiUrl.get_scale_unit, parameters: parameters, resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
            if(dataResult.success){
                dataResult.data
                resulf(dataResult.data[Api.KEY_MESSAGE].stringValue, dataResult.data[Api.KEY_VALUE].arrayObject)
            }else{
                Util().showAlert(dataResult.message, parrent: self)
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
