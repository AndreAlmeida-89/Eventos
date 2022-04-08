//
//  EventDetailViewController.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class EventDetailViewController: UIViewController {

    var viewModel: EventDetailViewModelContract
    private let disposeBag = DisposeBag()
    private let stackMargins: CGFloat = 20

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.kf.indicatorType = .activity
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var text: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()

    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Faça o Check-in", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.systemPink.cgColor
        return button
    }()

    private lazy var showMapButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Veja no mapa!", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "map")?.withTintColor(.systemPink,
                                                                            renderingMode: .alwaysOriginal),
                        for: [])
        button.setTitleColor(.black, for: [])
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.textAlignment = .right
        return label
    }()

    private lazy var priceAmmountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        return label
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(priceAmmountLabel)
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()

    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action,
                                     target: self,
                                     action: #selector(share(sender:)))
        return button
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: stackMargins,
                                                                 leading: stackMargins,
                                                                 bottom: stackMargins,
                                                                 trailing: stackMargins)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(infoStack)
        stack.addArrangedSubview(text)
        stack.addArrangedSubview(button)
        stack.addArrangedSubview(showMapButton)
        return stack
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let service = MockedGetEventService()
        viewModel = EventDetailViewModel(eventService: service)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getEvent(by: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        bind()
    }

    @objc func share(sender: UIView) {
        guard
            let title = titleLabel.text,
            let image = imageView.image,
            let text = text.text
        else { return }
        let activityViewController = UIActivityViewController(activityItems: [title, image, text],
                                          applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension EventDetailViewController {
    private func bind() {
        viewModel.event.bind { event in

            self.imageView.kf.setImage(with: URL(string: event.image)!,
                                       placeholder: UIImage(systemName: "xmark"),
                                       options: [.transition(.fade(1)),
                                                 .cacheOriginalImage])
            self.text.text = event.description
            self.titleLabel.text = event.title
            self.priceAmmountLabel.text = event.price.currencyFormat
            self.dateLabel.text = event.convertedDate.formatted(date: .numeric, time: .shortened)
        }
        .disposed(by: disposeBag)
    }
}

extension EventDetailViewController {
    private func style() {
        self.title = "Detalhes"
        view.backgroundColor = .systemBackground
    }
}

extension EventDetailViewController {
    private func layout() {
        navigationItem.rightBarButtonItem = shareButton
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            text.heightAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 44),
            showMapButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
