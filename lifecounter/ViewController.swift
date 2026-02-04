import UIKit

struct Player {
    var name: String
    var life: Int
}

class ViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!

    var players: [Player] = []
    var history: [String] = []
    var gameStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }

    // MARK: - Setup Players

    func resetGame() {
        players = [
            Player(name: "Player 1", life: 20),
            Player(name: "Player 2", life: 20),
            Player(name: "Player 3", life: 20),
            Player(name: "Player 4", life: 20)
        ]
        history.removeAll()
        gameStarted = false
        addPlayerButton.isEnabled = true
        renderPlayers()
    }

    func renderPlayers() {
        // remove old views
        mainStackView.arrangedSubviews.forEach {
            if $0.tag == 100 { mainStackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        }

        for (index, player) in players.enumerated() {
            let view = makePlayerView(index: index)
            view.tag = 100
            mainStackView.addArrangedSubview(view)
        }
    }

    // MARK: - Player View

    func makePlayerView(index: Int) -> UIView {

        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false

        // Player Name
        let nameLabel = UILabel()
        nameLabel.text = players[index].name
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(renamePlayer(_:))))
        nameLabel.tag = index

        // Life Label
        let lifeLabel = UILabel()
        lifeLabel.text = "\(players[index].life)"
        lifeLabel.font = UIFont.systemFont(ofSize: 48)
        lifeLabel.textAlignment = .center
        lifeLabel.tag = 200 + index

        // Controls Row  (+  [5]  -)
        let controls = UIStackView()
        controls.axis = .horizontal
        controls.alignment = .center
        controls.spacing = 25
        controls.distribution = .fill

        let plus = UIButton(type: .system)
        plus.setTitle("+", for: .normal)
        plus.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        plus.tag = index
        plus.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)

        let amountField = UITextField()
        amountField.text = "5"
        amountField.keyboardType = .numberPad
        amountField.borderStyle = .roundedRect
        amountField.textAlignment = .center
        amountField.widthAnchor.constraint(equalToConstant: 70).isActive = true
        amountField.tag = 300 + index

        let minus = UIButton(type: .system)
        minus.setTitle("-", for: .normal)
        minus.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        minus.tag = index
        minus.addTarget(self, action: #selector(minusTapped(_:)), for: .touchUpInside)

        controls.addArrangedSubview(plus)
        controls.addArrangedSubview(amountField)
        controls.addArrangedSubview(minus)

        container.addArrangedSubview(nameLabel)
        container.addArrangedSubview(lifeLabel)
        container.addArrangedSubview(controls)

        return container
    }



    // MARK: - Actions

    @objc func plusTapped(_ sender: UIButton) {
        changeLife(for: sender.tag, positive: true)
    }

    @objc func minusTapped(_ sender: UIButton) {
        changeLife(for: sender.tag, positive: false)
    }

    func changeLife(for index: Int, positive: Bool) {
        let amountField = view.viewWithTag(300 + index) as! UITextField
        let amount = Int(amountField.text ?? "5") ?? 5

        players[index].life += positive ? amount : -amount

        let lifeLabel = view.viewWithTag(200 + index) as! UILabel
        lifeLabel.text = "\(players[index].life)"

        let msg = "\(players[index].name) \(positive ? "gained" : "lost") \(amount) life."
        history.append(msg)

        gameStarted = true
        addPlayerButton.isEnabled = false

        checkGameOver()
    }

    // MARK: - Add Player

    @IBAction func addPlayerTapped(_ sender: Any) {
        guard players.count < 8 else { return }
        players.append(Player(name: "Player \(players.count + 1)", life: 20))
        renderPlayers()
    }
    @IBAction func historyTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryViewController
        vc.history = history
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func resetGameTapped(_ sender: Any) {
        resetGame()
    }



    // MARK: - Rename

    @objc func renamePlayer(_ gesture: UITapGestureRecognizer) {
        let index = gesture.view!.tag

        let alert = UIAlertController(title: "Rename Player", message: nil, preferredStyle: .alert)
        alert.addTextField()

        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let newName = alert.textFields?.first?.text ?? ""
            self.players[index].name = newName
            self.renderPlayers()
        })

        present(alert, animated: true)
    }

    // MARK: - Game Over

    func checkGameOver() {
        let alive = players.filter { $0.life > 0 }
        if alive.count == 1 {
            let alert = UIAlertController(title: "Game Over!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.resetGame()
            })
            present(alert, animated: true)
        }
    }
}
