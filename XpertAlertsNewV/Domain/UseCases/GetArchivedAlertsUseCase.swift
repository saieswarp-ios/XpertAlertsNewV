import Foundation

struct GetArchivedAlertsUseCase {

    private let archivedRepository: ArchivedRepository

    init(archivedRepository: ArchivedRepository) {
        self.archivedRepository = archivedRepository
    }

    func execute(
        startDate: String,
        endDate: String,
        searchByKeyword: String,
        viewByFlag: Int,
        status: Int,
        emailStatus: Int
    ) async throws -> [Alert] {

        try await archivedRepository.getArchivedAlerts(
            startDate: startDate,
            endDate: endDate,
            searchByKeyword: searchByKeyword,
            viewByFlag: viewByFlag,
            status: status,
            emailStatus: emailStatus
        )
    }
}
