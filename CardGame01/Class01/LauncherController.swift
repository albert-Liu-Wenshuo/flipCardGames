//
//  LauncherController.swift
//  CardGame01
//
//  Created by mac on 2018/10/19.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import UIKit

class LauncherController: UIViewController {



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pushtoCardList(_ sender: UIButton) {

        let cardlistController = CardSearchListBaseController()
        self.present(cardlistController, animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
