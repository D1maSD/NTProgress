import UIKit
import Foundation

final class ViewController: UIViewController {
  private let server = Server()

  private var isFirstLaunch = true
  @IBOutlet weak var tableView: UITableView!

    private var allDealsBuffer: [Deal] = []
    private var timer = Timer()
    private var byAscending: Bool = true
    private var model: [Deal] = []
    private var currentSortingType: BottomSheetCellType = .date

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTimer()
    }

    private func addTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { timer in
            DispatchQueue.main.async {
                if !self.allDealsBuffer.isEmpty {
                    self.model.append(contentsOf: self.allDealsBuffer)
                    self.allDealsBuffer.removeAll() // Очищаем буфер
                    self.applySortingAndReloadData(self.model)
                    self.tableView.reloadData()
                }
            }
        }
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Deals"

      configureTableView()
      subscribeToDeals()
  }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    private func subscribeToDeals() {
        server.subscribeToDeals { deals in
            if self.isFirstLaunch {
                self.isFirstLaunch = false
                self.model.append(contentsOf: deals)
                self.applySortingAndReloadData(self.model)

                self.tableView.reloadData()
            } else {
                self.allDealsBuffer.append(contentsOf: deals)
            }
        }
    }

    private func applySortingAndReloadData(_ deals: [Deal]) {
        switch currentSortingType {
            case .price:
                let filteredDeals = sortDealsByPrice(deals)
                self.model = filteredDeals
            case .amount:
                let filteredDeals = sortDealsByAmount(deals)
                self.model = filteredDeals
            case .name:
                let filteredDeals = sortDealsByInstrumentName(deals)
                self.model = filteredDeals
            case .date:
                let filteredDeals = sortModelByDateModifier(deals)
                self.model = filteredDeals
            case .side:
                let filteredDeals = sortModelBySide(deals)
                self.model = filteredDeals
        }
        tableView.reloadData()
    }


    @IBAction func showFilter(_ sender: Any) {
        let sheet = BottomSheetViewController(delegate: self, cells: [BottomSheetCellType]())
        navigationController?.present(sheet, animated: false)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      model.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIidentifier, for: indexPath) as! DealCell
      cell.amountLabel.text = String(format: "%.0f", model[indexPath.row].amount.rounded())
      cell.priceLabel.text = String(format: "%.2f", model[indexPath.row].price.rounded(toDecimalPlaces: 2))
      cell.sideLabel.text = model[indexPath.row].sideString
      if model[indexPath.row].sideString == "Sell" {
          cell.sideLabel.textColor = .red
      } else {
          cell.sideLabel.textColor = .green
      }
      cell.instrumentNameLabel.text = String(model[indexPath.row].instrumentName)
      cell.timeLabel.text = configureTime(model[indexPath.row].dateModifier)
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCell.reuseIidentifier) as! HeaderCell
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

extension ViewController {
    func configureTableView() {
        tableView.register(UINib(nibName: DealCell.reuseIidentifier, bundle: nil), forCellReuseIdentifier: DealCell.reuseIidentifier)
        tableView.register(UINib(nibName: HeaderCell.reuseIidentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIidentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func configureTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        let dateModifier = date
        let displayDate = dateFormatter.string(from: dateModifier)
        return displayDate
    }

    func sortDealsByPrice(_ deals: [Deal]) -> [Deal] {
        let filteredDeals = byAscending ? deals.sorted(by: { $0.price > $1.price }) : deals.sorted(by: { $0.price < $1.price })
        return filteredDeals
    }
    func sortDealsByAmount(_ deals: [Deal]) -> [Deal] {
        let filteredDeals = byAscending ? deals.sorted(by: { $0.amount > $1.amount }) : deals.sorted(by: { $0.amount < $1.amount })
        return filteredDeals
    }
    func sortDealsByInstrumentName(_ deals: [Deal]) -> [Deal] {
        let filteredDeals = byAscending ? deals.sorted(by: { $0.instrumentName.count > $1.instrumentName.count }) : deals.sorted(by: { $0.instrumentName.count < $1.instrumentName.count })
        return filteredDeals
    }

    func sortModelByDateModifier(_ model: [Deal]) -> [Deal] {
        return model.sorted { (item1, item2) in
            if byAscending {
                return item1.dateModifier > item2.dateModifier
            } else {
                return item1.dateModifier < item2.dateModifier
            }
        }
    }

    func sortModelBySide(_ model: [Deal]) -> [Deal] {
        return model.sorted { (item1, item2) in
                if byAscending {
                    return (item1.side == .buy && item2.side == .sell)
                } else {
                    return (item1.side == .sell && item2.side == .buy)
                }
            }
    }
}

extension ViewController: BottomSheetDelegate {
    func setType(type: Bool) {
        byAscending = type
    }
    func dismiss() {
        print("dismiss()")
    }
    func allParameters(data: [BottomSheetCellType], type: BottomSheetType) {
        let data = data[0]
        currentSortingType = data
        switch data {
        case .price:
            let filteredDeals = self.sortDealsByPrice(self.model)
            self.model = filteredDeals
            self.tableView.reloadData()
        case .amount:
            let filteredDeals = self.sortDealsByAmount(self.model)
            self.model = filteredDeals
            self.tableView.reloadData()
        case .name:
            let filteredDeals = self.sortDealsByInstrumentName(self.model)
            self.model = filteredDeals
            self.tableView.reloadData()
        case .date:
            let filteredDeals = self.sortModelByDateModifier(self.model)
            self.model = filteredDeals
            self.tableView.reloadData()
        case .side:
            let filteredDeals = self.sortModelBySide(self.model)
            self.model = filteredDeals
            self.tableView.reloadData()
        }
    }
}
