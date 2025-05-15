//
//  ViewController.swift
//  memo
//
//  Created by Luca Park on 5/14/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var memoList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableSeperator()

//        for i in 0..<20 {
//            memoList.append("\(i)")
//        }
    }

    @IBAction func addMemo(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "새로운 메모", message: "메모를 작성하세요.", preferredStyle: .alert)
        alert.addTextField()

        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self.memoList.insert(text, at: 0)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(addAction)

        present(alert, animated: true)
    }

    // 내비게이션 바와 테이블 뷰 분리
    func tableSeperator() {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    //메모 없을 때 텍스트
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memoList.count == 0 {
            let label = UILabel(
                frame: CGRectMake(
                    0,
                    0,
                    view.bounds.size.width,
                    view.bounds.size.height
                )
            )
            label.text = "저장된 메모가 없습니다."
            label.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = label
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            tableView.backgroundView = nil
            return memoList.count
        }
    }

    //텍스트 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = memoList[indexPath.row]

        cell.layer.sublayers?.removeAll(where: { $0.name == "bottomLine" })

        let bottomLine = CALayer()
        bottomLine.name = "bottomLine"
        bottomLine.frame = CGRect(
            x: 0,
            y: cell.contentView.frame.height - 1,
            width: tableView.bounds.width,
            height: 1
        )
        bottomLine.backgroundColor = UIColor.systemGray5.cgColor
        cell.layer.addSublayer(bottomLine)

        return cell
    }

    // 메모 스와이프 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {}
    }

    // 메모 삭제 키워드
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}
