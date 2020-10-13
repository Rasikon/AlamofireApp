//
//  CoursesViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 21/08/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit
import Alamofire

class CoursesViewController: UITableViewController {
    
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseCell

        let course = courses[indexPath.row]
        cell.configure(with: course)

        return cell
    }

}

// MARK: - Networking
extension CoursesViewController {
    func fetchCourses() {
//        guard let url = URL(string: URLExamples.exampleTwo.rawValue) else { return }
        guard let url = URL(string: URLExamples.exampleFive.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
//            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                self.courses = try jsonDecoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func alamofireGetButtonPressed() {
        AF.request(URLExamples.exampleTwo.rawValue)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    self.courses = Course.getCourses(from: value) ?? []
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func alamofirePostButtonPressed() {
        let courseData = [
            "name": "Networking",
            "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
            "numberOfLessons": "18",
            "numberOfTests": "10"
        ]
        
        AF.request(URLExamples.postRequest.rawValue, method: .post, parameters: courseData)
            .validate()
            .responseDecodable(of: Course.self) { dataResponse in
                switch dataResponse.result {
                case .success(let course):
                    self.courses.append(course)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
