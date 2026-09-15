//
//  Untitled.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//

import Foundation

final class SaveSearchDatesUseCase {

    private let searchRepository:
        SearchRepository

    init(
        searchRepository: SearchRepository
    ) {
        self.searchRepository =
            searchRepository
    }

    func execute(
        startDate: String,
        endDate: String
    ) {

        searchRepository.saveStartDate(
            startDate
        )

        searchRepository.saveEndDate(
            endDate
        )
    }
}
