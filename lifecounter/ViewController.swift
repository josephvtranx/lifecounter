import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerOneLifeLabel: UILabel!
    @IBOutlet weak var playerTwoLifeLabel: UILabel!

    var playerOneLife = 20
    var playerTwoLife = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }

    func updateLabels() {
        playerOneLifeLabel.text = "\(playerOneLife)"
        playerTwoLifeLabel.text = "\(playerTwoLife)"
    }

    func checkLose() {
        if playerOneLife <= 0 {
            showLoseMessage(player: 1)
        }
        if playerTwoLife <= 0 {
            showLoseMessage(player: 2)
        }
    }

    func showLoseMessage(player: Int) {
        let alert = UIAlertController(
            title: "Game Over",
            message: "Player \(player) LOSES!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func playerOnePlus(_ sender: Any) {
        playerOneLife += 1
        updateLabels()
        checkLose()
    }

    @IBAction func playerOneMinus(_ sender: Any) {
        playerOneLife -= 1
        updateLabels()
        checkLose()
    }

    @IBAction func playerOnePlusFive(_ sender: Any) {
        playerOneLife += 5
        updateLabels()
        checkLose()
    }

    @IBAction func playerOneMinusFive(_ sender: Any) {
        playerOneLife -= 5
        updateLabels()
        checkLose()
    }

    @IBAction func playerTwoPlus(_ sender: Any) {
        playerTwoLife += 1
        updateLabels()
        checkLose()
    }

    @IBAction func playerTwoMinus(_ sender: Any) {
        playerTwoLife -= 1
        updateLabels()
        checkLose()
    }

    @IBAction func playerTwoPlusFive(_ sender: Any) {
        playerTwoLife += 5
        updateLabels()
        checkLose()
    }

    @IBAction func playerTwoMinusFive(_ sender: Any) {
        playerTwoLife -= 5
        updateLabels()
        checkLose()
    }
}
