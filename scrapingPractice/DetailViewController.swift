//
//  DetailViewController.swift
//  scrapingPractice
//
//  Created by Yuki Shinohara on 2020/07/10.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var mentor: Mentor!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var comment: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {[weak self] in
            self?.nameLabel.text = self?.mentor.name
            let image:UIImage = UIImage(url: self?.mentor.imageURL ?? "")
            self?.imageView.image = image
            self?.comment.text = self?.mentor.lead
        }
    }

}

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: "https://www.aeonet.co.jp" + url)
        do {
            //print(url!)//urlが間違ってる可能性あるのでちゃんとアクセスできるかブラウザ確認
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
