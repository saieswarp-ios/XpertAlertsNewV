//
//  GetSearchDatesUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//

import Foundation

final class GetSearchDatesUseCase {

    private let searchRepository:
        SearchRepository

    init(
        searchRepository: SearchRepository
    ) {
        self.searchRepository =
            searchRepository
    }

    func execute() -> (
        startDate: String,
        endDate: String
    ) {

        return (
            startDate:
                searchRepository.getStartDate(),

            endDate:
                searchRepository.getEndDate()
        )
    }
}
