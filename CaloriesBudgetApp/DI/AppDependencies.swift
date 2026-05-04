import Foundation

struct AppDependencies {
    let healthImportService: HealthImporting
    let summaryProvider: SummaryProviding
    let mainModuleBuilding: MainModuleBuilding
    let inputValidator: InputValidating

    static let live = AppDependencies(
        healthImportService: HealthImportService(),
        summaryProvider: CalorieBudgetCalculator(),
        mainModuleBuilding: MainModuleBuilder(),
        inputValidator: InputValidator()
    )
}
