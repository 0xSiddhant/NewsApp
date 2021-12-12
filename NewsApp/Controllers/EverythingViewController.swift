//
//  EverythingViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit
import SafariServices
import Speech

final class EverythingViewController: UITableViewController {
    //MARK: - Properties
    lazy var seachController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.delegate = self
        return sc
    }()
    lazy var viewModel: EverythingViewModel = {
        return EverythingViewModel(controller: self)
    }()
    lazy var voiceSearchBarBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = UIImage(systemName: "mic.circle.fill")
        btn.target = self
        btn.action = #selector(voiceSearchBtnAction)
        return btn
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, Article>!
    var sourceID: String?
    var sourceName: String?
    
    //MARK: Speech Recog. Variables
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isStartRecording: Bool = false {
        didSet {
            if isStartRecording {
                recordAndRecognizeSpeech()
            } else {
                cancelRecording()
            }
        }
    }
    
    
    //MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = seachController
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItems = [.init(systemItem: .action), voiceSearchBarBtn]
            navigationItem.rightBarButtonItems!.first!.menu = UIMenu(
                title: "Sort By",
                options: .destructive,
                children: fetchCategoriesList())
        } else {
            navigationItem.rightBarButtonItem = voiceSearchBarBtn
        }
        
        tableView.register(NewsFeedView.self, forCellReuseIdentifier: NewsFeedView.IDENTIFIER)
        tableView.separatorStyle = .none
        
        initializeViewModel()
        createDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.source = sourceID
        if sourceID != nil {
            viewModel.clearData()
            seachController.searchBar.becomeFirstResponder()
            navigationItem.title = sourceName ?? ""
        } else {
            navigationItem.title = "Explore News"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.source = nil
        sourceID = nil
    }
    
    @objc
    func voiceSearchBtnAction() {
        if isStartRecording {
            isStartRecording = false
        } else {
            requestSpeechAuthorization()
        }
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.isStartRecording = true
                case .denied:
                    self.sendAlert(title: "User denied access to speech recognition", message: "")
                case .restricted:
                    self.sendAlert(title: "Speech recognition restricted on this device", message: "")
                case .notDetermined:
                    self.sendAlert(title: "Speech recognition not yet authorized", message: "")
                @unknown default:
                    return
                }
            }
        }
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                self.seachController.searchBar.text = lastString
            }
//            else if let error = error {
//                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
//                print(error)
//            }
        })
    }
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Configuration Methods
    func initializeViewModel() {
        viewModel.reloadTableCallBack = { [unowned self] in
            self.seachController.dismiss(animated: true, completion: nil)
            self.populateData()
        }
        viewModel.sortType.bind { [unowned self] _ in
            if let query = self.viewModel.searchTerm,
               !query.isEmpty {
                self.viewModel.fetchData()
            }
        }
    }
    
    //MARK: Populate TableView
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Article>(tableView: tableView) { tv, indexPath, article in
            guard let cell = tv.dequeueReusableCell(withIdentifier: NewsFeedView.IDENTIFIER, for: indexPath) as? NewsFeedView else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.populateCell(article: article)
            self.viewModel.canApplyPagination(indexPath.row)
            return cell
        }
        tableView.dataSource = dataSource
    }
    
    func populateData() {
        guard let dataSource = dataSource else {
            return
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.getArticleList, toSection: 0)
        dataSource.apply(snapshot,
                         animatingDifferences: true,
                         completion: nil)
    }
    
    private func fetchCategoriesList() -> [UIMenuElement] {
        var elements = [UIMenuElement]()
        
        for sortItem in SortByList.allCases {
            let item = UIAction(title: sortItem.title
            ) { [weak self] alert in
                self?.viewModel.sortType.value = sortItem
            }
            elements.append(item)
        }
        return elements
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        
        guard let urlString = snapshot.itemIdentifiers[indexPath.row].url,
              let url = URL(string: urlString) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = true
        
        present(SFSafariViewController(url: url,
                                       configuration: config),
                animated: true,
                completion: nil)
    }
}


extension EverythingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchTerm = searchBar.text ?? ""
        if isStartRecording {
            isStartRecording = false
        }
    }
}
