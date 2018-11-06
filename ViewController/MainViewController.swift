//
//  ViewController.swift
//  TinderCall
//
//  Created by Olga Vorona on 19/09/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let reuseIdentifier = "timeCell"
    fileprivate let segueTimer = "showTimer"
    fileprivate let progressHUD = ProgressHUD(text: NSLocalizedString("SetupCall", comment: ""))

    fileprivate var selectedIndex = 0
    fileprivate let viewModels: [TimeViewModel] =
        [TimeViewModel(timeLabel: NSLocalizedString("3s", comment: ""), timeInterval: 3),
         TimeViewModel(timeLabel: NSLocalizedString("30s", comment: ""), timeInterval: 30),
         TimeViewModel(timeLabel: NSLocalizedString("1m", comment: ""), timeInterval: 60),
         TimeViewModel(timeLabel: NSLocalizedString("5m", comment: ""), timeInterval: 300),
         TimeViewModel(timeLabel: NSLocalizedString("10m", comment: ""), timeInterval: 600),
         TimeViewModel(timeLabel: NSLocalizedString("30m", comment: ""), timeInterval: 1800),
         TimeViewModel(timeLabel: NSLocalizedString("1h", comment: ""), timeInterval: 3600)]
    
    
    // MARK: - Outlets

    @IBOutlet weak var callerLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = CallService.shared.name
        selectedIndex = CallService.shared.selected
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CallService.shared.checkMakeCall() {
            performSegue(withIdentifier: segueTimer, sender: self)
        }
    }
    
    // MARK: - Actions

    @IBAction func callButtonAction(_ sender: Any) {
        progressHUD.show()
        let selectedModel = viewModels[selectedIndex]
        let name = nameLabel.text ?? ""
        
        CallService.shared.scheduleCall(
            with: selectedModel,
            name: name,
            selected: selectedIndex,
            success: {[weak self] in
                guard let `self` = self else {return}
                self.progressHUD.hide()
                self.performSegue(withIdentifier: self.segueTimer, sender: self)
        },
            failure: {[weak self] text in
                guard let `self` = self else { return }
                self.progressHUD.hide()
                self.performSegue(withIdentifier: self.segueTimer, sender: self)
                let banner = NotificationBanner(
                    title: NSLocalizedString("NetworkError", comment: ""),
                    subtitle: NSLocalizedString("NetworkErrorSubtitle", comment: ""),
                    style: .danger)
                banner.show()
        })
       
        AnalyticsService.shared.log(
            setupCall: name,
            time: selectedModel.timeInterval)
    }
    
    @IBAction func editNameAction(_ sender: Any) {
        let alert = UIAlertController(
            title: NSLocalizedString("RenameAlertTitle", comment: ""),
            message:"",
            preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(
            title: NSLocalizedString("RenameTitleAction", comment: ""),
            style: .default) { [unowned self] (alertAction) in
                let textField = alert.textFields![0] as UITextField
                if let text = textField.text,
                    !text.isEmpty {
                    self.nameLabel.text = textField.text
                    AnalyticsService.shared.log(select: text)
                }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("RenamePlaceholder", comment: "")
        }
        
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .cancel) { (action:UIAlertAction!) in
                AnalyticsService.shared.logCancelNamePressed()
        }
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.callSea
        
        present(
            alert,
            animated:true,
            completion: nil)
    }
    
    
}

// MARK: - Collection

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath)
        if let cell = cell as? TimeCell {
            cell.setup(
                with: viewModels[indexPath.item],
                selected: selectedIndex == indexPath.item)
        }
       
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        AnalyticsService.shared.log(select: viewModels[selectedIndex].timeInterval)
    }
    
}


