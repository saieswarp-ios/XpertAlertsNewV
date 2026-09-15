//
//  GetSearchApplicationUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//

import Foundation

final class GetSearchApplicationUseCase {

    private let searchRepository: SearchRepository

    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }

    func execute() -> Int {
        return searchRepository.getApplicationId()
    }
}
