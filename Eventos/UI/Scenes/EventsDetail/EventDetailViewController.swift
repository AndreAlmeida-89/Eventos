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

    var viewModel: EventDetailViewModelContract?
    private let disposeBag = DisposeBag()
    private let stackMargins: CGFloat = 20
    private let taxtViewkMargins: CGFloat = 16

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var text: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemBackground
        textView.contentInset = UIEdgeInsets(top: taxtViewkMargins,
                                             left: taxtViewkMargins,
                                             bottom: taxtViewkMargins,
                                             right: taxtViewkMargins)
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Faça o Check-in", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.systemPink.cgColor
        button.addTarget(self, action: #selector(chekIn), for: .touchUpInside)
        button.setImage(UIImage(systemName: "checkmark")?.withTintColor(.systemMint,
                                                                        renderingMode: .alwaysOriginal),
                        for: [])
        button.setTitleColor(.white, for: [])
        return button
    }()

    private lazy var showMapButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Veja no mapa!", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "map")?.withTintColor(.systemPink,
                                                                  renderingMode: .alwaysOriginal),
                        for: [])
        button.setTitleColor(.black, for: [])
        button.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.textAlignment = .center
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

    private lazy var mapViewController: MapViewController = {
        let mapViewController =  MapViewController()
        return mapViewController
    }()

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getEvent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        bind()
    }

}

extension EventDetailViewController {
    private func bind() {
        bindLoading()
        bindLabels()
        bindErrorAlert()
        bindCheckinCompletionAlert()
    }

    private func bindLoading() {
        viewModel?.loadingIsHidden
            .bind { [weak self] in
                guard let self = self else { return }
                $0 ? self.removeSpinner() : self.showLoading()
            }
            .disposed(by: disposeBag)
    }

    private func bindLabels() {
        viewModel?.event.bind { [weak self] event in
            guard let self = self else { return }
            let processor = RoundCornerImageProcessor(cornerRadius: 50)
            self.imageView.kf.indicatorType = .activity
            if let url = URL(string: event.image) {
                self.imageView.kf.setImage(with: url,
                                           options: [.processor(processor)])
            } else {
                self.imageView.image = UIImage(systemName: "photo")
            }
            self.text.text = event.description
            self.titleLabel.text = event.title
            self.priceAmmountLabel.text = event.price.currencyFormat
            self.dateLabel.text = event.convertedDate.formatted(date: .numeric, time: .shortened)
            self.mapViewController.setup(with: event)
        }
        .disposed(by: disposeBag)
    }

    private func bindErrorAlert() {
        viewModel?.error.bind { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Ops!",
                                          message: error.errorDescription,
                                          preferredStyle: .actionSheet)
            if error is NetworkError {
                alert.addAction(.init(title: "Voltar", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(.init(title: "Tentar novamente", style: .default, handler: { _ in
                    self.viewModel?.getEvent()
                }))
            }

            if error is CheckinError {
                alert.addAction(.init(title: "Cancelar", style: .cancel))
                alert.addAction(.init(title: "Tentar novamente", style: .default, handler: { _ in
                    self.chekIn()
                }))
            }
            self.present(alert, animated: true)
        }
        .disposed(by: disposeBag)
    }

    private func bindCheckinCompletionAlert() {
        viewModel?.onCompleteCheckin.bind { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Parabéns!!",
                                          message: "Sua inscrição foi realizada com sucesso!",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension EventDetailViewController {
    private func style() {
        self.title = "Detalhes"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
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
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 44),
            showMapButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension EventDetailViewController {
    @objc
    func share(sender: UIView) {
        guard
            let title = titleLabel.text,
            let image = imageView.image,
            let text = text.text
        else { return }
        let activityViewController = UIActivityViewController(activityItems: [title, image, text],
                                                              applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    @objc
    func chekIn() {
        let checkinAlert = UIAlertController(title: "Faça o Check-In",
                                             message: "Preencha os campos abaixo.",
                                             preferredStyle: .alert)
        checkinAlert.addTextField { field in
            field.placeholder = "Nome"
            field.returnKeyType = .next
        }

        checkinAlert.addTextField { field in
            field.placeholder = "E-mail"
            field.returnKeyType = .done
            field.keyboardType = .emailAddress
        }

        checkinAlert.addAction(UIAlertAction(title: "Cencelar", style: .cancel))

        let confirmAction = UIAlertAction(title: "Confirmar", style: .default, handler: {[weak self] _ in
            guard
                let name = checkinAlert.textFields?[0].text,
                let email = checkinAlert.textFields?[1].text,
                let self = self
            else { return }
            self.viewModel?.postCheckin(name: name, email: email)
        })

        checkinAlert.addAction(confirmAction)

        present(checkinAlert, animated: true)
    }

    @objc
    private func showMap() {
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}
