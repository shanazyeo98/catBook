//
//  ViewController.swift
//  BookFace
//
//  Created by Shanaz Yeo on 16/10/25.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = UITableView()
    var users: [User] = []
    var filteredUsers: [User] = []
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
    var page: Int = 0
    lazy var loadDateClosure: ([User]) -> Void = { users in
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        if users.isEmpty {
            self.isLoading = false
            return
        }
        self.page += 1
        self.users.append(contentsOf: users)
        //reapply snapshot
        DispatchQueue.main.async {
            self.applySnapshot()
            self.isLoading = false
        }
    }
    var isLoading = false
    var isSearching: Bool {
        let hasText = !(searchController.searchBar.text?.isEmpty ?? true)
        return searchController.isActive && hasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find Your Purrfect Match"
        setupUI()
        setupConstraints()
        configureDataSource()
        configureSearchController()
        Task {
            await fetchUsers()
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchUsers() async {
        guard self.isLoading == false else { return }
        self.isLoading = true
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        await NetworkManager.shared.fetchUsers(for: page, completion: loadDateClosure)
    }
    
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        activityIndicator.color = .systemBlue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meows"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, user in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
            cell.configure(user: user)
            return cell
        })
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(isSearching ? filteredUsers : users)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 && !searchController.isActive {
                self.activityIndicator.startAnimating()
                Task {
                    await fetchUsers()
                }
            }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        let detailVC = DetailViewController(user: selectedUser)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isLoading { return }
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            applySnapshot()
            return
        }
        
        filteredUsers = users.filter { $0.fullName.contains(text)}
        applySnapshot()
    }
}

#Preview {
    ViewController()
}
