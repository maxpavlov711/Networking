//
//  CoursesViewController.swift
//  Networking
//
//  Created by Max Pavlov on 11.02.22.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }

    func fetchData() {
        
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_course"
        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_website_description"
//        let jsonUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_missing_or_wrong_fields"
        guard let url = URL(string: jsonUrlString) else { return }
        
        let urlSession = URLSession.shared.dataTask(with: url) { data, respose, error in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.courses = try decoder.decode([Course].self, from: data)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization JSON", error.localizedDescription)
            }

        }.resume()
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
       
        DispatchQueue.global().async {
            
            guard let image = course.imageUrl else { return }
            guard let imageUrl = URL(string: image) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        
        if let url = courseUrl {
            webViewController.couseURL = url
        }
    }
}

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        courseUrl = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "description", sender: self)
    }
}

extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    
}
