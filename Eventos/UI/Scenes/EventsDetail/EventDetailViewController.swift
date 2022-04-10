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
        stack.addArrangedSubview(titleLabel)
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
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
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
            self.configureImage(url: URL(string: event.image))
            self.titleLabel.text = event.title
            let price = "Preço: " + event.price.currencyFormat + "\n"
            let date = "Data: " + event.convertedDate.formatted(date: .numeric, time: .shortened) + "\n\n"
            self.text.text = price + date + event.description
            self.mapViewController.setup(with: event)
        }
        .disposed(by: disposeBag)
    }

    private func configureImage(url: URL?) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        self.imageView.kf.indicatorType = .activity
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .onFailure {[weak self] _ in
                guard let self = self else { return }
                self.imageView.removeFromSuperview()
            }
            .set(to: imageView)
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
        title = "Detalhes"
        view.backgroundColor = .systemBackground
    }
}

extension EventDetailViewController {
    private func layout() {
        navigationItem.rightBarButtonItem = shareButton
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
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

        let confirmAction = UIAlertAction(title: "Confirmar", style: .default, handler: { [weak self] _ in
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
