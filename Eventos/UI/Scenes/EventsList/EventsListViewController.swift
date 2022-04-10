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

    var viewModel: EventsListViewModelContract?
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "cell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseId)
        tableView.rowHeight = EventCell.rowHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getEvents()
    }
}

extension EventsListViewController {

    private func style() {
        view.backgroundColor = .systemBackground
        title = "Lista de Eventos"
    }

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
    private func bind() {
        viewModel?.events
            .bind(to: self.tableView.rx.items(cellIdentifier: EventCell.reuseId,
                                              cellType: EventCell.self)) { _, event, cell in
                cell.configure(with: event)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Event.self)
            .bind { [weak self] event in
                guard let self = self else { return }
                print(event)
                let detailViewController = DependecyProvider.eventDetailViewController(id: Int(event.id)!)
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            .disposed(by: disposeBag)

        viewModel?.loadingIsHidden
            .bind { [weak self] in
                guard let self = self else { return }
                $0 ? self.removeSpinner() : self.showLoading()
            }
            .disposed(by: disposeBag)
    }
}
