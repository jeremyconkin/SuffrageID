//
//  ScannerViewController.swift
//  SuffrageID
//
//  Created by Jeremy Conkin on 11/12/18.
//  Copyright © 2018 Slalom. All rights reserved.
//

import UIKit
import MicroBlink

class ScannerViewController: UIViewController, MBDocumentOverlayViewControllerDelegate  {
        
    var mrtdRecognizer : MBMrtdRecognizer?
    var usdlRecognizer : MBUsdlRecognizer?
    var eudlRecognizer : MBEudlRecognizer?
    
    static public var autoVote:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBMicroblinkSDK.sharedInstance().setLicenseKey("sRwAAAEbY29tLmplcmVteWNvbmtpbi5zdWZmcmFnZWlkCQieCDfG9KlW0e1pipTqiMQqi3LIdHmP0TXUWfJV5MCMBRMvoW54/wZy7V79+nIEI1F6g+w6PSOG+vJN0yuv52O+MNUp0dCW5goXIqEaGL3j0KLXpRiUgRtrqL6Wy5fWEUO4CvgjPWCDQZoVhkSdfswBnQRZLYYn16cF0pVLTAMgXjlNHHAQ8kTH1VhUCN3r5fQmBIIhXYjDEqrFjqf3YcrDMm0aL13U3DPjGr1G3mYu/v4KMADO9w==")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated);
        if (ScannerViewController.autoVote) {
            ScannerViewController.autoVote = false;
            performSegue(withIdentifier: "startVoting", sender: self)
        }
    }
    
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        // To specify we want to perform MRTD (machine readable travel document) recognition, initialize the MRTD recognizer settings
        self.mrtdRecognizer = MBMrtdRecognizer()
        self.mrtdRecognizer?.returnFullDocumentImage = true;
        self.mrtdRecognizer?.allowUnverifiedResults = true;
        
        /** Create usdl recognizer */
        self.usdlRecognizer = MBUsdlRecognizer()
        
        /** Create eudl recognizer */
        self.eudlRecognizer = MBEudlRecognizer()
        self.eudlRecognizer?.returnFullDocumentImage = true
        
        /** Create barcode settings */
        let settings : MBDocumentOverlaySettings = MBDocumentOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList = [self.mrtdRecognizer!, self.usdlRecognizer!, self.eudlRecognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        
        /** Create your overlay view controller */
        let documentOverlayViewController : MBDocumentOverlayViewController = MBDocumentOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunnerViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController, animated: true, completion: nil)
    }
    
    func documentOverlayViewControllerDidFinishScanning(_ documentOverlayViewController: MBDocumentOverlayViewController, state: MBRecognizerResultState) {
        /** This is done on background thread */
        documentOverlayViewController.recognizerRunnerViewController?.pauseScanning()
        
        var message: String = ""
        var title: String = ""
        
        if (self.usdlRecognizer?.result.resultState == MBRecognizerResultState.valid) {
            title = "You're Registered!"
            
            // Save the string representation of the code
            let firstName = self.usdlRecognizer?.result.getField(.CustomerFirstName) ?? "John"
            let lastName = self.usdlRecognizer?.result.getField(.CustomerFamilyName) ?? "Doe"
            
            let sexString = self.usdlRecognizer?.result.getField(.Sex);
            var gender:String
            if (sexString == "1") {
                ResultsViewController.numMales += 1
                gender = "Male"
            } else if (sexString == "2") {
                ResultsViewController.numFemales += 1
                gender = "Female"
            } else {
                ResultsViewController.numFemales += 1
                gender = "Unspecified"
            }
            let state = self.usdlRecognizer?.result.getField(.AddressJurisdictionCode) ?? "WA"
            
            message = """
            \(firstName) \(lastName)
            Gender: \(gender)
            State: \(state)
            """;
            
            //ContactCreator.CreateContact(firstName: firstName, lastName: lastName, gender: gender, state: state)
        }
        
        /** Needs to be called on main thread beacuse everything prior is on background thread */
        DispatchQueue.main.async {
            
            // present the alert view with scanned results
            let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

            ScannerViewController.autoVote = true;
            let okAction: UIAlertAction = UIAlertAction.init(title: "Start Voting", style: UIAlertAction.Style.default,
                                                             handler: { (action) -> Void in
                                                                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            documentOverlayViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func documentOverlayViewControllerDidTapClose(_ documentOverlayViewController: MBDocumentOverlayViewController) {
        
        documentOverlayViewController.dismiss(animated: true, completion: nil)
    }
}
