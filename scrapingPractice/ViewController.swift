//
//  ViewController.swift
//  scrapingPractice
//
//  Created by Yuki Shinohara on 2020/07/10.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mentors = [Mentor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async { [weak self] in
            self?.getData()
        }
        
    }
    
    func getData(){
        AF.request("https://www.aeonet.co.jp/school/kyushu/fukuoka/4021/staff/").responseString { [weak self] (response) in
            if let html = response.value {
                
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8){
                    var names = [String]()
                    for mentorName in doc.xpath("//h4[@class='teacher-name']"){
                        names.append(mentorName.text ?? "")
                    }
                    
                    var urls = [String]()
                    let imagePath = "//div[@class='teacher-image']/img/@src"
                    for urlName in doc.xpath(imagePath){
                        urls.append(urlName.text ?? "無し")
                    }
                    
                    var comments = [String]()
                    let commentPath = "//p[@class='teacher-lead']"
                    for comment in doc.xpath(commentPath){
                        comments.append(comment.text ?? "無し")
                    }
                    
                    for (index, value) in names.enumerated(){
                        let mentor = Mentor()
                        mentor.name = value
                        mentor.imageURL = urls[index]
                        mentor.lead = comments[index]
                        self?.mentors.append(mentor)
                    }
                    
                    self?.tableView.reloadData()
                }
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let mentor = mentors[indexPath.row]
        cell.textLabel?.text = mentor.name
        cell.detailTextLabel?.text = mentor.imageURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        vc.mentor = mentors[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class Mentor {
    var name:String = ""
    var imageURL: String = ""
    var lead: String = ""
    //    init(name: String, imageURL:String) {
    //        self.name = name
    //        self.imageURL = imageURL
    //    }
}

//xpath
// タグはそのまま、階層を降りる時はスラッシュ、タグ内にアクセスは@〇〇
