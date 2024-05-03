////
////  NewPostCameraViewController.swift
////  ElderTales
////
////  Created by student on 26/04/24.
////
//
import UIKit
import AVFoundation

class NewPostCameraViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    var recordingTimeLabel: UILabel!
    var videoOutput: AVCaptureMovieFileOutput?
    var timer: Timer?
    var outputPath:URL? = nil

    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTimingLabel()
        ensureCameraPermission()
    }
    
    func ensureCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    setupCamera()
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                self.setupCamera()
                            }
                        }
                    }
                default:
                    print("Access denied or restricted.")
            }
    }
    
    func setupTimingLabel(){
        recordingTimeLabel = UILabel()
        recordingTimeLabel.textColor = UIColor.red
        recordingTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        recordingTimeLabel.text = "00:00:00"
        
        recordingTimeLabel.sizeToFit()

        
        self.navigationItem.titleView = recordingTimeLabel
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high // High quality video output

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera),
              let audioDevice = AVCaptureDevice.default(for: .audio),
              let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else {
            print("Unable to access camera or microphone!")
            return
        }

        videoOutput = AVCaptureMovieFileOutput()

        // Adding video input
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        // Adding audio input
        if captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }

        // Adding video output
        if captureSession.canAddOutput(videoOutput!) {
            captureSession.addOutput(videoOutput!)
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = videoView.bounds
        videoView.layer.addSublayer(videoPreviewLayer)

        captureSession.startRunning()
    }

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if let output = videoOutput {
                if output.isRecording {
                    output.stopRecording()
                    recordButton.backgroundColor = UIColor.red // Stops recording, button becomes red
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMddHHmmss"
                    let dateString = dateFormatter.string(from: Date())
                    outputPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output_\(dateString).mov")

//                    let outputPath = documentsPath.appendingPathComponent("output_\(dateString).mov")
                    print("Recording to: \(outputPath!)")
                    output.startRecording(to: outputPath!, recordingDelegate: self)
                    recordButton.backgroundColor = UIColor.gray // Starts recording, button becomes gray
                }
            }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func updateRecordingTime() {
        if let currentTime = videoOutput?.recordedDuration {
            let totalSeconds = CMTimeGetSeconds(currentTime)
            let hours = Int(totalSeconds / 3600)
            let minutes = Int(totalSeconds / 60) % 60
            let seconds = Int(totalSeconds) % 60
            recordingTimeLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordingDoneAddNewPost" {
            if let destinationVC = segue.destination as? NewPostDetailsViewController{
                    destinationVC.postURL = outputPath
                }
            }
    }
    
}

extension NewPostCameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
                    // Optionally handle the file, e.g., saving the URL for further use
                    print("Recording finished successfully.")
                    self.performSegue(withIdentifier: "recordingDoneAddNewPost", sender: self)
                } else {
                    print("Recording failed: \(error!.localizedDescription)")
                }
    }
}
