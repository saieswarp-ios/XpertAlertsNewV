import Foundation

final class SearchRepositoryImpl: SearchRepository {

    private let localDataSource:
        SearchLocalDataSource

    init(
        localDataSource: SearchLocalDataSource
    ) {
        self.localDataSource = localDataSource
    }


  

    func saveApplicationId(
        _ applicationId: Int
    ) {

        localDataSource.saveApplicationId(
            applicationId
        )
    }

    func getApplicationId() -> Int {

        return localDataSource.getApplicationId()
    }



    func saveStartDate(
        _ date: String
    ) {

        localDataSource.saveStartDate(
            date
        )
    }

    func getStartDate() -> String {

        return localDataSource.getStartDate()
    }



    func saveEndDate(
        _ date: String
    ) {

        localDataSource.saveEndDate(
            date
        )
    }

    func getEndDate() -> String {

        return localDataSource.getEndDate()
    }
}
