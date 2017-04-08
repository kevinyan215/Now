//
//  Camera.swift
//  Now
//
//  Created by Kevin Yan on 2/12/17.
//  Copyright © 2017 Kevin Yan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class Camera: UIViewController, UITextFieldDelegate{
    
    private var captureSession = AVCaptureSession() //coordinate data flow
    private var cameraPreview = AVCaptureVideoPreviewLayer() //displaying the camera
    private var captureOutput = AVCaptureStillImageOutput() //use for capturing image
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool){
        countDown();
        /*---------------------------------------*/
        //monitor available capture devices
        let captureDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        
        for device in (captureDeviceDiscoverySession?.devices)!{
            if(device.position == AVCaptureDevicePosition.back){
                do{
                    let captureDeviceInput = try AVCaptureDeviceInput(device: device)
                    if captureSession.canAddInput(captureDeviceInput){
                        captureSession.addInput(captureDeviceInput)
                        
                        if captureSession.canAddOutput(captureOutput){
                            captureSession.addOutput(captureOutput)
                            captureSession.startRunning()
                            
                            cameraPreview = AVCaptureVideoPreviewLayer(session: captureSession)
                            cameraPreview.videoGravity = AVLayerVideoGravityResizeAspectFill; //fill the camera to fit the frame
                            cameraView.layer.addSublayer(cameraPreview)
                        }
                    }
                }
                catch{
                    print("error with getting devices")
                }
            }
        }
        //        self.view.bringSubview(toFront: countDown);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraPreview.frame = cameraView.bounds
    }
    
    func countDown(){
        var timeDelayed = DispatchTime.now();
        let timeStart = 5, timeEnd = 0, countDown = -1;
        for index in stride(from: timeStart, to: timeEnd-1, by: countDown){
            timeDelayed = timeDelayed + 0.5;
            DispatchQueue.main.asyncAfter(deadline: timeDelayed){
                    print(String(index));
                    self.countDownLabel.text = String(index);
                
                if index == timeEnd{
                    self.countDownLabel.text = "";
                    self.captureSession.stopRunning()
                    //self.savePicture();
                }
            }
        }
    }
    
    func savePicture(){
        let connection = captureOutput.connection(withMediaType: AVMediaTypeVideo)
        if connection != nil {
            captureOutput.captureStillImageAsynchronously(from: connection, completionHandler: {
                buffer, error in
                let photoData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                let photoImage = UIImage(data: photoData!)!
                UIImageWriteToSavedPhotosAlbum(photoImage, nil, nil, nil)
            })
        }

    }
    
}
