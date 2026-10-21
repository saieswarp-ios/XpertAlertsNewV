
import Foundation

final class UpdateForwardAlertsStatusUseCase {

    private let repository: ForwardAlertsRepository

    init(
        repository: ForwardAlertsRepository
    ) {
        self.repository = repository
    }

    func execute(
        userId: Int,
        status: Int,
        sessionId: String
    ) async throws -> UpdateForwardAlertsStatusResponse {

        return try await repository.updateForwardAlertsStatus(
            userId: userId,
            status: status,
            sessionId: sessionId
        )
    }
}
