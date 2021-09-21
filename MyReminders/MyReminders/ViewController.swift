//
//  ViewController.swift
//  MyReminders
//
//  Created by Andres Liu on 8/5/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reminders"
        
        tableView.register(ReminderTableViewCell.nib(), forCellReuseIdentifier: ReminderTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(didTapTest))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.add, style: .done, target: self, action: #selector(didTapAdd))

    }

    
    @objc func didTapTest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                // Schedule test
                self.scheduleTest()
            }
            else if let error = error{
                print("error occurred: \(error)")
            }
        }
    }
    
    private func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.title = "my long body, long body, long body, long body"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("something went wrong")
            }
        }
    }
    
    @objc func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addVC") as? AddViewController else {
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.completion = { [weak self] title, body, date in
            let newReminder = MyReminder(title: title, date: date, identifier: body)
            self?.models.append(newReminder)
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.tableView.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.title = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("something went wrong")
                    }
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as! ReminderTableViewCell
        
        cell.config(with: models[indexPath.row])
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}
