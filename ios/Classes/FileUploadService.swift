import UIKit
import Foundation
import UserNotifications

public class FileUploadService: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {

    static let shared = FileUploadService()

    private var progressCallback: ((Double) -> Void)?

    public func upload(fileUrl: String, uploadUrl: URL, progressCallback: @escaping (Double) -> Void, completion: @escaping (Bool) -> Void) {

         self.showNotification(title: "Upload Started", body: "File upload has begun.")
         self.progressCallback = progressCallback

         var request = URLRequest(url: uploadUrl);
         request.httpMethod = "POST"
         request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        let file = URL(fileURLWithPath: fileUrl)

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let uploadTask = session.uploadTask(with: request, fromFile: file) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
                self.showNotification(title: "Upload Failed", body: "An error occurred.")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Upload complete with status: \(httpResponse.statusCode)")
                self.showNotification(title: "Upload Complete", body: "File uploaded successfully.")

                completion(httpResponse.statusCode >= 200 && httpResponse.statusCode < 300)
            } else {
                self.showNotification(title: "Upload Failed", body: "An error occurred.")
                completion(false)
            }
        }
        uploadTask.resume()
    }

   public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        print("Upload progress: \(progress)")
        progressCallback?(progress)
    }

func showNotification(title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: nil // сразу
    )

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Notification error: \(error)")
        }
    }
}

}