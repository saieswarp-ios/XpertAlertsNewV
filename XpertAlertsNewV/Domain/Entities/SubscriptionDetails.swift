import Foundation

struct SubscriptionDetails: Decodable {

    let alertTypeId: String?
    let userSubId: Int?
    let thMins: Int?
    let subject: String?
    let alertFlag: Int?
    let aggregateJobsId: Int?
    let thDays: Int?
    let active: Int?
    let errorCode: Int?
    let threshold: Int?
    let alertDefId: Int?
    let userId: Int?
    let thHours: Int?
    let alertName: String?
    let sortOrder: Int?
    let applicationId: Int?

    // Used to prefill the email field when editing.
    let emailId: String?
}
