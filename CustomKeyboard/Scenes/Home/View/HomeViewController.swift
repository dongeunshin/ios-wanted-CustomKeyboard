//
//  HomeViewController.swift
//  CustomKeyboard
//
//  Created by dong eun shin on 2022/07/12.
//

import UIKit

class HomeViewController: UIViewController {
    
    let homeViewModel: HomeViewModelable
    var arr: [ReviewModel] = []
    
    lazy var reviewTableview: UITableView = {
        var tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(
            ReviewTableviewCell.self,
            forCellReuseIdentifier: ReviewTableviewCell.identifier
        )
        tableview.rowHeight = 100
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    init(viewModel: HomeViewModelable) {
        self.homeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tapAddButton)
        )
        setConstraints()
        homeViewModel.reloadReviewList { result in
            switch result {
            case .success(let data):
                self.arr = data
                DispatchQueue.main.async {
                    self.reviewTableview.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func setConstraints() {
        view.addSubview(reviewTableview)
        NSLayoutConstraint.activate([
        reviewTableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        reviewTableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        reviewTableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        reviewTableview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func tapAddButton(){
        self.navigationController?.pushViewController(CreateReviewViewController(), animated: false)
    }
}

extension HomeViewController:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReviewTableviewCell.identifier,
            for: indexPath
        ) as? ReviewTableviewCell  else {
            return UITableViewCell()
        }
        let currReview = arr[indexPath.row]
        if let url = URL(string: currReview.profileImage),let data = try? Data(contentsOf: url){
            cell.userImage.image = UIImage(data: data)
        }else{
            cell.userImage.image = UIImage(systemName: "heart")
        }
        cell.userName.text = currReview.userName
        cell.condent.text = currReview.content
        return cell
    }
}



//        homeViewModel.reloadReviewList {
//            self.bind()
//        }

//    func bind(){
//        self.homeViewModel.reviewList.bind { review in
//            self.reviewList = review
//            DispatchQueue.main.async {
//              self.reviewTableview.reloadData()
//            }
//        }
//    }





// 1. 위에 같은 것들 어디에 보관하는지?
// 2-1. repository-service 생성,,,과한가?
// 2-2. completion,,너무 많,,
// 3. 구조
// MARK: - 구조 질문
//protocol API{
//    func request(httpMethod: HttpMethod)
//}
//
//class nETWORKSERVICE: API{
//    func request(httpMethod: HttpMethod) {
//        switch httpMethod {
//        case .get:
//            getRequest()
//        case .post:
//            postRequest()
//        }
//    }
//
//    private func getRequest(){
//
//    }
//    private func postRequest(){
//
//    }
//}
////class viewModel1{
////    var networkservice = nETWORKSERVICE()
////    func requestData(){
////        networkservice.request(httpMethod: .get)
////    }
////}
//
//protocol viewModelable {
//    func requestData()
//}
//
//class viewModel2{
//    var api: API
//    func requestData(){
//        api.request(httpMethod: .get)
//    }
//    init(aPI: API) {
//        self.api = aPI
//    }
//}
//
//// service - repo -> 역활이 같은데 분리되 느낌 -> 수정 필요
//// 습관 var, let -> private으로 냅다 시작...푸는 생각을 버려. 소요 시간/ 워터풀 발식 - 에자일 발식/
//// 네이밀 변경
//// 구글: okr
