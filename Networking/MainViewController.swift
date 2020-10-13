//
//  MainViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 21/08/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit

enum URLExamples: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case exampleOne = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    case exampleTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case exampleThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case exampleFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
    case exampleFive = "https://swiftbook.ru//wp-content/uploads/api/api_courses_capital"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
}

enum UserActions: String, CaseIterable {
    case downloadImage = "Download Image"
    case exampleOne = "Example One"
    case exampleTwo = "Example Two"
    case exampleThree = "Example Three"
    case exampleFour = "Example Four"
    case postRequest = "POST Request"
    case ourCourses = "Our Courses"
    case alamofireGet = "Alamofire GET"
    case alamofirePost = "Alamofire POST"
}

class MainViewController: UICollectionViewController {
    
    private let userActions = UserActions.allCases

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
    
        let userAction = userActions[indexPath.item]
        cell.userActionLabel.text = userAction.rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .downloadImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .exampleOne: exampleOneButtonPressed()
        case .exampleTwo: exampleTwoButtonPressed()
        case .exampleThree: exampleThreeButtonPressed()
        case .exampleFour: exampleFourButtonPressed()
        case .postRequest: postRequest()
        case .ourCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        case .alamofireGet: performSegue(withIdentifier: "alamofireGet", sender: nil)
        case .alamofirePost: performSegue(withIdentifier: "alamofirePost", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showImage" {
            let courseVC = segue.destination as! CoursesViewController
            switch segue.identifier {
            case "showCourses":
                courseVC.fetchCourses()
            case "alamofireGet":
                courseVC.alamofireGetButtonPressed()
            case "alamofirePost":
                courseVC.alamofirePostButtonPressed()
            default: break
            }
        }
    }

    // MARK: - Private Methods
    private func successAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "You can see the results in the Debug aria",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func failedAlert() {
        let alert = UIAlertController(title: "Failed",
                                      message: "You can see error in the Debug aria",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Networking
extension MainViewController {
    private func exampleOneButtonPressed() {
        guard let url = URL(string: URLExamples.exampleOne.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let course = try jsonDecoder.decode(Course.self, from: data)
                DispatchQueue.main.async {
                    self.successAlert()
                }
                print(course)
            } catch let error {
                DispatchQueue.main.async {
                    self.failedAlert()
                }
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func exampleTwoButtonPressed() {
        guard let url = URL(string: URLExamples.exampleTwo.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let courses = try jsonDecoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.successAlert()
                }
                print(courses)
            } catch let error {
                DispatchQueue.main.async {
                    self.failedAlert()
                }
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    private func exampleThreeButtonPressed() {
        guard let url = URL(string: URLExamples.exampleThree.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let websiteDescription = try jsonDecoder.decode(WebsiteDescroption.self, from: data)
                DispatchQueue.main.async {
                    self.successAlert()
                }
                print(websiteDescription)
            } catch let error {
                DispatchQueue.main.async {
                    self.failedAlert()
                }
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    private func exampleFourButtonPressed() {
        guard let url = URL(string: URLExamples.exampleFour.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let websiteDescription = try jsonDecoder.decode(WebsiteDescroption.self, from: data)
                DispatchQueue.main.async {
                    self.successAlert()
                }
                print(websiteDescription)
            } catch let error {
                DispatchQueue.main.async {
                    self.failedAlert()
                }
                print(error)
            }
        }.resume()
        
    }
    
    // Пример отправки данных на сервер со словарем
    /*
    private func postRequest() {
        guard let url = URL(string: URLExamples.postRequest.rawValue) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let courseData = ["Course": "Networking", "Lesson": "GET and POST"]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: courseData, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let response = response, let data = data else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch let  error {
                print(error)
            }
        }.resume()
    }
    */
    
    // Пример с экземпляром модели
    private func postRequest() {
        guard let url = URL(string: URLExamples.postRequest.rawValue) else { return }
        
        let course = CourseData(name: "Networking",
                            imageUrl: "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                            numberOfLessons: "10",
                            numberOfTests: "5")
        
        guard let httpBody = try? JSONEncoder().encode(course) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let response = response, let data = data else { return }
            print(response)
            
            do {
                let course = try JSONDecoder().decode(CourseData.self, from: data)
                print(course)
            } catch let  error {
                print(error)
            }
        }.resume()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
