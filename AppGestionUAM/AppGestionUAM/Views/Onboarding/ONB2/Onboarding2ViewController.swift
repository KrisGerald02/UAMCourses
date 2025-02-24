import UIKit
import AVFoundation

class Onboarding2ViewController: UIViewController {
    
    // Outlets txtViews
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var txtvwDesc: UITextView!
    
    var playerLayer: AVPlayerLayer?
    
    // Reproductor de video
    var player: AVPlayer?
    
    // Barra de progreso circular
    let progressBar = CircularProgressBar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    @IBAction func btnSkip(_ sender: Any) {
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración del video
        setupVideoPlayer()
        
        // Desactivando interacción con Text View Descripcion
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        hideBackButton()
        setupProgressBar() // Configurar la barra de progreso
        
        // Iniciar la barra de progreso en 33% y animarla a 66%
        progressBar.setProgress(0.25, animated: false) // Inicia en 33.33%
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressBar.setProgress(0.50, animated: true) // Avanza a 66.66%
        }
    }
    
    private func setupProgressBar() {
        let screenHeight = view.bounds.height
        let yOffset = screenHeight * 0.90 // más abajo
        
        progressBar.center = CGPoint(x: view.center.x, y: yOffset)
        view.addSubview(progressBar)
        
        // Crear y configurar el botón
        let button = UIButton(frame: progressBar.frame)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(navigateToNextScreen), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func navigateToNextScreen() {
        let onboarding3 = Onboarding4ViewController()
        navigationController?.pushViewController(onboarding3, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopVideo() // Detener el video al salir de la vista
    }
    
    private func setupVideoPlayer() {
        // Ruta del video en el bundle
        guard let videoPath = Bundle.main.path(forResource: "vd_Onb2", ofType: "mov") else {
            print("Error: No se encontró el video vd_Onb2.mov en el bundle.")
            return
        }
        
        // Crear la URL del video
        let videoURL = URL(fileURLWithPath: videoPath)
        
        // Crear el reproductor
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none // Evitar detener la reproducción al terminar
        
        // Inicializar el playerLayer antes de usarlo
        playerLayer = AVPlayerLayer(player: player)
        
        // Tamaño ajustado (reducir ancho, aumentar altura)
        let videoWidth = view.frame.width * 0.4 // 40% del ancho de la pantalla
        let videoHeight = videoWidth * 12 / 9   // Relación ajustada (más alto)
        
        // Posicionar el video al centro pero más arriba
        let centerX = (view.frame.width - videoWidth) / 2
        let centerY = (view.frame.height - videoHeight) / 3 // Ajuste para que esté más arriba
        
        playerLayer?.frame = CGRect(x: centerX, y: centerY, width: videoWidth, height: videoHeight)
        playerLayer?.videoGravity = .resizeAspectFill
        
        // Añadir el video como subcapa
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        
        // Reiniciar el video cuando termine
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        // Reproducir automáticamente
        player?.play()
    }
    
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func stopVideo() {
        player?.pause()
        player?.replaceCurrentItem(with: nil) // Libera el video cargado
        playerLayer?.removeFromSuperlayer() // Elimina el layer del video
        
        // Asigna nil para liberar memoria
        player = nil
        playerLayer = nil
    }
}
