//
//  Recorder.swift
//  EventosTests
//
//  Created by André Felipe de Sousa Almeida - AAD on 10/04/22.
//

import Foundation
import RxSwift

class Recorder<T> {
    var items = [T]()
    let bag = DisposeBag()

    func on(arraySubject: PublishSubject<[T]>) {
        arraySubject.subscribe(onNext: { value in
            self.items = value
        }).disposed(by: bag)
    }

    func on(valueSubject: PublishSubject<T>) {
        valueSubject.subscribe(onNext: { value in
            self.items.append(value)
        }).disposed(by: bag)
    }
}
