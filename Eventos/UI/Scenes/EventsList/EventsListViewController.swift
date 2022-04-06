//
//  EventsListViewController.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import UIKit
import RxCocoa
import RxSwift

class EventsListViewController: UIViewController {

    var viewModel: EventsListViewModelContract
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "cell"

    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        let remoteService = RemoteService()
        let service = EventsService(service: remoteService)
        viewModel = EventsListViewModel(eventsService: service)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getEvents()
    }
}
extension EventsListViewController {
    private func bind() {
        viewModel.events
            .bind(to: self.tableView.rx.items(cellIdentifier: cellIdentifier)) { _, event, cell in
                cell.textLabel?.text = event.title
            }
            .disposed(by: disposeBag)
    }
}

extension EventsListViewController {
    private func layout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension EventsListViewController {
    private func style() {
        view.backgroundColor = .systemBackground
    }
}
