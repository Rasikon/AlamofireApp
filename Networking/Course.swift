//
//  Course.swift
//  Networking
//
//  Created by Alexey Efimov on 20.09.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

struct Course: Codable {
    let name: String?
    let imageUrl: String?
//    let numberOfLessons: Int?
//    let numberOfTests: Int?
    let numberOfLessons: String?
    let numberOfTests: String?
    
    /*
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case imageUrl = "ImageUrl"
        case numberOfLessons = "Number_of_lessons"
        case numberOfTests = "Number_of_tests"
    }
    */
    
    init(courseData: [String: Any]) {
        name = courseData["name"] as? String
        imageUrl = courseData["imageUrl"] as? String
        numberOfLessons = courseData["number_of_lessons"] as? String
        numberOfTests = courseData["number_of_tests"] as? String
    }
    
    static func getCourses(from value: Any) -> [Course]? {
        guard let coursesData = value as? [[String: Any]] else { return [] }
        return coursesData.compactMap { Course(courseData: $0) }
    }
}

struct CourseData: Codable {
    let name: String
    let imageUrl: String
    let numberOfLessons: String
    let numberOfTests: String
}

struct WebsiteDescroption: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
