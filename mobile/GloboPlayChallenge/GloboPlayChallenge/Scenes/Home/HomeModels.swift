import Foundation

enum HomeModels {
    enum FetchSections {
        struct Request { }
        struct Response {
            let novelas: [Movie]
            let series: [Movie]
            let cinema: [Movie]
        }
        struct ViewModel {
            let sections: [SectionViewModel]
        }
    }

    struct SectionViewModel {
        let title: String
        let items: [Movie]
    }
}
