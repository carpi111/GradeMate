//
//  ClassButtonPage.swift
//  GradeMate
//
//  Created by Vince Carpino on 2/7/18.
//  Copyright © 2018 The Half-Blood Jedi. All rights reserved.
//

import UIKit
import FlatUIKit

class ClassButtonPage: UIView {

    @IBOutlet weak var button1: FUIButton!
    @IBOutlet weak var button2: FUIButton!
    @IBOutlet weak var button3: FUIButton!
    @IBOutlet weak var button4: FUIButton!
    @IBOutlet weak var button5: FUIButton!

    @IBAction func buttonClicked(_ sender: FUIButton) {
        print ((sender.titleLabel?.text)!)
    }
}
